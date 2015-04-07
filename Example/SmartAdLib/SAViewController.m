//
//  SAViewController.m
//  SmartAdLib
//
//  Created by Chris Chan on 04/08/2015.
//  Copyright (c) 2014 Chris Chan. All rights reserved.
//

#import "SAViewController.h"

@interface SAViewController ()<SADInterstitialDelegate>

@end

@implementation SAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.interstitial = [[SADInterstitial alloc] init];
    self.interstitial.adUnitID = @"ad-demo-unit1/main-page";
    
    SADRequest *request = [SADRequest request];
    // Requests test ads on test devices.
//    request.testDevices = @[@"2077ef9a63d2b398840261c8221a0c9b"];
    
    [self.interstitial loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SADInterstitial *)createAndLoadInterstitial {
    SADInterstitial *interstitial = [[SADInterstitial alloc] init];
    interstitial.adUnitID = @"ca-app-pub-3940256099942544/4411468910";
    interstitial.delegate = self;
    [interstitial loadRequest:[SADRequest request]];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(SADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}

@end
