import 'dart:async';

import 'src/share_receiver_event_channel.dart';
import 'src/share_receiver_platform_interface.dart';

part 'src/model/shared_data.dart';

/// Main plugin class for receiving shared content from other apps
///
/// Use [ShareReceiver.instance] to access the singleton instance.
///
/// ## Example
/// ```dart
/// class _MyAppState extends State<MyApp> {
///   SharedData? _sharedData;
///
///   @override
///   void initState() {
///     super.initState();
///     _initShareReceiver();
///   }
///
///   Future<void> _initShareReceiver() async {
///     // Get initial sharing data (if app was opened via share)
///     final initial = await ShareReceiver.instance.getInitialSharing();
///     if (initial != null) {
///       setState(() => _sharedData = initial);
///       await ShareReceiver.instance.clear();
///     }
///
///     // Listen for shares while app is running
///     ShareReceiver.instance.getMediaStream().listen((data) {
///       setState(() => _sharedData = data);
///       await ShareReceiver.instance.clear();
///     });
///   }
///
///   @override
///   void dispose() {
///     ShareReceiver.instance.dispose();
///     super.dispose();
///   }
/// }
/// ```
class ShareReceiver {
  ShareReceiver._();

  /// Singleton instance
  static final ShareReceiver instance = ShareReceiver._();

  bool _initialized = false;
  String? _appGroupId;

  /// Initialize the plugin with an optional custom App Group ID.
  ///
  /// For iOS, you can specify a custom [appGroupId] if your App Group
  /// doesn't follow the default pattern of `group.{bundleId}`.
  ///
  /// Example:
  /// ```dart
  /// await ShareReceiver.instance.initialize(
  ///   appGroupId: 'group.com.company.app',
  /// );
  /// ```
  Future<bool> initialize({String? appGroupId}) async {
    if (_initialized) return _initialized;
    final res = await ShareReceiverPlatform.instance.initialize(
      appGroupId: appGroupId,
    );
    _appGroupId = appGroupId;
    return res;
  }

  /// Get initial sharing data when app starts.
  ///
  /// Call this method when your app initializes to check if the app was
  /// launched via a share action.
  ///
  /// Returns [SharedData] if there is shared content, or `null` if the app
  /// was opened normally.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   _checkInitialShare();
  /// }
  ///
  /// Future<void> _checkInitialShare() async {
  ///   final data = await ShareReceiver.instance.getInitialSharing();
  ///   if (data != null) {
  ///     print('App opened with shared content: $data');
  ///   }
  /// }
  /// ```
  Future<SharedData?> getInitialSharing() async {
    try {
      if (!_initialized) await initialize(appGroupId: _appGroupId);
      return await ShareReceiverPlatform.instance.getInitialSharing();
    } catch (_) {
      return null;
    }
  }

  /// Clear all sharing data.
  ///
  /// Call this after you've processed the shared content to prevent
  /// it from being read again.
  ///
  /// Example:
  /// ```dart
  /// final data = await ShareReceiver.instance.getInitialSharing();
  /// if (data != null) {
  ///   print('Data received: $data');
  ///   await ShareReceiver.instance.clear();
  /// }
  /// ```
  Future<void> clear() => ShareReceiverPlatform.instance.clear();

  /// Sets up a broadcast stream for receiving incoming media share change events.
  ///
  /// Returns a [Stream] of [SharedData] that emits whenever new content is shared
  /// to this app while it's running.
  ///
  /// Example:
  /// ```dart
  /// ShareReceiver.instance.getMediaStream().listen((data) {
  ///   if (data.isImage) {
  ///     print('Image received: ${data.filePaths}');
  ///   } else if (data.isText) {
  ///     print('Text received: ${data.text}');
  ///   }
  ///   await ShareReceiver.instance.clear();
  /// });
  /// ```
  Stream<SharedData> getMediaStream() {
    return ShareReceiverEventChannel.instance.getMediaStream();
  }

  /// Dispose all resources.
  ///
  /// Call this when your app is being disposed to clean up resources.
  void dispose() {
    _initialized = false;
    ShareReceiverEventChannel.instance.dispose();
  }
}
