#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint share_receiver.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'share_receiver'
  s.version          = '1.0.0'
  s.summary          = 'A Flutter plugin for iOS and Android to handle incoming shared text or media from other apps.'
  s.description      = <<-DESC
A powerful and easy-to-use Flutter plugin that enables your iOS and Android apps to seamlessly receive and handle shared text, images, videos, and files from other applications using native share sheets.
                       DESC
  s.homepage         = 'https://mrrhak.com'
  s.license          = { :file => '../LICENSE', :type => 'MIT' }
  s.author           = { 'Mrr Hak' => 'longkimhak.kh@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'share_receiver/Sources/share_receiver/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'share_receiver_privacy' => ['share_receiver/Sources/share_receiver/PrivacyInfo.xcprivacy']}
end
