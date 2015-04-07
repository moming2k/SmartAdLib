//
//  SADRequest.m
//  Pods
//
//  Created by Chan Chris on 8/4/15.
//
//

#import "SADRequest.h"

@implementation SADRequest

@synthesize testDevices;
@synthesize gender;
@synthesize birthday;
@synthesize age;

+ (instancetype)request
{
    return [[SADRequest alloc] init];
}

+ (NSString*) sdkVersion
{
    return @"1.1.1";
}

- (void)setLocationWithDescription:(NSString *)locationDescription
{
    
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        // Copy NSObject subclasses
        [copy setTestDevices:[self.testDevices copyWithZone:zone]];
    }
    
    return copy;
}

@end
