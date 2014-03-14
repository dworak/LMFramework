//
//  TTMath.h
//  TT
//
//  Created by Andrzej Auchimowicz on 18/07/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    @param input integer on which bits are going to be change
    @param fromBit first bit that is going to be changed
    @param toBit last bit that is going to be changed
    @param value this is value to which bits are going to be changed
    @returns input variable with bits in range [fromBit, toBit] set to value.
*/

UInt32
TTSetBits(UInt32 input, UInt8 fromBit, UInt8 toBit, UInt8 value);

/**
    @returns Bit values from range [fromBit, toBit] in input variable eg.
    TTGetBits(0x5, 1, 2) will return 0x2.
*/

UInt8
TTGetBits(UInt32 input, UInt8 fromBit, UInt8 toBit);
