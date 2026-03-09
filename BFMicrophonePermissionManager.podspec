Pod::Spec.new do |s|
  s.name             = 'BFMicrophonePermissionManager'
  s.version          = '0.1.0'
  s.summary          = 'Microphone permission request + guide alert helper (Swift, ObjC-callable).'

  s.description      = <<-DESC
BFMicrophonePermissionManager provides a simple API to request Microphone permission and show a "Go to Settings" guide alert.

- Swift implementation; Objective-C callable
- Built-in English and Simplified Chinese (zh-Hans) localization for guide alert
- Host app must provide NSMicrophoneUsageDescription in Info.plist
  DESC

  s.homepage         = 'https://github.com/mirbf/BFMicrophonePermissionManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BF' => 'dev@example.com' }
  s.source           = { :git => 'https://github.com/mirbf/BFMicrophonePermissionManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.requires_arc = true

  s.source_files = 'BFMicrophonePermissionManager/Classes/**/*.{swift}'
  s.resource_bundles = {
    'BFMicrophonePermissionManager' => ['BFMicrophonePermissionManager/Resources/**/*']
  }

  s.frameworks = 'Foundation', 'UIKit', 'AVFoundation'
end
