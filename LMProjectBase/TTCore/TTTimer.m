//
//  TTTimer.m
//  TT
//
//  Created by Andrzej Auchimowicz on 27/12/2011.
//  Copyright (c) 2011 Transition Technologies S.A. All rights reserved.
//

#import "TTTimer.h"

#import "TTMacros.h"

#import <QuartzCore/QuartzCore.h>

static NSUInteger numberOfActiveTimers;

@implementation TTTimer

@synthesize target, selectorToRun;

- (id)init
{
    self = [super init];

    if (self)
    {
    }

    return self;
}

- (void)dealloc
{
    if (_timer)
    {
        [self stop];
    }
}

- (void)start:(NSTimeInterval)timeInterval withIsLazy:(BOOL)isLazy
{
    numberOfActiveTimers ++;
    INFO(@"Number of TTTimers running on start: %d", numberOfActiveTimers);

    assert(numberOfActiveTimers < 5); //AA: Number in assertmMigh be increased in the future. Main purpose of this assert is to spot "zombie" timers (those that were not stopped and live somewhere crippling performance).

    assert(!_timer);

    _timer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(update:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:isLazy ? NSDefaultRunLoopMode : NSRunLoopCommonModes];
}

- (void)stop
{
    numberOfActiveTimers --;
    INFO(@"Number of TTTimers running on stop: %d", numberOfActiveTimers);

    assert(_timer);

    [_timer invalidate];
    _timer = nil;
}

- (void)update:(NSTimer*)timer
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [target performSelector:selectorToRun];
#pragma clang diagnostic pop
}

@end
