//
//  TTSingletonContruction.h
//  TT
//
//  Created by Andrzej Auchimowicz on 18/12/2012.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import "TTSingleton.h"

@interface TTSingleton (Construction)

+ (id)allocSingleton;

- (id)initWithCanDealloc:(BOOL)canDealloc;

@end
