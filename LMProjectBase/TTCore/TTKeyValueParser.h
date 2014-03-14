//
//  TTKeyValueParser.h
//  TT
//
//  Created by AA on 10/03/14.
//  Copyright (c) 2014 Transition Technologies S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    This class is intended to make parsing "indexed" user-defined attributes
    (e.g. someProperty0, someProperty1 eg.) easier. Subclass TTKeyValueParser,
    add properties to it of form ^[A-Za-a]s$ with type NSMutableArray and call
    method below to marshal "indexed" properties into those properties.

    ----

    Example:

    You have user-defined attributes on SomeViewController in Storyboard:

    someText0
    someText1

    You subclass TTKeyValueParser naming subclass SomeKeyValueParser adding
    to it property:

    @property (strong, nonatomic) NSMutableArray* someTexts;
 
    You add a field (or property) for instance of SomeKeyValueParser:

    SomeKeyValueParser* _keyValueParser;

    You override setValue:forKey: on SomeViewController:

    - (void)setValue:(id)value forKey:(NSString*)key
    {
        if (!_keyValueParser)
        {
            _keyValueParser = [[SomeKeyValueParser alloc] init];
        }

        if (![_keyValueParser parseKey:key withValue:value])
        {
            [super setValue:value forKey:key];
        }
        else
        {
            // Trigger some response to new items in someTexts property?
        }
    }

    And thats it.
*/

@interface TTKeyValueParser : NSObject

- (BOOL)parseKey:(NSString*)key withValue:(id)value;

@end
