//
//  NSDate+TT.m
//  Pertuzumab
//
//  Created by AA on 31/01/14.
//  Copyright (c) 2014 Transition Technologies. All rights reserved.
//

#import "NSDate+TT.h"

@implementation NSDate (TT)

+ (instancetype)dateWithTimeIntervalInMsSince1970:(long long)ms
{
    return [[NSDate alloc] initWithTimeIntervalInMsSince1970:ms];
}

- (instancetype)initWithTimeIntervalInMsSince1970:(long long)ms
{
    NSDecimalNumber* tmp = [[NSDecimalNumber alloc] initWithMantissa:ms exponent:0 isNegative:NO];
    tmp = [tmp decimalNumberByDividingBy:[[NSDecimalNumber alloc] initWithInt:1000]];
    
    self = [self initWithTimeIntervalSince1970:[tmp doubleValue]];
    
    if (self)
    {
    }
    
    return self;
}

- (long long)timeIntervalInMsSince1970
{
    NSDecimalNumber* tmp = [[NSDecimalNumber alloc] initWithDouble:[self timeIntervalSince1970]];
    tmp = [tmp decimalNumberByMultiplyingBy:[[NSDecimalNumber alloc] initWithInt:1000]];
    return [tmp longLongValue];
}

- (NSString*)iso8601utcTimeString
{
    static NSDateFormatter* formatter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:ISO_8601_UTC_DATE_TIME_FORMAT];
    });
    
    @synchronized(formatter)
    {
        return [formatter stringFromDate:self];
    }
}

@end
