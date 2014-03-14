//
//  TTOptionalProtocolHelper.h
//  TT
//
//  Created by Andrzej Auchimowicz on 09/10/2012.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTOptionalProtocolHelper : NSObject

+ (BOOL)callOptional:(SEL)selector onObject:(id)object withParameters:(NSArray*)parameters;
+ (BOOL)callOptional:(SEL)selector onObject:(id)object withParameters:(NSArray*)parameters andBoolResult:(BOOL*)result;

@end
