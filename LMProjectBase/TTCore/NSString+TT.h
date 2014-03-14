//
//  NSString+TT.h
//  TT
//
//  Created by Andrzej Auchimowicz on 10/17/12.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(TT)

- (NSString*)computeSha1;
- (NSString*)computeSha256;

- (NSString*)stringByAddingJsonEscapesUsingEncoding:(NSStringEncoding)stringEncoding;
- (NSString*)stringByReplacingJsonEscapesUsingEncoding:(NSStringEncoding)stringEncoding;

- (NSString*)stringByAddingUrlPercentEscapesUsingEncoding:(NSStringEncoding)stringEncoding;

- (NSString*)stringByAddingXmlEscapes:(NSStringEncoding)stringEncoding;
- (NSString*)stringByReplacingXmlEscapes:(NSStringEncoding)stringEncoding;

- (NSString*)stringByEncodingAsBase64;

@end

NSString*
NSStringEmptyOnNil(NSString* string);
