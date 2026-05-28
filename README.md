<div align="center">
  <h1 align="center" style="font-size: 50px;">🌿 Share Receiver 🌿</h1>
  <p align="center">
  A powerful and easy-to-use Flutter plugin that enables your iOS and Android apps to seamlessly receive and handle shared text, images, videos, and files from other applications using native share sheets.
 </p>
</div>

<div align="center">
   <!--  Donations -->
  <a href="https://ko-fi.com/mrrhak">
    <img width="300" src="https://user-images.githubusercontent.com/26390946/161375567-9e14cd0e-1675-4896-a576-a449b0bcd293.png">
  </a>
  <div align="center">
    <a href="https://www.buymeacoffee.com/mrrhak">
      <img width="150" alt="buymeacoffee" src="https://user-images.githubusercontent.com/26390946/161375563-69c634fd-89d2-45ac-addd-931b03996b34.png">
    </a>
    <a href="https://ko-fi.com/mrrhak">
      <img width="150" alt="Ko-fi" src="https://user-images.githubusercontent.com/26390946/161375565-e7d64410-bbcf-4a28-896b-7514e106478e.png">
    </a>
  </div>
  <!--  Donations -->
</div>

<div align="center">
  <a href="https://pub.dartlang.org/packages/share_receiver">
    <img src="https://img.shields.io/pub/v/share_receiver?label=Pub&logo=dart"
      alt="Pub Package" />
  </a>
  <a href="https://pub.dev/packages/share_receiver">
    <img src="https://img.shields.io/pub/likes/share_receiver?style=flat&logo=dart&label=Likes" alt="Pub Likes"/>
  </a>
  <a href="https://pub.dartlang.org/packages/share_receiver/score">
    <img src="https://img.shields.io/pub/points/share_receiver?label=Score&logo=dart"
      alt="Pub Score" />
  </a>
  <a href="https://pub.dev/packages/share_receiver">
    <img alt="Pub Monthly Downloads" src="https://img.shields.io/pub/dm/share_receiver?style=flat&color=blue&logo=dart&label=Downloads&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fshare_receiver">
  </a>
  <a href="https://github.com/mrrhak/share_receiver"><img src="https://img.shields.io/github/stars/mrrhak/share_receiver.svg?style=flat&logo=github&colorB=deeppink&label=Stars" alt="Star on Github"></a>
  <a href="https://github.com/mrrhak/share_receiver"><img src="https://img.shields.io/github/forks/mrrhak/share_receiver?color=orange&label=Forks&logo=github" alt="Forks on Github"></a>
  <a href="https://github.com/mrrhak/share_receiver/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/mrrhak/share_receiver.svg?style=flat&logo=github&colorB=yellow&label=Contributors"
      alt="Contributors" />
  </a>
  <a href="https://github.com/mrrhak/share_receiver/actions?query=workflow%3A">
    <img src="https://github.com/mrrhak/share_receiver/actions/workflows/format-analyze-test.yml/badge.svg"
      alt="Build Status" />
  </a>
  <a href="https://github.com/mrrhak/share_receiver">
    <img src="https://img.shields.io/github/languages/code-size/mrrhak/share_receiver?logo=github&color=blue&label=Size"
      alt="Code size" />
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/github/license/mrrhak/share_receiver?label=License&color=red&logo=Leanpub"
      alt="License: MIT" />
  </a>
  <a href="https://pub.dev/packages/share_receiver">
    <img src="https://img.shields.io/badge/Platform-Android%20|%20iOS%20-blue.svg?logo=flutter"
      alt="Platform" />
  </a>
</div>

---

<p align="center">
  <img src="https://raw.githubusercontent.com/mrrhak/share_receiver/master/assets/share_receiver_preview.png" width="500" alt="share receiver preview"/>
</p>

## Guide

### Installation
Add `share_receiver` as a dependency in your `pubspec.yaml` file:
```sh
flutter pub add share_receiver
```

### Configuration

#### Android

1. Edit your Android Manifest file, located in `android/app/src/main/AndroidManifest.xml` and add/uncomment the intent filters and meta data that you want to support:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="share_receiver_example"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- ... -->

            <!-- Intent filters for share functionality -->
            <!--TODO: Add this filter if you want to handle shared text-->
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="text/*" />
            </intent-filter>

            <!--TODO: Add this filter if you want to handle shared images-->
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="image/*" />
            </intent-filter>

            <intent-filter>
                <action android:name="android.intent.action.SEND_MULTIPLE" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="image/*" />
            </intent-filter>

            <!--TODO: Add this filter if you want to handle shared videos-->
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="video/*" />
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.SEND_MULTIPLE" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="video/*" />
            </intent-filter>

            <!--TODO: Add this filter if you want to handle any type of file-->
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="*/*" />
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.SEND_MULTIPLE" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="*/*" />
            </intent-filter>
        </activity>
        <!-- ... -->
    </application>
    <!-- ... -->
</manifest>

```

>[!NOTE] 
> If you want to prevent incoming shares from opening a new activity each time, add/edit the attribute `android:launchMode="singleTask"` to your MainActivity intent inside your AndroidManifest.xml file.
>

---

#### iOS

1. Edit your iOS Info.plist file, located in `ios/Runner/Info.plist`. It registers your app to open via a deep link that will be launched from the Share Extension.

```xml
<!-- Uncomment below lines if you want to use a custom group id rather than the default. Set it in Build Settings → User-Defined -->
<!-- <key>AppGroupId</key>
<string>$(CUSTOM_GROUP_ID)</string> -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>ShareMedia-$(PRODUCT_BUNDLE_IDENTIFIER)</string>
        </array>
    </dict>
</array>
```

2. Create Share Extension
   - In Xcode, go to the menu and select **File → New → Target** → choose **Share Extension**
   - Give it the name `ShareExtension` and save

3. Go to Build Phases of your `Runner` target and move `Embed Foundation Extension` to the top of `Thin Binary`.

4. Make the following edits to `ios/ShareExtension/Info.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Uncomment below lines if you want to use a custom group id rather than the default. Set it in Build Settings → User-Defined -->
    <!-- <key>AppGroupId</key>
    <string>$(CUSTOM_GROUP_ID)</string> -->
    <key>NSExtension</key>
    <dict>
        <key>NSExtensionAttributes</key>
        <dict>
            <key>NSExtensionActivationRule</key>
            <!-- The TRUEPREDICATE NSExtensionActivationRule that only works in development mode -->
            <!-- <string>TRUEPREDICATE</string> -->
            <!-- Add a new rule below will allow sharing one or more file of any type, url, or text content. -->
            <!-- You can modify these rules to your liking for which types of share content your app can handle. -->
            <string>SUBQUERY (
                extensionItems,
                $extensionItem,
                SUBQUERY (
                    $extensionItem.attachments,
                    $attachment,
                    (
                        ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.file-url"
                        || ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.image"
                        || ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.text"
                        || ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.movie"
                        || ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.url"
                    )
                ).@count > 0
            ).@count > 0
            </string>
            <key>PHSupportedMediaTypes</key>
            <array>
                <string>Video</string>
                <string>Image</string>
            </array>
        </dict>
        <key>NSExtensionMainStoryboard</key>
        <string>MainInterface</string>
        <key>NSExtensionPointIdentifier</key>
        <string>com.apple.share-services</string>
    </dict>
</dict>
</plist>
```

5. Add a group identifier to both the `Runner` and `ShareExtension` targets
   - In Xcode, select **Runner → Targets → Runner → Signing & Capabilities**
   - Click **+** and select **App Groups**
   - Add a new group (default: your bundle identifier prefixed with `group.`, e.g. `group.com.company.app`)
   - Repeat those steps inside the **ShareExtension** target using the **same** group id

6. *(Optional)* If you used a custom group identifier that isn't your bundle identifier prefixed by `group.`, add a custom build setting in both targets:
   - Go to **Targets → ShareExtension → Build Settings**
   - Click **+** → **Add User-Defined Setting**
   - Key: `CUSTOM_GROUP_ID`, Value: your app group identifier
   - Repeat for the **Runner** target

7. Wire up the Share Extension view controller

   The Share Extension serializes the shared content and saves it to the shared container, then opens a deep link back into the main app. The extension itself is lightweight — it does **not** embed Flutter.

   > [!IMPORTANT]
   > The Share Extension must **not** link `FlutterGeneratedPluginSwiftPackage`. That package pulls in the Flutter framework, which is too large for an extension. Use `share-receiver-models` (SPM) or `share_receiver_models` (CocoaPods) instead — both are Flutter-free.

   ---

   #### Swift Package Manager

   The `share_receiver` package exposes a lightweight `share-receiver-models` product that contains only the extension-safe code (no Flutter dependency).

   **Step 1 — Add `share-receiver-models` to your Share Extension target in Xcode:**

   - Select your **ShareExtension** target → **General → Frameworks and Libraries**
   - Click **+**, search for `share-receiver-models` and add it

   If `share-receiver-models` does not appear in the list:
   - Go to **File → Add Package Dependencies → Add Local**
   - Navigate to `ios/Flutter/ephemeral/Packages/.packages/share_receiver/`
   - When prompted to choose products, add **only `share-receiver-models`** to the **ShareExtension** target (do **not** add `share-receiver` or add anything to the Runner target)

   **Step 2 — Verify the Share Extension does not link `FlutterGeneratedPluginSwiftPackage`:**

   - Select your **ShareExtension** target → **General → Frameworks and Libraries**
   - If `FlutterGeneratedPluginSwiftPackage` is listed, remove it

   **Step 3 — Replace `ShareExtension/ShareViewController.swift`:**

   ```swift
   import share_receiver_models

   class ShareViewController: ShareReceiverServiceViewController {}
   ```

   ---

   #### CocoaPods

   **Option 1 — Lightweight (recommended): `share_receiver_models` pod (no Flutter dependency)**

   Add the following inside `ios/Podfile` within the `target 'Runner' do` block, then run `pod install` inside the `ios` directory.

   ```ruby
   target 'Runner' do
     use_frameworks!
     use_modular_headers!

     flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

     # share_receiver start
     target 'ShareExtension' do
       inherit! :search_paths
       pod 'share_receiver_models', :path => '.symlinks/plugins/share_receiver/ios/share_receiver'
     end
     # share_receiver end
   end
   ```

   Replace `ShareExtension/ShareViewController.swift` with:

   ```swift
   import share_receiver_models

   class ShareViewController: ShareReceiverServiceViewController {}
   ```

   **Option 2 — Full pod (`share_receiver`) with Flutter dependency**

   > [!NOTE]
   > This option links the Flutter framework into the Share Extension, which increases the extension binary size significantly. Prefer Option 1 unless you have a specific reason to use this approach.

   ```ruby
   target 'Runner' do
     use_frameworks!
     use_modular_headers!

     flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

     # share_receiver start
     target 'ShareExtension' do
       inherit! :search_paths
     end
     # share_receiver end
   end
   ```

   Replace `ShareExtension/ShareViewController.swift` with:

   ```swift
   import share_receiver

   class ShareViewController: ShareReceiverServiceViewController {}
   ```

   Make sure the Xcode scheme has a Pre-Action Script so Flutter is available before the build:

   - **Xcode → Product → Scheme → Edit Scheme → Build → Pre-action → Add Run Script**

   ```bash
   /bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" prepare
   ```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:share_receiver/share_receiver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedData? _sharedData;

  @override
  void initState() {
    super.initState();
    _initShareReceiver();
  }

  @override
  void dispose() {
    ShareReceiver.instance.dispose();
    super.dispose();
  }

  Future<void> _initShareReceiver() async {
    // Get initial sharing data (if app was opened via share)
    final initial = await ShareReceiver.instance.getInitialSharing();
    if (initial != null) {
      print('Received initial share data: $initial');
      setState(() => _sharedData = initial);
      // Clear the initial data
      ShareReceiver.instance.clear();
    }

    // Listen for shares while app is running
    ShareReceiver.instance.getMediaStream().listen((data) {
      print('Received share data: $data');
      setState(() => _sharedData = data);
      // Clear the received data
      ShareReceiver.instance.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Share Receiver Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: .min,
              spacing: 8.0,
              children: [
                Text('Shared data: ${_sharedData?.toString() ?? 'No data'}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

See the [example](https://github.com/mrrhak/share_receiver/tree/master/example) here for runnable project of various usages.

## Bugs or Requests

If you encounter any problems feel free to open an [issue](https://github.com/mrrhak/share_receiver/issues/new?template=bug_report.md). If you feel the library is missing a feature, please raise a [ticket](https://github.com/mrrhak/share_receiver/issues/new?template=feature_request.md) on GitHub and I'll look into it. Pull request are also welcome.

See [Contributing.md](https://github.com/mrrhak/share_receiver/blob/master/CONTRIBUTING.md).

## Support
Don't forget to give it a like 👍 or a star ⭐

## Activities
![Alt](https://repobeats.axiom.co/api/embed/3b2e085c3d34d14114f9d90e534a57db42fa6e06.svg "Repobeats analytics image")