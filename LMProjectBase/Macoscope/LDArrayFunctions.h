//
//  LDArrayFunctions.h
//  LM
//
//  Created by Lukasz Dworakowski on 27.03.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDArrayFunctions : NSObject
NSArray *zip(id(^map)(NSArray *objs), int count, NSArray *first, ...);
@end
