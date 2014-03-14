//
//  TTKeyValueParser.m
//  TT
//
//  Created by AA on 10/03/14.
//  Copyright (c) 2014 Transition Technologies S.A. All rights reserved.
//

#import "TTKeyValueParser.h"

#import <objc/runtime.h>

@interface TTKeyValueParser ()
{
@private
    NSMutableArray* _regexes;
    NSMutableArray* _keys;
}

@end

@implementation TTKeyValueParser

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _regexes = [[NSMutableArray alloc] init];
        _keys = [[NSMutableArray alloc] init];
        
        unsigned int count;
        objc_property_t* properties = class_copyPropertyList([self class], &count);
        
        NSError* error;
        
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"^([A-Za-z0-9]+s)$" options:0 error:&error];
        
        assert(!error);
        
        for (unsigned int i = 0; i < count; i ++)
        {
            NSString* string = [NSString stringWithFormat:@"%s", property_getName(properties[i])];
            
            NSArray* matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
            
            if (matches.count > 0)
            {
                assert(matches.count == 1);
                NSTextCheckingResult* match = [matches objectAtIndex:0];
                assert(match.resultType == NSTextCheckingTypeRegularExpression);
                
                if (match.numberOfRanges == 2)
                {
                    NSRange propertyNameRange = [match rangeAtIndex:1];
                    NSString* propertyName = [string substringWithRange:propertyNameRange];
                    
                    NSString* propertyRegex = [NSString stringWithFormat:@"^(%@)([0-9]+)$", propertyName];
                    
                    [_regexes addObject:[[NSRegularExpression alloc] initWithPattern:propertyRegex options:0 error:&error]];
                    [_keys addObject:propertyName];
                    
                    assert(!error);
                }
            }
        }
    }
    
    return self;
}

- (BOOL)parseKey:(NSString*)key withValue:(id)value
{
    for (NSUInteger i = 0; i < _regexes.count; i ++)
    {
        NSRegularExpression* regex = [_regexes objectAtIndex:i];
        
        NSArray* matches = [regex matchesInString:key options:0 range:NSMakeRange(0, key.length)];
        
        if (matches.count > 0)
        {
            assert(matches.count == 1);
            
            NSTextCheckingResult* match = [matches objectAtIndex:0];
            assert(match.resultType == NSTextCheckingTypeRegularExpression);
            assert(match.numberOfRanges == 3);
            
            NSRange propertyIndexRange = [match rangeAtIndex:2];
            assert(propertyIndexRange.location != NSNotFound);
            
            NSUInteger propertyIndex = [[key substringWithRange:propertyIndexRange] integerValue];
            
            NSString* key = [_keys objectAtIndex:i];
            
            NSMutableArray* tmp = [self valueForKey:key];
            
            if (!tmp)
            {
                tmp = [[NSMutableArray alloc] init];
                [self setValue:tmp forKey:key];
            }
            
            assert([tmp isKindOfClass:[NSMutableArray class]]);
            
            while (tmp.count < propertyIndex)
            {
                [tmp addObject:[NSNull null]];
            }
            
            if (tmp.count == propertyIndex)
            {
                [tmp addObject:value];
            }
            else
            {
                [tmp replaceObjectAtIndex:propertyIndex withObject:value];
            }
            
            return YES;
        }
    }
    
    return NO;
}

@end
