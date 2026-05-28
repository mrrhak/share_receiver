# Changelog

## 1.0.2
- Fix iOS deprecated application lifecycle warning by adopting `FlutterSceneLifeCycleDelegate` (UIScene lifecycle support)
- Fix README typo in example code
- Bump minimum Flutter version to 3.44.0 and Dart SDK to 3.12.0
- Migrate Android build to Flutter's built-in Kotlin support (removes manual Kotlin Gradle Plugin application)
- Upgrade example Android Gradle wrapper to 9.1.0, AGP to 9.0.1, and Kotlin Gradle Plugin to 2.3.20
- Migrate Kotlin compiler options to new `kotlin { compilerOptions }` DSL
- Add `share-receiver-models` SPM product — a Flutter-free library safe to link into a Share Extension
- Update example Share Extension to use `share-receiver-models` instead of `FlutterGeneratedPluginSwiftPackage`
- Improve README: clearer step-by-step SPM and CocoaPods setup, add warning about not linking `FlutterGeneratedPluginSwiftPackage` in the extension

## 1.0.1
- Fix iOS CocoaPods installation multiple dependencies
- Improve README document

## 1.0.0
- Initial release
- Support get initial share data on app start
- Support share data stream on app running
- Works on Android and iOS