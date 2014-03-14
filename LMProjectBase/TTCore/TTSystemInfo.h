//
//  TTSystemInfo.h
//  TT
//
//  Created by Andrzej Auchimowicz on 08/11/2012.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

/**
    Status bar trait
*/

typedef enum
{
    TTSystemInfoStatusBarTraitClassic,
    TTSystemInfoStatusBarTraitFlat
} TTSystemInfoStatusBarTrait;

/**
    UI orientation trait
*/

typedef enum
{
    TTSystemInfoUiOrientationChangeControlTraitClassic,
    TTSystemInfoUiOrientationChangeControlTraitMasked
} TTSystemInfoUiOrientationChangeControlTrait;

/**
    Shortcuts to various system/device properties scattered throughout many
    APIs.
*/

@interface TTSystemInfo : NSObject

+ (BOOL)isCameraPresent;
+ (BOOL)isScreenBig;

+ (TTSystemInfoStatusBarTrait)statusBarTrait;
+ (TTSystemInfoUiOrientationChangeControlTrait)uiOrientationChangeControlTrait;

+ (CGFloat)rasterizationScale;
+ (CGFloat)topLayoutGuideline;

@end
