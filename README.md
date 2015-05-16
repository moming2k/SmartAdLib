# SmartAdLib

[![CI Status](http://img.shields.io/travis/Chris Chan/SmartAdLib.svg?style=flat)](https://travis-ci.org/Chris Chan/SmartAdLib)
[![Version](https://img.shields.io/cocoapods/v/SmartAdLib.svg?style=flat)](http://cocoapods.org/pods/SmartAdLib)
[![License](https://img.shields.io/cocoapods/l/SmartAdLib.svg?style=flat)](http://cocoapods.org/pods/SmartAdLib)
[![Platform](https://img.shields.io/cocoapods/p/SmartAdLib.svg?style=flat)](http://cocoapods.org/pods/SmartAdLib)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements


Add the follow key in plist file for the Always use of the Location in background mode

```plist
<key>NSLocationAlwaysUsageDescription</key>
<string>Support for offline access of Coupon</string>
```

## Installation

SmartAdLib is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SmartAdLib"
```

## Author

Chris Chan, chrischan@igpsd.com

## Reference 

http://nevan.net/2014/09/core-location-manager-changes-in-ios-8/

interactive notifications in iOS 8
https://nrj.io/simple-interactive-notifications-in-ios-8

UIApplicationDelegate
https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationDelegate_Protocol/index.html#//apple_ref/occ/intfm/UIApplicationDelegate/application:didReceiveLocalNotification:

Handle the notification 
https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/WhatAreRemoteNotif.html

QA on region monitor
http://stackoverflow.com/questions/19434637/ibeacons-if-app-is-in-background-locationmanager-didenterregion-is-called-on
http://stackoverflow.com/questions/24100313/ask-for-user-permission-to-receive-uilocalnotifications-in-ios-8

HiBeacons - A very nice iBeacons demo app.
https://github.com/nicktoumpelis/HiBeacons

Checklist if monitor not work
http://blog.iteedee.com/2014/02/ibeacon-startmonitoringforregion-doesnt-work/

## License

SmartAdLib is available under the GPL Version 3 license. See the LICENSE file for more info.
