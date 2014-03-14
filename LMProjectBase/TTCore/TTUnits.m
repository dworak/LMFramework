//
//  TTUnits.m
//  TT
//
//  Created by Andrzej Auchimowicz on 01/10/2012.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import "TTUnits.h"

NSUInteger
findOrder(NSUInteger value, NSUInteger unitOrder)
{
    NSUInteger result = 1;
    
    while (value > unitOrder)
    {
        value /= unitOrder;
        result ++;
    }
    
    return result;
}
