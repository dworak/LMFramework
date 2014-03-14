//
//  TTStringParameters.m
//  TT
//
//  Created by Andrzej Auchimowicz on 13/05/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import "TTStringParameters.h"

@implementation TTStringParameters

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _nameToValue = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)setParameter:(NSString*)name withValue:(NSString*)value
{
    if (!value)
    {
        [_nameToValue removeObjectForKey:name];
        return;
    }
    
    name = [NSString stringWithFormat:@"$%@$", name];
    [_nameToValue setObject:value forKey:name];
}

- (NSString*)processImmutableHtmlString:(NSString*)immutableHtmlString
{
    NSMutableString* result = [immutableHtmlString mutableCopy];
    [self processMutableHtmlString:result];
    return result;
}

- (void)processMutableHtmlString:(NSMutableString*)mutableHtmlString
{
    [_nameToValue enumerateKeysAndObjectsUsingBlock:^(NSString* name, NSString* value, BOOL* stop)
    {
        [mutableHtmlString replaceOccurrencesOfString:name withString:value options:0 range:NSMakeRange(0, mutableHtmlString.length)];
    }];
}

@end
