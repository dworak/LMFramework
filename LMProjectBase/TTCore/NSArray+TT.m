//
//  NSArray+TT.m
//  TT
//
//  Created by Andrzej Auchimowicz on 02/02/2012.
//  Copyright (c) 2012 Transition Technologies S.A. All rights reserved.
//

#import "NSArray+TT.h"

@implementation NSMutableArray(TT)

+ (NSMutableArray*)arrayNotRetaining
{
    CFArrayCallBacks callbacks = { 0, NULL, NULL, CFCopyDescription, CFEqual };
    return (__bridge_transfer  NSMutableArray*) CFArrayCreateMutable(0, 0, &callbacks);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#else
- (id)firstObject
{
    if (self.count > 0)
    {
        return [self objectAtIndex:0];
    }
    
    return nil;
}
#endif


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
