Pod::Spec.new do |s|
  s.name             = 'share_receiver_models'
  s.version          = '1.0.0'
  s.summary          = 'Share Receiver model classes (no Flutter dependency)'
  s.description      = <<-DESC
Contains a ShareReceiverServiceViewController that can be used in iOS Share Extension
without requiring Flutter framework. This allows Share Extension to compile
properly since they cannot link against Flutter.
                       DESC
  s.homepage         = 'https://mrrhak.com'
  s.license          = { :file => '../../LICENSE', :type => 'MIT' }
  s.author           = { 'Mrr Hak' => 'longkimhak.kh@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Sources/share_receiver/Models/**/*'
  s.platform = :ios, '13.0'
  
  s.pod_target_xcconfig = {'DEFINES_MODULE' => 'YES', 'APPLICATION_EXTENSION_API_ONLY' => 'YES'}
  s.swift_version    = '5.0'
end