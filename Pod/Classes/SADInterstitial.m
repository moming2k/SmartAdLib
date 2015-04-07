//
//  SADInterstitial.m
//  Pods
//
//  Created by Chan Chris on 8/4/15.
//
//

#import "SADInterstitial.h"
#import "AFNetworking.h"

@implementation SADInterstitial

@synthesize adUnitID;
@synthesize delegate;

- (void)loadRequest:(SADRequest *)request
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters =
    [NSMutableDictionary dictionaryWithDictionary:@{@"foo": @"bar"}];
    
    [manager POST:@"http://shisa.igpsd.com/resources.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
