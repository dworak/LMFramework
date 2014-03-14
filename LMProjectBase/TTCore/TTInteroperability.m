//
//  TTInteroperability.m
//  TT
//
//  Created by Andrzej Auchimowicz on 08/05/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import "TTInteroperability.h"

#import "TTMacros.h"

#import <UIKit/UIKit.h>

@implementation TTInteroperability

+ (BOOL)openURL:(NSURL*)url
{
    BOOL result = [[UIApplication sharedApplication] openURL:url];
    
    if (!result)
    {
        WARN(@"Opening of interoperability URL '%@' failed.", url);
    }
    
    return result;
}

+ (BOOL)callPhoneNumber:(NSString*)phoneNumber
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]];
    return [self openURL:url];
}

+ (BOOL)openWebBrowserWithURL:(NSURL*)url
{
    return [self openURL:url];
}

+ (BOOL)openNewEmailWithTargetEmailAddress:(NSString*)targetEmailAddress
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:?to=%@", targetEmailAddress]];
    return [self openURL:url];
}

@end
