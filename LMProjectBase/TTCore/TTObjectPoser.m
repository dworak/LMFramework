//
//  TTObjectPoser.m
//  ExecutivesSatellitePhoneBook
//
//  Created by AA on 28/11/2013.
//  Copyright (c) 2013 Mian. All rights reserved.
//

#import "TTObjectPoser.h"

#import "TTMacros.h"

#import <objc/runtime.h>

@implementation TTObjectPoser

+ (void)changeObject:(id)object intoInstanceOfClass:(Class)aClass
{
    object_setClass(object, aClass);
}

+ (void)changeObject:(id)object intoProxyOfAnotherObject:(id)anotherObject
{
    @throw TT_MAKE_EXCEPTION([self class], TT_MAKE_REASON_NOT_IMPLEMENTED, nil);
}

@end
