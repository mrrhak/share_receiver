import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers

open class ShareReceiverServiceViewController: SLComposeServiceViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        print("🚀 [ShareReceiver] viewDidLoad called")
        
        //* Hide the UI to make it seamless
        self.view.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //* Process the shared content and navigate to main app
        DispatchQueue.main.async { self.handleSharedContent() }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("🚀 [ShareReceiver] viewDidAppear called")
        
        //* Close extension immediately to avoid UI issues
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.completeShareReceiver(returningItems: [])
        }
    }
    
    open override func isContentValid() -> Bool {
        //* Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    open override func didSelectPost() {
        print("🚀 [ShareReceiver] didSelectPost called")
        handleSharedContent()
    }

    open override func configurationItems() -> [Any]! {
        //* To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    private func handleSharedContent() {
       guard let extensionContext = extensionContext else {
           print("❌ [ShareReceiver] No extension context")
           completeShareReceiver()
           return
       }
       
       print("🔍 [ShareReceiver] Starting to process shared content")
       let inputItems = extensionContext.inputItems
       print("📦 [ShareReceiver] Total input items: \(inputItems.count)")
       
       //* Log detailed information about what iOS is sending
       for (itemIndex, inputItem) in inputItems.enumerated() {
           guard let item = inputItem as? NSExtensionItem else { 
               print("⚠️ [ShareReceiver] Item \(itemIndex) is not NSExtensionItem")
               continue 
           }
           
           print("📝 [ShareReceiver] Input Item \(itemIndex):")
           print("   - Title: \(item.attributedTitle?.string ?? "nil")")
           print("   - Content: \(item.attributedContentText?.string ?? "nil")")
           print("   - Attachments count: \(item.attachments?.count ?? 0)")
           
           if let attachments = item.attachments {
               for (attachmentIndex, attachment) in attachments.enumerated() {
                   print("📎 [ShareReceiver] Attachment index: \(attachmentIndex)")
                   print("   - Registered types: \(attachment.registeredTypeIdentifiers)")
               }
           }
       }
       
       let attachments = extensionContext.inputItems
           .compactMap { $0 as? NSExtensionItem }
           .flatMap { $0.attachments ?? [] }
       
       print("🔄 [ShareReceiver] Flattened attachments count: \(attachments.count)")
       
       if attachments.isEmpty {
           print("❌ [ShareReceiver] No attachments to process")
           completeShareReceiver()
           return
       }
       
       var shareData: [String: Any] = [:]
       var allFilePaths: [String] = []
       var allTextContent: [String] = []
       let group = DispatchGroup()
       
       for (attachmentIndex, attachment) in attachments.enumerated() {
           print("🔄 [ShareReceiver] Processing attachment index: \(attachmentIndex)")
           group.enter()
           
           // Process files first (prioritize files over text/URLs)
           if attachment.hasItemConformingToTypeIdentifier("public.file-url") {
               print("📁 [ShareReceiver] Processing file URL attachment index: \(attachmentIndex)")
               attachment.loadItem(forTypeIdentifier: "public.file-url", options: nil) { [weak self] (item, error) in
                   self?.processShareItem(item: item, error: error, index: attachmentIndex, allFilePaths: &allFilePaths, allTextContent: &allTextContent)
                   group.leave()
               }
           } else if attachment.hasItemConformingToTypeIdentifier("public.image") {
               print("🖼️ [ShareReceiver] Processing image attachment index: \(attachmentIndex)")
               attachment.loadItem(forTypeIdentifier: "public.image", options: nil) { [weak self] (item, error) in
                   self?.processShareItem(item: item, error: error, index: attachmentIndex, allFilePaths: &allFilePaths, allTextContent: &allTextContent)
                   group.leave()
               }
           } else if attachment.hasItemConformingToTypeIdentifier("public.movie") {
               print("🎬 [ShareReceiver] Processing video attachment index: \(attachmentIndex)")
               attachment.loadItem(forTypeIdentifier: "public.movie", options: nil) { [weak self] (item, error) in
                   self?.processShareItem(item: item, error: error, index: attachmentIndex, allFilePaths: &allFilePaths, allTextContent: &allTextContent)
                   group.leave()
               }
           } else if attachment.hasItemConformingToTypeIdentifier("public.audio") {
               print("🎵 [ShareReceiver] Processing audio attachment index: \(attachmentIndex)")
               attachment.loadItem(forTypeIdentifier: "public.audio", options: nil) { [weak self] (item, error) in
                   self?.processShareItem(item: item, error: error, index: attachmentIndex, allFilePaths: &allFilePaths, allTextContent: &allTextContent)
                   group.leave()
               }
           } else if attachment.hasItemConformingToTypeIdentifier("com.adobe.pdf") {
               print("📄 [ShareReceiver] Processing PDF attachment index: \(attachmentIndex)")
               attachment.loadItem(forTypeIdentifier: "com.adobe.pdf", options: nil) { [weak self] (item, error) in
                   self?.processShareItem(item: item, error: error, index: attachmentIndex, allFilePaths: &allFilePaths, allTextContent: &allTextContent)
                   group.leave()
               }
           } else if attachment.hasItemConformingToTypeIdentifier("public.data") {
               print("📎 [ShareReceiver] Processing data attachment index: \(attachmentIndex)")
               attachment.loadItem(forTypeIdentifier: "public.data", options: nil) { [weak self] (item, error) in
                   self?.processShareItem(item: item, error: error, index: attachmentIndex, allFilePaths: &allFilePaths, allTextContent: &allTextContent)
                   group.leave()
               }
           } else if attachment.hasItemConformingToTypeIdentifier("public.plain-text") {
               print("📝 [ShareReceiver] Processing text attachment index: \(attachmentIndex)")
               attachment.loadItem(forTypeIdentifier: "public.plain-text", options: nil) { [weak self] (item, error) in
                   if let error = error {
                       print("❌ [ShareReceiver] Error loading text: \(error)")
                   } else if let text = item as? String {
                       print("✅ [ShareReceiver] Got text: \(text)")
                       allTextContent.append(text)
                   }
                   group.leave()
               }
           } else if attachment.hasItemConformingToTypeIdentifier("public.url") {
               print("🔗 [ShareReceiver] Processing URL attachment index: \(attachmentIndex)")
               attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { [weak self] (item, error) in
                   if let error = error {
                       print("❌ [ShareReceiver] Error loading URL: \(error)")
                   } else if let url = item as? URL {
                       print("✅ [ShareReceiver] Got URL: \(url.absoluteString)")
                       allTextContent.append(url.absoluteString)
                   }
                   group.leave()
               }
           } else {
               print("❓ [ShareReceiver] Unknown attachment type index: \(attachmentIndex), trying first registered type")
               let typeIdentifier = attachment.registeredTypeIdentifiers.first ?? "public.data"
               attachment.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { [weak self] (item, error) in
                   // Try to process as file first, then as text
                   if let url = item as? URL {
                       print("✅ [ShareReceiver] Got generic file URL: \(url.path)")
                       allFilePaths.append(url.path)
                   } else if let text = item as? String {
                       print("✅ [ShareReceiver] Got generic text: \(text)")
                       allTextContent.append(text)
                   } else {
                       print("⚠️ [ShareReceiver] Generic item is neither URL nor String: \(type(of: item))")
                   }
                   group.leave()
               }
           }
       }
       
       group.notify(queue: .main) { [weak self] in
           print("🎯 [ShareReceiver] Processing complete!")
           print("   📁 File paths found: \(allFilePaths.count)")
           for (index, path) in allFilePaths.enumerated() {
               print("      \(index + 1). \(path)")
           }
           print("   📝 Text content found: \(allTextContent.count)")
           for (index, text) in allTextContent.enumerated() {
               print("      \(index + 1). \(text.prefix(100))...")
           }
           
           // Prepare share data
           if !allFilePaths.isEmpty {
               shareData["filePaths"] = allFilePaths
               shareData["mimeType"] = self?.getFileMimeType(from: allFilePaths.first ?? "") ?? "application/octet-stream"
           }
           
           if !allTextContent.isEmpty {
               shareData["text"] = allTextContent.joined(separator: "\n")
               if shareData["mimeType"] == nil {
                   shareData["mimeType"] = "text/plain"
               }
           }
           
           print("📋 [ShareReceiver] Final share data: \(shareData)")
           self?.saveShareData(shareData)
           self?.redirectToMainApp()
       }
   }

    private func processShareItem(item: Any?, error: Error?, index: Int, allFilePaths: inout [String], allTextContent: inout [String]) {
        if let error = error {
            print("❌ [ShareReceiver] Error loading file \(index): \(error)")
            return
        }

        guard let appGroupId = Bundle.main.object(
            forInfoDictionaryKey: "AppGroupId"
        ) as? String else {
            print("❌ [ShareReceiver] AppGroupId missing")
            return
        }

        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupId
        ) else {
            print("❌ [ShareReceiver] Cannot access App Group container")
            return
        }

        if let sourceURL = item as? URL {
            let fileName = UUID().uuidString + "." + sourceURL.pathExtension
            let destinationURL = containerURL.appendingPathComponent(fileName)

            do {
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(at: destinationURL)
                }

                try FileManager.default.copyItem(
                    at: sourceURL,
                    to: destinationURL
                )

                print("✅ [ShareReceiver] File copied to shared container:")
                print("   \(destinationURL.path)")

                allFilePaths.append(destinationURL.path)

            } catch {
                print("❌ [ShareReceiver] Failed copying file: \(error)")
            }
        } else if let image = item as? UIImage {
            let hasAlpha = image.cgImage?.alphaInfo == .first ||
                           image.cgImage?.alphaInfo == .last ||
                           image.cgImage?.alphaInfo == .premultipliedFirst ||
                           image.cgImage?.alphaInfo == .premultipliedLast
            
            let ext = hasAlpha ? "png" : "jpg"
            let fileName = UUID().uuidString + ".\(ext)"
            let destinationURL = containerURL.appendingPathComponent(fileName)

            do {
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(at: destinationURL)
                }

                let imageData = hasAlpha ? image.pngData() : image.jpegData(compressionQuality: 0.9)

                if let data = imageData {
                    try data.write(to: destinationURL)
                    print("✅ [ShareReceiver] Image saved as \(ext) to shared container:")
                    print("   \(destinationURL.path)")
                    allFilePaths.append(destinationURL.path)
                } else {
                    print("❌ [ShareReceiver] Failed to get \(ext) data from UIImage")
                }
            } catch {
                print("❌ [ShareReceiver] Failed saving image file: \(error)")
            }
        } else if let text = item as? String {
            print("✅ [ShareReceiver] Got string text instead of file: \(text)")
            allTextContent.append(text)
        } else {
            print("⚠️ [ShareReceiver] Item \(index) is neither URL nor UIImage nor String. Type: \(String(describing: type(of: item)))")
            return
        }
    }
   
   private func getFileMimeType(from path: String) -> String {
       let fileExtension = path.lowercased().split(separator: ".").last?.description ?? ""
       
       switch fileExtension {
       case "jpg", "jpeg":
           return "image/jpeg"
       case "png":
           return "image/png"
       case "gif":
           return "image/gif"
       case "bmp":
           return "image/bmp"
       case "heic", "heif":
           return "image/heic"
       case "mp4":
           return "video/mp4"
       case "mov":
           return "video/quicktime"
       case "avi":
           return "video/x-msvideo"
       case "mp3":
           return "audio/mpeg"
       case "wav":
           return "audio/wav"
       case "m4a":
           return "audio/mp4"
       case "pdf":
           return "application/pdf"
       case "doc":
           return "application/msword"
       case "docx":
           return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
       case "xls":
           return "application/vnd.ms-excel"
       case "xlsx":
           return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
       case "zip":
           return "application/zip"
       case "txt":
           return "text/plain"
       case "html":
           return "text/html"
       case "json":
           return "application/json"
       default:
           return "application/octet-stream"
       }
   }
   
   private func saveShareData(_ data: [String: Any]) {
       guard let appGroupId = Bundle.main.object(forInfoDictionaryKey: "AppGroupId") as? String else {
           print("❌ [ShareReceiver] AppGroupId not found in Info.plist")
           return
       }
       
       // Save to system temp file for iOS Simulator compatibility (same path as plugin)
       let sharedTmpPath = URL(fileURLWithPath: "/tmp/")
       let shareFilePath = sharedTmpPath.appendingPathComponent("share_receiver_data_\(appGroupId).json")
       print("✅ [ShareReceiver] Using shared system tmp: \(shareFilePath.path)")
       
       do {
           let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
           try jsonData.write(to: shareFilePath)
           print("✅ [ShareReceiver] Data saved successfully to temp file: \(shareFilePath.path)")
           
           if let jsonString = String(data: jsonData, encoding: .utf8) {
               print("✅ [ShareReceiver] Saved data: \(jsonString)")
           }
       } catch {
           print("❌ [ShareReceiver] Error saving to temp file: \(error)")
       }
       
       // Try UserDefaults with App Groups, fall back to standard UserDefaults
       var userDefaults: UserDefaults?
       if let groupDefaults = UserDefaults(suiteName: appGroupId) {
           userDefaults = groupDefaults
           print("✅ [ShareReceiver] Using App Group UserDefaults: \(appGroupId)")
       } else {
           userDefaults = UserDefaults.standard
           print("✅ [ShareReceiver] Fallback to standard UserDefaults")
       }
       
       if let userDefaults = userDefaults {
           // Clear existing data first to avoid stale data
           userDefaults.removeObject(forKey: "SHARE_DATA_KEY")
           userDefaults.synchronize()
           
           // Save data in multiple formats for compatibility
           do {
               let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
               if let jsonString = String(data: jsonData, encoding: .utf8) {
                   // Primary key used by Flutter plugin
                   userDefaults.set(jsonString, forKey: "SHARE_DATA_KEY")
                   
                   userDefaults.synchronize()
                   print("✅ [ShareReceiver] Share data saved successfully with keys: SHARE_DATA_KEY")
                   print("✅ [ShareReceiver] Saved data: \(jsonString)")
               }
           } catch {
               print("❌ [ShareReceiver] Failed to serialize share data: \(error)")
           }
       }
   }
   
   private func redirectToMainApp() {
       var bundleId = Bundle.main.object(forInfoDictionaryKey: "MainAppBundleId") as? String
        
        if bundleId == nil {
            if let extBundleId = Bundle.main.bundleIdentifier {
                // To support any custom extension name, we dynamically find the main app's bundle ID
                // by removing the last dot-separated component (e.g. com.example.app.MyExtension -> com.example.app)
                if let lastDotIndex = extBundleId.lastIndex(of: ".") {
                    bundleId = String(extBundleId[..<lastDotIndex])
                } else {
                    bundleId = extBundleId
                }
            }
        }
        
        guard let mainBundleId = bundleId else {
            print("❌ [ShareReceiver] MainAppBundleId not found in Info.plist and could not be derived")
            completeShareReceiver()
            return
        }
        
        let urlScheme = "ShareMedia-\(mainBundleId)://"
        guard let url = URL(string: urlScheme) else {
            print("❌ [ShareReceiver] Failed to create URL with scheme: \\(urlScheme)")
            completeShareReceiver()
            return
        }
       
       if #available(iOS 18.0, *) {
           // iOS 18+ approach
           var responder: UIResponder? = self
           while responder != nil {
               if let app = responder as? UIApplication {
                   app.open(url, options: [:], completionHandler: { [weak self] success in
                       print("🚀 [ShareReceiver] App launch \(success ? "successful" : "failed")")
                       DispatchQueue.main.async {
                           self?.completeShareReceiver()
                       }
                   })
                   break
               }
               responder = responder?.next
           }
       } else {
           // iOS 13-17 approach using selector
           var responder: UIResponder? = self
           let selectorOpenURL = sel_registerName("openURL:")
           while responder != nil {
               if responder?.responds(to: selectorOpenURL) == true {
                   _ = responder?.perform(selectorOpenURL, with: url)
                   print("🚀 [ShareReceiver] Attempted to open URL via selector")
                   break
               }
               responder = responder?.next
           }
           completeShareReceiver()
       }
   }
   
   private func completeShareReceiver(returningItems items: [Any]? = nil, completionHandler: (@Sendable (Bool) -> Void)? = nil) {
       extensionContext?.completeRequest(returningItems: items, completionHandler: completionHandler)
   }
}
