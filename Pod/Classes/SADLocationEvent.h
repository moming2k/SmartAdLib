//
//  SADLocationEvent.h
//  Pods
//
//  Created by ChanChris on 18/5/2015.
//
//

#import "SADEvent.h"

@interface SADLocationEvent : SADEvent

@property (nonatomic, strong) NSNumber *x;
@property (nonatomic, strong) NSNumber *y;
@property (nonatomic, strong) NSNumber *heading;
@property (nonatomic, strong) NSString *block;
@property (nonatomic, strong) NSNumber *floor;


@end
