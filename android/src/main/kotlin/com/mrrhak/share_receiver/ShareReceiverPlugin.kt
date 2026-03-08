package com.mrrhak.share_receiver

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.io.File

/** ShareReceiverPlugin */
class ShareReceiverPlugin :
    FlutterPlugin,
    MethodCallHandler,
    EventChannel.StreamHandler,
    ActivityAware,
    PluginRegistry.NewIntentListener {

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private var activity: Activity? = null
    private var context: Context? = null
    private var initialShareData: Map<String, Any?>? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "share_receiver_method")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "share_receiver_event")
        eventChannel.setStreamHandler(this)

        Log.i("ShareReceiverPlugin", "Registered successfully")
        Log.i("ShareReceiverPlugin", "Main Application ID: ${context?.packageName}")
    }

    override fun onDetachedFromEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        context = null
    }

    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        activity = activityPluginBinding.activity
        activityPluginBinding.addOnNewIntentListener(this)
        processInitialIntent()
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(activityPluginBinding: ActivityPluginBinding) {
        activity = activityPluginBinding.activity
        activityPluginBinding.addOnNewIntentListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onNewIntent(intent: Intent): Boolean {
        val shareData = processIntent(intent)
        if (shareData != null) {
            eventSink?.success(shareData)
            return true
        }
        return false
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if(call.method == "initialize") {
            result.success(null)
        } else if(call.method == "getInitialSharing") {
            Log.i("ShareReceiverPlugin", "getInitialSharing returning: $initialShareData")
            result.success(initialShareData)
        } else if(call.method == "clear") {
            Log.i("ShareReceiverPlugin", "Cleared shared data")
            initialShareData = null
            result.success(null)
        } else {
            result.notImplemented()
        }
    }

    private fun processInitialIntent() {
        activity?.intent?.let { intent ->
            val shareData = processIntent(intent)
            if (shareData != null && initialShareData == null) {
                initialShareData = shareData
            }
        }
    }

    private fun processIntent(intent: Intent): Map<String, Any?>? {
        val action = intent.action
        val type = intent.type ?: return null

        if (action != Intent.ACTION_SEND && action != Intent.ACTION_SEND_MULTIPLE) {
            return null
        }

        return when {
            type.startsWith("text/") -> handleTextShare(intent)
            else -> handleFileShare(intent)
        }
    }

    private fun handleTextShare(intent: Intent): Map<String, Any?> {
        val text = intent.getStringExtra(Intent.EXTRA_TEXT)
        val subject = intent.getStringExtra(Intent.EXTRA_SUBJECT)
        
        return mapOf(
            "text" to text,
            "mimeType" to intent.type,
            "filePaths" to emptyList<String>(),
            "extraData" to mapOf(
                "subject" to subject,
                "title" to intent.getStringExtra(Intent.EXTRA_TITLE)
            )
        )
    }

    private fun handleFileShare(intent: Intent): Map<String, Any?> {
        val filePaths = mutableListOf<String>()
        
        when (intent.action) {
            Intent.ACTION_SEND -> {
                intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)?.let { uri ->
                    copyUriToCache(uri)?.let { filePaths.add(it) }
                }
            }
            Intent.ACTION_SEND_MULTIPLE -> {
                intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM)?.forEach { uri ->
                    copyUriToCache(uri)?.let { filePaths.add(it) }
                }
            }
        }
        
        return mapOf(
            "text" to intent.getStringExtra(Intent.EXTRA_TEXT),
            "filePaths" to filePaths,
            "mimeType" to intent.type,
            "extraData" to mapOf(
                "subject" to intent.getStringExtra(Intent.EXTRA_SUBJECT),
                "title" to intent.getStringExtra(Intent.EXTRA_TITLE)
            )
        )
    }

    private fun copyUriToCache(uri: Uri): String? {
        return try {
            context?.let { ctx ->
                val inputStream = ctx.contentResolver.openInputStream(uri) ?: return null
                val fileName = getFileName(uri) ?: "share_receiver_${System.currentTimeMillis()}"
                val cacheDir = File(ctx.cacheDir, "share_receiver")
                cacheDir.mkdirs()
                
                val cacheFile = File(cacheDir, fileName)
                inputStream.use { input ->
                    cacheFile.outputStream().use { output ->
                        input.copyTo(output)
                    }
                }
                cacheFile.absolutePath
            }
        } catch (e: Exception) {
            Log.e("ShareReceiverPlugin", "Error copying file from URI", e)
            null
        }
    }

    private fun getFileName(uri: Uri): String? {
        return try {
            context?.contentResolver?.query(uri, null, null, null, null)?.use { cursor ->
                if (cursor.moveToFirst()) {
                    val nameIndex = cursor.getColumnIndex("_display_name")
                    if (nameIndex >= 0) cursor.getString(nameIndex) else null
                } else null
            }
        } catch (e: Exception) {
            null
        }
    }
}
