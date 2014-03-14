//
//  NSString+TT.m
//  TT
//
//  Created by Andrzej Auchimowicz on 10/17/12.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import "NSString+TT.h"

#import <CommonCrypto/CommonDigest.h>

#define NS_STRING_TT_URL_ESCAPE_CHARACTERS @"!*'\"();:@&=+$,/?%#[]% "

@interface NSString (TT_No_Arc)

- (NSString*)gtm_stringByEscapingForHTML;
- (NSString*)gtm_stringByUnescapingFromHTML;

- (NSString*)stringByEncodingAsBase64_No_Arc;

@end

@implementation NSString (TT)

- (NSString*)computeSha1
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG) data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i ++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (NSString*)computeSha256
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (CC_LONG) data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i ++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (NSString*)stringByAddingJsonEscapesUsingEncoding:(NSStringEncoding)stringEncoding
{
    @autoreleasepool
    {
        // This hack will escape JSON content.
        
        NSError* error;
        
        NSData* data = [NSJSONSerialization dataWithJSONObject:@[ self ] options:0 error:&error];
        assert(!error);
        
        NSMutableString* string = [[NSMutableString alloc] initWithData:data encoding:stringEncoding];
        
        // Remove leading [" and trailing ]".
        [string deleteCharactersInRange:NSMakeRange(0, 2)];
        [string deleteCharactersInRange:NSMakeRange(string.length - 2, 2)];
        
        return string;
    }
}

- (NSString*)stringByReplacingJsonEscapesUsingEncoding:(NSStringEncoding)stringEncoding
{
    @autoreleasepool
    {
        // This hack will unescape JSON content.
        
        NSError* error;
        
        NSData* data = [[NSString stringWithFormat:@"[\"%@\"]", self] dataUsingEncoding:stringEncoding];
        
        NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        assert(!error);
        
        NSString* string = [array objectAtIndex:0];
        return string;
    }
}

- (NSString*)stringByAddingUrlPercentEscapesUsingEncoding:(NSStringEncoding)stringEncoding
{
    return (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (CFStringRef)NS_STRING_TT_URL_ESCAPE_CHARACTERS, CFStringConvertNSStringEncodingToEncoding(stringEncoding));
}

- (NSString*)stringByAddingXmlEscapes:(NSStringEncoding)stringEncoding
{
    return [self gtm_stringByEscapingForHTML];
}

- (NSString*)stringByReplacingXmlEscapes:(NSStringEncoding)stringEncoding
{
    return [self gtm_stringByUnescapingFromHTML];
}

- (NSString*)stringByEncodingAsBase64
{
    return [self stringByEncodingAsBase64_No_Arc];
}

@end

NSString*
NSStringEmptyOnNil(NSString *string)
{
    return string ? string : @"";
}
