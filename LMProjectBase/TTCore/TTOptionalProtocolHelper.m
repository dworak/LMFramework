//
//  TTOptionalProtocolHelper.m
//  TT
//
//  Created by Andrzej Auchimowicz on 09/10/2012.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import "TTOptionalProtocolHelper.h"

@implementation TTOptionalProtocolHelper

+ (BOOL)ttCallOptional:(SEL)selector onObject:(id)object withParameters:(NSArray*)parameters andResultOutput:(void*)resultOutput
{
    if ([object respondsToSelector:selector])
    {
        NSMethodSignature* signature = [[object class] instanceMethodSignatureForSelector:selector];
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        [invocation setTarget:object];
        [invocation setSelector:selector];
        
        NSUInteger j = 2;
        
        for (id i in parameters)
        {
            void* tmp = (void*)&i; // This would be dangerous if one is not carefull. Fortunately parameters are retained by something up the call tree so this will not cause any problems... unless someone is fidling with NSArray retain behaviour and is calling this method through things like performSelector:afterDelay:...
            [invocation setArgument:tmp atIndex:j];
            j ++;
        }
        
        [invocation invoke];
        
        if (resultOutput != NULL)
        {
            [invocation getReturnValue:resultOutput];
        }
        
        return YES;
    }
    
    return NO;
}

+ (BOOL)callOptional:(SEL)selector onObject:(id)object withParameters:(NSArray*)parameters
{
    return [self ttCallOptional:selector onObject:object withParameters:parameters andResultOutput:NULL];
}

+ (BOOL)callOptional:(SEL)selector onObject:(id)object withParameters:(NSArray*)parameters andBoolResult:(BOOL*)result
{
    return [self ttCallOptional:selector onObject:object withParameters:parameters andResultOutput:result];
}

@end
