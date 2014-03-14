//
//  TTInteroperability.h
//  TT
//
//  Created by Andrzej Auchimowicz on 08/05/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTInteroperability : NSObject

+ (BOOL)callPhoneNumber:(NSString*)phoneNumber;
+ (BOOL)openWebBrowserWithURL:(NSURL*)url;
+ (BOOL)openNewEmailWithTargetEmailAddress:(NSString*)targetEmailAddress;

@end
