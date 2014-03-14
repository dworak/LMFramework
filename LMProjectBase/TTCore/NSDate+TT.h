//
//  NSDate+TT.h
//  Pertuzumab
//
//  Created by AA on 31/01/14.
//  Copyright (c) 2014 Transition Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ISO_8601_UTC_DATE_TIME_FORMAT @"yyyy-MM-dd'T'HH:mm:ss'Z'"
#define ISO_8601_ZONE_DATE_TIME_FORMAT @"yyyy-MM-dd'T'HH:mm:ssZZZ"

@interface NSDate (TT)

+ (instancetype)dateWithTimeIntervalInMsSince1970:(long long)ms;
- (instancetype)initWithTimeIntervalInMsSince1970:(long long)ms;

- (long long)timeIntervalInMsSince1970;

- (NSString*)iso8601utcTimeString;

@end
