#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint esewa_flutter_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'esewa_flutter_sdk'
  s.version          = '0.0.1'
  s.summary          = 'eSewa Flutter SDK'
  s.description      = <<-DESC
eSewa Flutter SDK
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'
  s.preserve_paths = 'EsewaSDK.framework'
  s.xcconfig = {
    'OTHER_LDFLAGS' => '-framework EsewaSDK',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}/../.symlinks/plugins/esewa_flutter_sdk/ios"'
  }
  s.vendored_frameworks = 'EsewaSDK.framework'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'NO',
    'SWIFT_COMPILATION_MODE' => 'wholemodule'
  }
  s.user_target_xcconfig = {
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'NO'
  }
  s.swift_version = '5.0'
end
