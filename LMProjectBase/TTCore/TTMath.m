//
//  TTMath.m
//  TT
//
//  Created by Andrzej Auchimowicz on 18/07/2013.
//  Copyright (c) 2013 Genentech. All rights reserved.
//

#import "TTMath.h"

UInt32
TTSetBits(UInt32 input, UInt8 fromBit, UInt8 toBit, UInt8 value)
{
#ifdef DEBUG
    // Test if value fits in bit range.
    
    for (UInt8 i = 7; ; i --)
    {
        if (value & (1 << i))
        {
            if (i > toBit - fromBit + 1)
            {
                assert(NO);
            }
        }
        
        if (i == 0)
        {
            break;
        }
    }
#endif
    
    UInt8 left = sizeof(UInt32) * 8 - toBit - 1;
    UInt8 right = fromBit;
    
    UInt32 mask = ~(UInt32) 0;
    mask <<= left;
    mask >>= left;
    
    mask >>= right;
    mask <<= right;
    
    input &= ~mask;
    input |= mask & (value << fromBit);
    
    return input;
}

UInt8
TTGetBits(UInt32 input, UInt8 fromBit, UInt8 toBit)
{
    UInt8 left = sizeof(UInt32) * 8 - toBit - 1;
    UInt8 right = fromBit;
    
    UInt32 mask = ~(UInt32) 0;
    mask <<= left;
    mask >>= left;
    
    mask >>= right;
    mask <<= right;
    
    input &= mask;
    
    return input;
}
