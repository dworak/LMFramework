//
//  LMDeviceInfo.m
//  LM
//
//  Created by Lukasz Dworakowski on 14.03.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import "LMDeviceInfo.h"

static NSString* const kiPhone = @"iPhone";
static NSString* const kiPad = @"iPad";

@implementation LMDeviceInfo
+ (NSString *) getFullXibNameForCurrentDevice: (NSString*) xibName
{
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:kiPhone])
    {
        xibName = [NSString stringWithFormat:@"%@_iPhone",xibName];
    }
    else if([deviceType isEqualToString:kiPad])
    {
        xibName = [NSString stringWithFormat:@"%@_iPad", xibName];
    }
    else
    {
        @throw [NSException exceptionWithName:@"Unknown device type" reason:[NSString stringWithFormat:@"Cannot find device type: %@", deviceType] userInfo:nil];
    }
    
    return xibName;
}

+ (BOOL)isCameraPresent
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)isScreenBig
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (BOOL)isIOS7
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7;
}
@end
