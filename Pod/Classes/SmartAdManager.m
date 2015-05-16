//
//  SmartAdManager.m
//  Pods
//
//  Created by Chan Chris on 8/4/15.
//
//

#import "SmartAdManager.h"
#import "AFNetworking.h"

static NSString * const kIdentifier = @"SomeIdentifier";

static NSString * const kOperationCellIdentifier = @"OperationCell";
static NSString * const kBeaconCellIdentifier = @"BeaconCell";

static NSString * const kMonitoringOperationTitle = @"Monitoring";
static NSString * const kAdvertisingOperationTitle = @"Advertising";
static NSString * const kRangingOperationTitle = @"Ranging";
static NSUInteger const kNumberOfSections = 2;
static NSUInteger const kNumberOfAvailableOperations = 3;
static CGFloat const kOperationCellHeight = 44;
static CGFloat const kBeaconCellHeight = 52;
static NSString * const kBeaconSectionTitle = @"Looking for beacons...";
static CGPoint const kActivityIndicatorPosition = (CGPoint){205, 12};
static NSString * const kBeaconsHeaderViewIdentifier = @"BeaconsHeader";

static void * const kMonitoringOperationContext = (void *)&kMonitoringOperationContext;
static void * const kRangingOperationContext = (void *)&kRangingOperationContext;


NSString *BeaconIdentifier = @"com.igpsd.smartad";

@interface SmartAdManager() <CLLocationManagerDelegate>
{
    NSString *idfv;
    
}
@property CLLocationManager *locationManager;
@property BOOL notifyOnEntry;
@property BOOL notifyOnExit;
@property BOOL notifyOnDisplay;
@property (nonatomic, unsafe_unretained) void *operationContext;

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
        _isMonitoring = NO;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        
        NSArray *_supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"],
                                     [[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"],
                                     [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"],
                                     [[NSUUID alloc] initWithUUIDString:@"D988B3E4-1830-4B0C-B47F-81CF2F2C906F"]];
        
        [self checkLocationAccessForRanging];
        
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_supportedProximityUUIDs[0] identifier:BeaconIdentifier];
        self.notifyOnEntry = self.notifyOnExit = self.notifyOnDisplay = YES;
        [self.locationManager startMonitoringForRegion:region];

    }
    return self;
}

#pragma mark - Location access methods (iOS8/Xcode6)
- (void)checkLocationAccessForRanging {
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

#pragma mark - Location manager delegate methods
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (![CLLocationManager locationServicesEnabled]) {
        if (self.operationContext == kMonitoringOperationContext) {
            NSLog(@"Couldn't turn on monitoring: Location services are not enabled.");
            //self.monitoringSwitch.on = NO;
            return;
        } else {
            NSLog(@"Couldn't turn on ranging: Location services are not enabled.");
            //self.rangingSwitch.on = NO;
            return;
        }
    }
    
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    switch (authorizationStatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
            if (self.operationContext == kMonitoringOperationContext) {
                _isMonitoring = YES;
            } else {
                _isMonitoring = YES;
                _isRanging = YES;
            }
            return;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if (self.operationContext == kMonitoringOperationContext) {
                NSLog(@"Couldn't turn on monitoring: Required Location Access(Always) missing.");
                _isMonitoring = NO;
            } else {
                _isRanging = YES;
            }
            return;
            
        default:
            if (self.operationContext == kMonitoringOperationContext) {
                NSLog(@"Couldn't turn on monitoring: Required Location Access(Always) missing.");
                _isMonitoring = NO;
                return;
            } else {
                NSLog(@"Couldn't turn on monitoring: Required Location Access(WhenInUse) missing.");
                _isRanging = NO;
                return;
            }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    /*
     A user can transition in or out of a region while the application is not running. When this happens CoreLocation will launch the application momentarily, call this delegate method and we will let the user know via a local notification.
     */
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if(state == CLRegionStateInside)
    {
        notification.alertTitle = @"Region Event";
        notification.alertBody = NSLocalizedString(@"You're inside the region", @"");
    }
    else if(state == CLRegionStateOutside)
    {
        notification.alertTitle = @"Region Event";
        notification.alertBody = NSLocalizedString(@"You're outside the region", @"");
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        return;
    }
    else
    {
        return;
    }
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestOperationManager *afmanager = [AFHTTPRequestOperationManager manager];
    //    manager.securityPolicy = securityPolicy;
    
    afmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [afmanager POST:@"http://shisa.igpsd.com/ad_requests.json" parameters:
     @{
       @"gender":@"M",
       @"age": @"26",
       
       }
            success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *array = (NSArray*) responseObject;
         
         if ([array count] > 0)
         {
             
             NSDictionary *dict = [array objectAtIndex:0];
             
             if([[dict objectForKey:@"match"] boolValue])
             {
                 notification.alertTitle = [dict objectForKey:@"title"];
                 notification.alertBody = [dict objectForKey:@"ad_content"];
                 
                 [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
             }
             else
             {
                 notification.alertTitle = @"Not Match";
                 notification.alertBody = @"";
                 
                 [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];

    
    /*
     If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
     If it's not, iOS will display the notification to the user.
     */
    
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"didRangeBeacons");
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Entered region: %@", region);
    CLBeaconRegion *bRegion = (CLBeaconRegion*) region;
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestOperationManager *afmanager = [AFHTTPRequestOperationManager manager];
    //    manager.securityPolicy = securityPolicy;
    
    afmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [afmanager POST:@"http://shisa.igpsd.com/ad_requests.json" parameters:
     @{
       @"gender":@"M",
       @"age": @"26",
       
       }
            success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *array = (NSArray*) responseObject;
         
         if ([array count] > 0)
         {
             
             NSDictionary *dict = [array objectAtIndex:0];
             
             if([[dict objectForKey:@"match"] boolValue])
             {
                 notification.alertTitle = [dict objectForKey:@"title"];
                 notification.alertBody = [dict objectForKey:@"ad_content"];
                 
                 link = [dict objectForKey:@"ad_url"];
                 [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
             }
             else
             {
                 notification.alertTitle = @"Not Match";
                 notification.alertBody = @"";
                 
                 [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Exited region: %@", region);
    CLBeaconRegion *bRegion = (CLBeaconRegion*) region;
    [self sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region withMessage:[NSString stringWithFormat:@"Exited beacon region for UUID: %@",
                                                                                     bRegion.proximityUUID.UUIDString]];
}

#pragma mark - Local notifications
- (void)sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region withMessage:(NSString*) message
{
    UILocalNotification *notification = [UILocalNotification new];
    
    // Notification details
    notification.alertBody = @"Beacon 狀態更新";
    notification.alertBody = message;   // Major and minor are not available at the monitoring stage
    notification.alertAction = NSLocalizedString(@"View Details", nil);
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)handleLocalNotification:(UILocalNotification *)notification
{
    if ([notification.alertBody isEqualToString:@""])
    {
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Title for cancel button in local notification");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertTitle message:notification.alertBody delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Title for cancel button in local notification");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertTitle message:notification.alertBody delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:@"前往",nil];
        [alert show];
        
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"Cancel Button Pressed");
            break;
        case 1:
            [self goToLink];
            break;
        case 2:
            NSLog(@"Button 2 Pressed");
            break;
        case 3:
            NSLog(@"Button 3 Pressed");
            break;
        default:
            break;
    }
    
}

- (void)goToLink
{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestOperationManager *afmanager = [AFHTTPRequestOperationManager manager];
    //    manager.securityPolicy = securityPolicy;
    
    afmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [afmanager POST:@"http://shisa.igpsd.com/ad_requests.json" parameters:
     @{
       @"gender":@"M",
       @"age": @"26",
       
       }
            success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *array = (NSArray*) responseObject;
         
         if ([array count] > 0)
         {
             
             NSDictionary *dict = [array objectAtIndex:0];
             
             if([[dict objectForKey:@"match"] boolValue])
             {
                 link = [dict objectForKey:@"ad_url"];
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
             }
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];

}

- (void)dealloc {
    //The dealloc must not
}

@end
