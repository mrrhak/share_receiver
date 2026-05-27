import Flutter
import UIKit

public class ShareReceiverPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, FlutterSceneLifeCycleDelegate {
  private var eventSink: FlutterEventSink?
  private var customAppGroupId: String?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(
      name: "share_receiver_method", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(
      name: "share_receiver_event", binaryMessenger: registrar.messenger())
    let instance = ShareReceiverPlugin()

    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    registrar.addApplicationDelegate(instance)
    registrar.addSceneDelegate(instance)
    eventChannel.setStreamHandler(instance)

    Self.log("Registered successfully")
    Self.log("Main Bundle ID: \(Bundle.main.bundleIdentifier ?? "unknown")")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    Self.log("Called method: \(call.method)")

    switch call.method {
    case "initialize":
      initializeAppGroup(call: call, result: result)
    case "getInitialSharing":
      let data = getInitialSharing()
      Self.log("getInitialSharing returning: \(data)")
      result(data)
    case "clear":
      clearSharedData()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func onListen(
    withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    Self.log("EventChannel onListen called")
    self.eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    Self.log("EventChannel onCancel called")
    self.eventSink = nil
    return nil
  }

  private func initializeAppGroup(call: FlutterMethodCall, result: @escaping FlutterResult) {
    if let args = call.arguments as? [String: Any],
      let appGroupId = args["appGroupId"] as? String
    {
      self.customAppGroupId = appGroupId
      Self.log("Initialized with custom App Group: \(appGroupId)")
    } else {
      Self.log("[Initialized with default App Group")
    }
    result(nil)
  }

  /// Get App Group ID from Info.plist or custom setting or compute from bundle ID
  private func getAppGroupId() -> String {
    // 1. Try custom app group from init()
    if let custom = customAppGroupId {
      Self.log("Using custom App Group ID: \(custom)")
      return custom
    }

    // 2. Try reading from Info.plist (CUSTOM_GROUP_ID)
    if let plistGroupId = Bundle.main.object(forInfoDictionaryKey: "AppGroupId") as? String {
      Self.log("Using Info.plist App Group ID: \(plistGroupId)")
      return plistGroupId
    }

    // 3. Fallback: compute from bundle ID
    let mainBundleId = Bundle.main.bundleIdentifier ?? "com.example.app"
    let appGroupId = "group.\(mainBundleId)"
    Self.log("Using computed App Group ID: \(appGroupId)")
    return appGroupId
  }

  /// Get shared data from Share Receiver via App Group UserDefaults
  private func getInitialSharing() -> [[String: Any]] {
    let appGroupId = getAppGroupId()

    // Debug: Show container path
    if let containerURL = FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: appGroupId)
    {
      Self.log("Container URL: \(containerURL.path)")

      // Check if share_receiver directory exists and list contents
      let sharedFilesDir = containerURL.appendingPathComponent("share_receiver")
      if FileManager.default.fileExists(atPath: sharedFilesDir.path) {
        if let files = try? FileManager.default.contentsOfDirectory(
          atPath: sharedFilesDir.path)
        {
          Self.log("Files in share_receiver: \(files)")
        }
      } else {
        Self.log("share_receiver directory does not exist")
      }
    } else {
      Self.log("Cannot access container for: \(appGroupId)")
    }

    // Use system-wide shared temp directory - EXACT same path as ShareReceiver
    let sharedTmpPath = URL(fileURLWithPath: "/tmp/")
    let shareFilePath = sharedTmpPath.appendingPathComponent(
      "share_receiver_data_\(appGroupId).json")
    Self.log("Using shared system tmp: \(shareFilePath.path)")

    // Try to read shared file
    if FileManager.default.fileExists(atPath: shareFilePath.path) {
      do {
        let data = try Data(contentsOf: shareFilePath)
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
          Self.log("Found shared file data: \(json)")

          // Clean up the file after reading
          try? FileManager.default.removeItem(at: shareFilePath)
          Self.log("Cleaned up shared file")

          return [json]
        }
      } catch {
        Self.log("Error reading shared file: \(error)")
      }
    }

    // Fallback: Try App Group UserDefaults approach
    if let userDefaults = UserDefaults(suiteName: appGroupId) {
      userDefaults.synchronize()

      if let jsonString = userDefaults.string(forKey: "SHARE_DATA_KEY") {
        Self.log("Found App Group UserDefaults SHARE_DATA_KEY: \(jsonString)")
        if let data = jsonString.data(using: .utf8),
          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        {
          return [json]
        }
      }
    } else {
      Self.log("Cannot access App Group UserDefaults: \(appGroupId)")
    }

    Self.log("No shared data found")
    return []
  }

  /// Clear shared data from UserDefaults
  private func clearSharedData() {
    let appGroupId = getAppGroupId()
    guard let userDefaults = UserDefaults(suiteName: appGroupId) else {
      Self.log("Cannot access App Group UserDefaults: \(appGroupId)")
      return
    }
    userDefaults.removeObject(forKey: "SHARE_DATA_KEY")
    userDefaults.synchronize()
    Self.log("Cleared shared data")
  }

  /// Send share data through event channel
  private func sendShareDataToFlutter() {
    Self.log("sendShareDataToFlutter called, eventSink: \(eventSink != nil)")

    guard let eventSink = eventSink else {
      Self.log("No eventSink available")
      return
    }

    let data = getInitialSharing()
    if let firstItem = data.first {
      Self.log("Sending to Flutter: \(firstItem)")
      eventSink(firstItem)
    } else {
      Self.log("No data to send")
    }
  }

  private static func log(_ message: String) {
    NSLog("[ShareReceiverPlugin] \(message)")
  }
}

// MARK: - UISceneDelegate for handling scene lifecycle (Flutter >= 3.38.0)
extension ShareReceiverPlugin {
  public func sceneDidBecomeActive(_ scene: UIScene) {
    Self.log("sceneDidBecomeActive")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      self?.sendShareDataToFlutter()
    }
  }

  public func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) -> Bool {
    for context in URLContexts {
      let url = context.url
      Self.log("Open url: \(url)")
      if url.scheme?.starts(with: "ShareMedia") == true {
        Self.log("ShareMedia URL detected")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
          self?.sendShareDataToFlutter()
        }
        return true
      }
    }
    return false
  }
}

// MARK: - UIApplicationDelegate for handling app lifecycle (fallback for apps without UIScene)
extension ShareReceiverPlugin {
  public func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any] = [:]
  ) -> Bool {
    Self.log("didFinishLaunchingWithOptions")
    return true
  }

  public func applicationDidBecomeActive(_ application: UIApplication) {
    Self.log("applicationDidBecomeActive")
    // Check for new share data when app becomes active
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      self?.sendShareDataToFlutter()
    }
  }

  public func application(
    _ application: UIApplication, open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    Self.log("Open url: \(url)")
    // Handle URL scheme callback from Share Receiver
    if url.scheme?.starts(with: "ShareMedia") == true {
      Self.log("ShareMedia URL detected")
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
        self?.sendShareDataToFlutter()
      }
      return true
    }
    return false
  }
}
