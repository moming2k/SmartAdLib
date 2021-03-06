//
//  SADInterstitial.h
//  Pods
//
//  Created by Chan Chris on 8/4/15.
//
//

#import <Foundation/Foundation.h>

#import "SADInterstitialDelegate.h"
#import "SADRequest.h"

@interface SADInterstitial : NSObject

/// Required value created on the SmartAD website. Create a new ad unit for every unique placement of
/// an ad in your application. Set this to the ID assigned for this placement. Ad units are
/// important for targeting and statistics.
///
/// Example AdMob ad unit ID: @"ca-app-pub-0123456789012345/0123456789"
@property(nonatomic, copy) NSString *adUnitID;

/// Optional delegate object that receives state change notifications from this GADInterstitalAd.
/// Remember to nil this property before deallocating the delegate.
@property(nonatomic, weak) id<SADInterstitialDelegate> delegate;

#pragma mark Making an Ad Request

/// Makes an interstitial ad request. Additional targeting options can be supplied with a request
/// object. Only one interstitial request is allowed at a time.
///
/// This is best to do several seconds before the interstitial is needed to preload its content.
/// Then when transitioning between view controllers show the interstital with
/// presentFromViewController.
- (void)loadRequest:(SADRequest *)request;

#pragma mark Post-Request

/// Returns YES if the interstitial is ready to be displayed. The delegate's
/// interstitialAdDidReceiveAd: will be called after this property switches from NO to YES.
@property(nonatomic, readonly, assign) BOOL isReady;

/// Returns YES if this object has already been presented. Interstitial objects can only be used
/// once even with different requests.
@property(nonatomic, readonly, assign) BOOL hasBeenUsed;

/// Returns the ad network class name that fetched the current ad. Returns nil while the latest ad
/// request is in progress or if the latest ad request failed. For both standard and mediated Google
/// AdMob ads, this method returns @"GADMAdapterGoogleAdMobAds". For ads fetched via mediation
/// custom events, this method returns @"GADMAdapterCustomEvents".
@property(nonatomic, readonly, copy) NSString *adNetworkClassName;

/// Presents the interstitial ad which takes over the entire screen until the user dismisses it.
/// This has no effect unless isReady returns YES and/or the delegate's interstitialDidReceiveAd:
/// has been received.
///
/// Set rootViewController to the current view controller at the time this method is called. If your
/// application does not use view controllers pass in nil and your views will be removed from the
/// window to show the interstitial and restored when done. After the interstitial has been removed,
/// the delegate's interstitialDidDismissScreen: will be called.
//- (void)presentFromRootViewController:(UIViewController *)rootViewController;

@end
