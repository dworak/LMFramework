//
//  NSSet+TT.h
//  TT
//
//  Created by Michal Kuprianowicz on 11/03/14.
//  Copyright (c) 2014 Transition Technologies S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet(TT)
- (NSDictionary*)dictionaryWithObjectKeyBlock:(id(^)(id item))keyBlock;
@end
