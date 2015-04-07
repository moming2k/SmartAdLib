//
//  SmartAdManager.h
//  Pods
//
//  Created by Chan Chris on 8/4/15.
//
//

#import <Foundation/Foundation.h>

#import "SADRequest.h"
#import "SADBannerView.h"
#import "SADInterstitial.h"
#import "SADInterstitialDelegate.h"

@interface SmartAdManager : NSObject

@property(nonatomic, copy) NSString *adUnitID;

+(id)sharedInstance;
- (void)handleLocalNotification:(UILocalNotification *)notification;

@end
