//
//  SADRequestError.h
//  Pods
//
//  Created by Chan Chris on 8/4/15.
//
//

#import <Foundation/Foundation.h>

@class SADRequest;

/// Google AdMob Ads error domain.
extern NSString *const kSADErrorDomain;

/// NSError codes for SAD error domain.
typedef NS_ENUM(NSInteger, SADErrorCode) {
    /// The ad request is invalid. The localizedFailureReason error description will have more
    /// details. Typically this is because the ad did not have the ad unit ID or root view
    /// controller set.
    kSADErrorInvalidRequest,
    
    /// The ad request was successful, but no ad was returned.
    kSADErrorNoFill,
    
    /// There was an error loading data from the network.
    kSADErrorNetworkError,
    
    /// The ad server experienced a failure processing the request.
    kSADErrorServerError,
    
    /// The current device's OS is below the minimum required version.
    kSADErrorOSVersionTooLow,
    
    /// The request was unable to be loaded before being timed out.
    kSADErrorTimeout,
    
    /// Will not send request because the interstitial object has already been used.
    kSADErrorInterstitialAlreadyUsed,
    
    /// The mediation response was invalid.
    kSADErrorMediationDataError,
    
    /// Error finding or creating a mediation ad network adapter.
    kSADErrorMediationAdapterError,
    
    /// The mediation request was successful, but no ad was returned from any ad networks.
    kSADErrorMediationNoFill,
    
    /// Attempting to pass an invalid ad size to an adapter.
    kSADErrorMediationInvalidAdSize,
    
    /// Internal error.
    kSADErrorInternalError,
    
    /// Invalid argument error.
    kSADErrorInvalidArgument,
    
    /// Received invalid response.
    kSADErrorReceivedInvalidResponse
};

/// Represents the error generated due to invalid request parameters.
@interface SADRequestError : NSError
@end
