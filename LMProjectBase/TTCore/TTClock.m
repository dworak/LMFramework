//
//  TTClock.m
//  TT
//
//  Created by Andrzej Auchimowicz on 27/02/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import "TTClock.h"

#import <UIKit/UIKit.h>

@implementation TTClock

- (id)init
{
    self = [super init];
    
    if (self)
    {
    }
    
    return self;
}

- (void)resetMeasurementWithShouldUseSystemClock:(BOOL)shouldUseSystemClock
{
    if (shouldUseSystemClock)
    {
        _startDate = [NSDate date];
    }
    else
    {
        _startTime = CACurrentMediaTime();
    }
}

- (NSTimeInterval)getDeltaTime
{
    if (_startDate)
    {
        return [[NSDate date] timeIntervalSinceDate:_startDate];
    }
    else
    {
        return CACurrentMediaTime() - _startTime;
    }
}

@end
