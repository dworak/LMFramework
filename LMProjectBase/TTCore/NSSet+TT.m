//
//  NSSet+TT.m
//  TT
//
//  Created by Michal Kuprianowicz on 11/03/14.
//  Copyright (c) 2014 Transition Technologies S.A. All rights reserved.
//

#import "NSSet+TT.h"

@implementation NSSet(TT)

- (NSDictionary*)dictionaryWithObjectKeyBlock:(id(^)(id item))keyBlock
{
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    for (id item in self) {
        id key = keyBlock(item);
        
        [result setObject:item forKey:key];
    }
    return result;
}

@end
