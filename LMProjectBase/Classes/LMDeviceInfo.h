//
//  LMDeviceInfo.h
//  LM
//
//  Created by Lukasz Dworakowski on 14.03.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMDeviceInfo : NSObject
+ (NSString *) getFullXibNameForCurrentDevice: (NSString*) xibName;
+ (BOOL)isCameraPresent;
+ (BOOL)isScreenBig;
+ (BOOL)isIOS7;
@end
