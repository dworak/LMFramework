//
//  NSArray+TT.h
//  TT
//
//  Created by Andrzej Auchimowicz on 02/02/2012.
//  Copyright (c) 2012 Transition Technologies S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    @brief NSMutableArray category for creating nonretaining mutable array.
*/

@interface NSMutableArray(TT)

+ (NSMutableArray*)arrayNotRetaining;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#else
- (id)firstObject;
#endif

- (NSDictionary*)dictionaryWithObjectKeyBlock:(id(^)(id item))keyBlock;


@end
