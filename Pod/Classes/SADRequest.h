//
//  SADRequest.h
//  Pods
//
//  Created by Chan Chris on 8/4/15.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SADGender) {
    kSADGenderUnknown,  ///< Unknown gender.
    kSADGenderMale,     ///< Male gender.
    kSADGenderFemale    ///< Female gender.
};

@interface SADRequest : NSObject<NSCopying>

/// Returns a default request.
+ (instancetype)request;

#pragma mark Collecting SDK Information

/// Returns the version of the SDK.
+ (NSString *)sdkVersion;

#pragma mark Testing

/// Test ads will be returned for devices with device IDs specified in this array.
@property(nonatomic, copy) NSArray *testDevices;

#pragma mark User Information

/// Provide the user's gender to increase ad relevancy.
@property(nonatomic, assign) SADGender gender;

/// Provide the user's birthday to increase ad relevancy.
@property(nonatomic, copy) NSDate *birthday;

/// The user's current location may be used to deliver more relevant ads. However do not use Core
/// Location just for advertising, make sure it is used for more beneficial reasons as well. It is
/// both a good idea and part of Apple's guidelines.
- (void)setLocationWithLatitude:(CGFloat)latitude
                      longitude:(CGFloat)longitude
                       accuracy:(CGFloat)accuracyInMeters;

/// When Core Location isn't available but the user's location is known supplying it here may
/// deliver more relevant ads. It can be any free-form text such as @"Champs-Elysees Paris" or
/// @"94041 US".
- (void)setLocationWithDescription:(NSString *)locationDescription;

@end
