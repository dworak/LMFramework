//
//  TTConfiguration.h
//  TT
//
//  Created by Andrzej Auchimowicz on 19/11/2012.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import "TTSingleton.h"

#import <Foundation/Foundation.h>

/**
    Reads environment specific configuration from a PLIST file.

    Expected PLIST format:

    ROOT_KEY (can be the actual PLIST root)
        ARRAY
            an DICTIONARY with possible env KEYS (PRD, SQA etc.) and string/number VALUE
            ...
            an DICTIONARY with possible env keys (PRD, DEV etc.) and string/number VALUE
            ...
*/

@interface TTConfiguration : NSObject
{
@private
    NSString*       _env;
    NSDictionary*   _root;
}

/**
    Init with data in app plist.
*/

- (id)initFromAppPlistWithRootKey:(NSString*)rootKey;

/**
    Init with data in plist at path.
*/

- (id)initFromPlistAtPath:(NSString*)path withRootKey:(NSString*)rootKey;

/**
    @returns NSString or NSNumber
*/

- (id)valueForEnvironmentalKey:(NSString*)environmentalKey;

/**
    @returns NSString, NSNumber, NSArray or NSDictionary
*/

- (id)valueForNormalKey:(NSString*)key;

@end
