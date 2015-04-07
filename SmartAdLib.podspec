#
# Be sure to run `pod lib lint SmartAdLib.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SmartAdLib"
  s.version          = "1.1.1"
  s.summary          = "Bluetooth iBeacon Advertisement and Analysis Library."
  s.description      = <<-DESC
                       SmartAd Provide the easiest developer friendly iBeacon Advertisement system. We provide both back and front end for your development.

                       DESC
  s.homepage         = "http://www.igpsd.com"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = { "type" => "Copyright", "text" => "Copyright 2011 IGPSD Ltd Inc. All Rights Reserved." }
  s.author           = { "Chris Chan" => "chrischan@igpsd.com" }
  s.source           = { :git => "https://github.com/moming2k/SmartAdLib.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/moming2k'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SmartAdLib' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks =  'AudioToolbox', 'AVFoundation', 'CoreGraphics', 'CoreMedia', 'CoreTelephony', 'EventKit', 'EventKitUI', 'MessageUI', 'StoreKit', 'SystemConfiguration', 'CoreBluetooth', 'CoreLocation', 'AdSupport'

  s.dependency 'AFNetworking', '~> 2.0'
end
