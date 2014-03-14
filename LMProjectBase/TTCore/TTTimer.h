//
//  TTTimer.h
//  TT
//
//  Created by Andrzej Auchimowicz on 27/12/2011.
//  Copyright (c) 2011 Transition Technologies S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTimer : NSObject
{
@private
    NSTimer*    _timer;
}

/**
    Notice that target is not retained! Code will not crash on inappropriate use
    but you will be most likely screwed anyway... so take care.
*/

@property (weak, nonatomic) NSObject* target;

/**
    Selector to run on every time interval expiration.
*/

@property (assign, nonatomic) SEL selectorToRun;

/**
    @param isLazy When set to YES, timer will pause on UI animations etc.
*/

- (void)start:(NSTimeInterval)timeInterval withIsLazy:(BOOL)isLazy;
- (void)stop;

@end
