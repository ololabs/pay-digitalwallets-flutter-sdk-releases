#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'pay_digitalwallets_sdk_ios'
  s.version          = '1.0.0'
  s.summary          = 'An iOS implementation of the pay_digitalwallets_sdk plugin.'
  s.description      = <<-DESC
  An iOS implementation of the pay_digitalwallets_sdk plugin.
                       DESC
  s.homepage         = 'https://github.com/ololabs/pay-digitalwallets-flutter-sdk-releases'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Olo, Inc' => 'infrastructure@olo.com' }
  s.source           = { :path => '.' }  
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'OloDigitalWalletsSDK', '1.0.0'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
