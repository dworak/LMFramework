//
//  TTObjectPoser.h
//  ExecutivesSatellitePhoneBook
//
//  Created by AA on 28/11/2013.
//  Copyright (c) 2013 Mian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTObjectPoser : NSObject

+ (void)changeObject:(id)object intoInstanceOfClass:(Class)aClass;
+ (void)changeObject:(id)object intoProxyOfAnotherObject:(id)anotherObject;

@end
