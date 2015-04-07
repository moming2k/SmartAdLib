//
//  SmartAdManager.m
//  Pods
//
//  Created by Chan Chris on 8/4/15.
//
//

#import "SmartAdManager.h"
@import CoreLocation;

NSString *BeaconIdentifier = @"com.igpsd.smartad";

@interface SmartAdManager() <CLLocationManagerDelegate>
{
    NSString *idfv;
    
}
@property CLLocationManager *locationManager;
@property BOOL notifyOnEntry;
@property BOOL notifyOnExit;
@property BOOL notifyOnDisplay;
@end


@implementation SmartAdManager
@synthesize adUnitID;
@synthesize notifyOnEntry, notifyOnExit, notifyOnDisplay;


+ (id)sharedInstance {
    
    static SmartAdManager *sharedMyManager = nil;
    //Using dispatch_once from GCD. This method is thread safe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        NSArray *_supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"],
                                     [[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"],
                                     [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"]];
        
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_supportedProximityUUIDs[0] identifier:BeaconIdentifier];
        self.notifyOnEntry = self.notifyOnExit = self.notifyOnDisplay = YES;
        [self.locationManager startMonitoringForRegion:region];

    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    /*
     A user can transition in or out of a region while the application is not running. When this happens CoreLocation will launch the application momentarily, call this delegate method and we will let the user know via a local notification.
     */
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if(state == CLRegionStateInside)
    {
        notification.alertBody = NSLocalizedString(@"You're inside the region", @"");
    }
    else if(state == CLRegionStateOutside)
    {
        notification.alertBody = NSLocalizedString(@"You're outside the region", @"");
    }
    else
    {
        return;
    }
    
    /*
     If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
     If it's not, iOS will display the notification to the user.
     */
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)handleLocalNotification:(UILocalNotification *)notification
{
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Title for cancel button in local notification");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    [alert show];
}


- (void)dealloc {
    //The dealloc must not
}

@end
