//
//  TTSystemInfo.m
//  TT
//
//  Created by Andrzej Auchimowicz on 08/11/2012.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import "TTSystemInfo.h"

#import <UIKit/UIKit.h>

@implementation TTSystemInfo

+ (BOOL)isCameraPresent
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)isScreenBig
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (TTSystemInfoStatusBarTrait)statusBarTrait
{
    double systemVersion = [[[UIDevice currentDevice] systemVersion] doubleValue];
    assert(systemVersion < 8); // Review code below when new iOS comes out...
    
    if (systemVersion < 7)
    {
        return TTSystemInfoStatusBarTraitClassic;
    }
    
    return TTSystemInfoStatusBarTraitFlat;
}

+ (TTSystemInfoUiOrientationChangeControlTrait)uiOrientationChangeControlTrait
{
    double systemVersion = [[[UIDevice currentDevice] systemVersion] doubleValue];
    assert(systemVersion < 8); // Review code below when new iOS comes out...
    
    if (systemVersion < 6)
    {
        return TTSystemInfoUiOrientationChangeControlTraitClassic;
    }
    
    return TTSystemInfoUiOrientationChangeControlTraitMasked;
}

+ (CGFloat)rasterizationScale
{
    CGFloat result = [[UIScreen mainScreen] scale];
    assert(result == 1 || result == 2); // Just a check to see if this is future proof...
    return result;
}

+ (CGFloat)topLayoutGuideline
{
    double systemVersion = [[[UIDevice currentDevice] systemVersion] doubleValue];
    assert(systemVersion < 8); // Review code below when new iOS comes out...
    
    if (systemVersion < 7)
    {
        return 0;
    }
    
    return 20;
}

@end
