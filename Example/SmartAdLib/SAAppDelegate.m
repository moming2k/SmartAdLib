//
//  SAAppDelegate.m
//  SmartAdLib
//
//  Created by CocoaPods on 04/08/2015.
//  Copyright (c) 2014 Chris Chan. All rights reserved.
//

#import "SAAppDelegate.h"
#import "SmartAdManager.h"
#import "AFNetworking.h"

@implementation SAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    isNotificaion = NO;
    
    [Tolo.sharedInstance subscribe:self];
    
    // Override point for customization after application launch.
    SmartAdManager *smartAdManager = [SmartAdManager sharedInstance];
    [smartAdManager setAdUnitID:@"ctbcapp01"];
    
    SADLocationEvent *location = [[SmartAdManager sharedInstance] currentLocation];
    NSLog(@"Location status = %@",location.status);
    NSLog(@"Location message = %@",location.message);
    NSLog(@"Location block = %@",location.block);
    NSLog(@"Location x = %f",[location.x floatValue]);
    NSLog(@"Location y = %f", [location.y floatValue]);
    
    /* prepare for the handle of the local notification if it is not already ask user by other place */
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    UILocalNotification *localNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification)
    {
         isNotificaion = YES;
    }

    
    return YES;
}

SUBSCRIBE(SADManagerEvent)
{
    NSLog(@"SADEvent event message = %@",event.message);
//    self.progressView.progress = event.progress;
//    self.label.text = [NSString stringWithFormat:@"%0.2f",event.progress];
}

SUBSCRIBE(SADLocationEvent)
{
    NSLog(@"SADLocationEvent event status = %@",event.status);
    NSLog(@"SADLocationEvent event message = %@",event.message);
    NSLog(@"SADLocationEvent event block = %@",event.block);
    NSLog(@"SADLocationEvent event x = %f",[event.x floatValue]);
    NSLog(@"SADLocationEvent event y = %f", [event.y floatValue]);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if (isNotificaion)
    {
        isNotificaion = NO;
        
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
                 
                 if ( [[dict objectForKey:@"match"] boolValue])
                 {
                     NSURL *url = [NSURL URLWithString:[dict objectForKey:@"ad_url"]];
                     [[UIApplication sharedApplication] openURL:url];
                 }
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
        
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // If the application is in the foreground, we will notify the user of the region's state via an alert.
    [[SmartAdManager sharedInstance] handleLocalNotification:notification];
    
}

@end
