//
//  TTDelegateProxy.h
//  TT
//
//  Created by Andrzej Auchimowicz on 29/04/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Protocol;

@interface TTDelegateProxy : NSObject

@property (strong, nonatomic) Protocol* delegateProtocol;

@property (weak, nonatomic) id realDelegate;
@property (weak, nonatomic) id proxyDelegate;

@end
