//
//  TTPropertyTransferer.m
//  TT
//
//  Created by Andrzej Auchimowicz on 09/11/2012.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import "TTPropertyTransferer.h"

#import <objc/runtime.h>

@implementation TTPropertyTransferer

+ (void)transferPropertiesOfObject:(NSObject*)objectA toObject:(NSObject*)objectB withFilterBlock:(TTPropertyTransfererFilterBlock)block
{
    assert(objectA);
    assert(objectB);
    assert(block);
    
    unsigned int propertyCount;
    objc_property_t* properties = class_copyPropertyList([objectA class], &propertyCount);
    
    for (int i = 0; i < propertyCount; i ++)
    {
        objc_property_t property = properties[i];
        
        NSString* propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        if (block(propertyName))
        {
            id value = [objectA valueForKey:propertyName];
            [objectB setValue:value forKey:propertyName];
        }
    }
}

@end
