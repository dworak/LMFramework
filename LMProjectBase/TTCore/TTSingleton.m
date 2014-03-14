//
//  TTSingleton.m
//  TT
//
//  Created by Andrzej Auchimowicz on 18/12/2012.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import "TTSingleton.h"

#import "TTMacros.h"
#import "TTSingleton+Contruction.h"

@interface TTSingleton ()

@property (assign, nonatomic) BOOL canDealloc;

@end

@implementation TTSingleton

//MARK: Init

- (id)initWithCanDealloc:(BOOL)canDealloc
{
    self = [super init];
    
    if (self)
    {
        self.canDealloc = canDealloc;
    }
    
    return self;
}

//MARK: Singleton construction limitations

+ (id)allocSingleton
{
    return [super allocWithZone:NULL];
}

+ (id)allocWithZone:(NSZone*)zone
{
    @throw TT_MAKE_EXCEPTION([self class], @"You can not explicitly alloc this object", nil);
}

- (id)copyWithZone:(NSZone*)zone
{
	return self;
}

- (void)dealloc
{
    if (!self.canDealloc)
    {
        ERROR(@"TTSingleton got deallocated?!");
    }
    
    assert(self.canDealloc);
}

@end
