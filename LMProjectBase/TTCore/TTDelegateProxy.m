//
//  TTDelegateProxy.m
//  TT
//
//  Created by Andrzej Auchimowicz on 29/04/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import "TTDelegateProxy.h"

#import <objc/runtime.h>

@implementation TTDelegateProxy

- (BOOL)isSelectorInProtocol:(SEL)selector includeRequried:(BOOL)includeRequired includeOptional:(BOOL)includeOptional
{
    static BOOL isReqVals[4] = { NO, NO, YES, YES };
    static BOOL isInstanceVals[4] = { NO, YES, NO, YES };
    
    struct objc_method_description desc;
    
    for ( int i = 0; i < 4; i ++)
    {
        if (isReqVals[i] && !includeRequired)
        {
            continue;
        }
        
        if (!isReqVals[i] && !includeOptional)
        {
            continue;
        }
        
        desc = protocol_getMethodDescription(self.delegateProtocol, selector, isReqVals[i], isInstanceVals[i]);
        
        if ((desc.types == NULL) && (desc.name == NULL))
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)forwardInvocation:(NSInvocation*)anInvocation
{
    SEL selector = anInvocation.selector;
    
    if ([self isSelectorInProtocol:selector includeRequried:NO includeOptional:YES])
    {
        if ([self.proxyDelegate respondsToSelector:selector])
        {
            [anInvocation invokeWithTarget:self.proxyDelegate];
        }
        
        if ([self.realDelegate respondsToSelector:selector])
        {
            [anInvocation invokeWithTarget:self.realDelegate];
        }
        
        return;
    }
    
    if ([self isSelectorInProtocol:selector includeRequried:YES includeOptional:NO])
    {
        [anInvocation invokeWithTarget:self.proxyDelegate];
        [anInvocation invokeWithTarget:self.realDelegate];
        return;
    }
    
    [super forwardInvocation:anInvocation];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature* resultA = [self.realDelegate methodSignatureForSelector:aSelector];
    NSMethodSignature* resultB = [self.proxyDelegate methodSignatureForSelector:aSelector];
    
    assert(!resultA || !resultB || [resultA isEqual:resultB]);
    
    if (resultA)
    {
        return resultA;
    }
    
    if (resultB)
    {
        return resultB;
    }
    
    if ([self isSelectorInProtocol:aSelector includeRequried:YES includeOptional:NO])
    {
        return nil;
    }
    
    return [super methodSignatureForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL result = [self.realDelegate respondsToSelector:aSelector] || [self.proxyDelegate respondsToSelector:aSelector] || [super respondsToSelector:aSelector];
    return result;
}

@end
