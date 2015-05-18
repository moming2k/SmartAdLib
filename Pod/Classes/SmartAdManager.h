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
#import "Tolo.h"
#import "SADManagerEvent.h"
#import "SADPromotionEvent.h"
#import "SADLocationEvent.h"

@import CoreLocation;

@interface SmartAdManager : NSObject < UIAlertViewDelegate >
{
    NSString *link;
    NSString *token;
}

@property(nonatomic, copy) NSString *adUnitID;
@property(nonatomic, readonly) BOOL isMonitoring;
@property(nonatomic, readonly) BOOL isRanging;

+(id)sharedInstance;
- (void)handleLocalNotification:(UILocalNotification *)notification;
- (void)sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region withMessage:(NSString*) message;
- (void)setUserToken:(NSString *)token;

- (void)goToLink;

@end
