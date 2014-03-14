//
//  TTClock.h
//  TT
//
//  Created by Andrzej Auchimowicz on 27/02/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTClock : NSObject
{
@private
    NSTimeInterval  _startTime;
    NSDate*         _startDate;
}

- (void)resetMeasurementWithShouldUseSystemClock:(BOOL)shouldUSeSystemClock;
- (NSTimeInterval)getDeltaTime;

@end
