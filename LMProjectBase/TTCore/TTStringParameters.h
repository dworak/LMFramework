//
//  TTStringParameters.h
//  TT
//
//  Created by Andrzej Auchimowicz on 13/05/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    Simplifies string alterations that require multiple replacements.
    Implementation of this class is far from ideal eg. setting parameterA
    with valueA that has in it parameterB and then setting parameterB may
    (depending on dictionary layout) result in "setting" parameterB in valueA.
    So be VERY cautious about nested parameter setups.
 
    Parameters in input string MUST be guarded by $ symbols eg. parameter
    PARAM_A should appear in string as $PARAM_A$. For obvious reasons, be weary
    of using common strings as parameter names.
*/

@interface TTStringParameters : NSObject
{
@private
    NSMutableDictionary* _nameToValue;
}

- (void)setParameter:(NSString*)name withValue:(NSString*)value;

- (NSString*)processImmutableHtmlString:(NSString*)immutableHtmlString;
- (void)processMutableHtmlString:(NSMutableString*)mutableHtmlString;

@end
