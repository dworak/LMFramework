//
//  TTConfiguration.m
//  TT
//
//  Created by Andrzej Auchimowicz on 19/11/2012.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import "TTConfiguration.h"

#import "TTMacros.h"

@implementation TTConfiguration

- (id)initFromAppPlistWithRootKey:(NSString*)rootKey
{
    self = [super init];
    
    if (self)
    {
        NSDictionary* configuration = [[NSBundle mainBundle] infoDictionary];
        assert(configuration);
        
        _env = [configuration objectForKey:@"env"];
        assert(_env);
        
        if (rootKey)
        {
            configuration = [configuration objectForKey:rootKey];
            assert(configuration);
        }
        
        _root = configuration;
    }
    
    return self;
}

- (id)initFromPlistAtPath:(NSString*)path withRootKey:(NSString*)rootKey
{
    self = [super init];
    
    if (self)
    {
        NSDictionary* configuration = [[NSDictionary alloc] initWithContentsOfFile:path];
        assert(configuration);
        
        _env = [configuration objectForKey:@"env"];
        assert(_env);
        
        if (rootKey)
        {
            configuration = [configuration objectForKey:rootKey];
            assert(configuration);
        }
        
        _root = configuration;
    }
    
    return self;
}

- (id)valueForEnvironmentalKey:(NSString*)environmentalKey
{
    NSDictionary* dictionary = [_root objectForKey:environmentalKey];
    
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
    {
        @throw TT_MAKE_EXCEPTION([self class], @"Invalid environmentalKey or PLIST format", nil);
    }
    
    NSString* value = [dictionary objectForKey:_env];
    
    if (!value)
    {
        @throw TT_MAKE_EXCEPTION([self class], @"Invalid environmentalKey or PLIST format", nil);
    }
    
    if (![value isKindOfClass:[NSString class]] && ![value isKindOfClass:[NSNumber class]])
    {
        @throw TT_MAKE_EXCEPTION([self class], @"Unexpected class of value", nil);
    }
    
    return value;
}

- (id)valueForNormalKey:(NSString*)key
{
    id result = [_root objectForKey:key];
    return result;
}

@end
