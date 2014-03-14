//
//  TTPropertyTransferer.h
//  TT
//
//  Created by Andrzej Auchimowicz on 09/11/2012.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^TTPropertyTransfererFilterBlock)(NSString* propertyName);

@interface TTPropertyTransferer : NSObject

+ (void)transferPropertiesOfObject:(NSObject*)objectA toObject:(NSObject*)objectB withFilterBlock:(TTPropertyTransfererFilterBlock)block;

@end
