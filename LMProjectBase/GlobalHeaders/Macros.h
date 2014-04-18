//
//  Macros.h
//  LM
//
//  Created by Lukasz Dworakowski on 17.04.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#ifndef LM_Macros_h
#define LM_Macros_h

#define LMStringableEnum(ENUM_NAME, ENUM_VALUES...) \
\
typedef enum { \
ENUM_VALUES \
} ENUM_NAME; \
\
\
\
static NSString * ENUM_NAME##ToString(int enumValue) { \
static NSString *enumDescription = @"" #ENUM_VALUES;  \
/*parse the enum values into a dict*/\
static NSDictionary *enumsByValue = nil; \
if (enumsByValue == nil) { \
NSMutableDictionary *mutableEnumsByValue = [NSMutableDictionary dictionary]; \
NSArray *enumPairs = [enumDescription componentsSeparatedByString:@","]; \
\
NSInteger lastValue = 0-1; /*set to 1 before the default value for the first enum*/ \
for (NSString *enumPair in enumPairs) { \
NSArray *labelAndValue = [enumPair componentsSeparatedByString:@"="]; \
NSString *label = [[labelAndValue objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; \
BOOL hasExplictValue = [labelAndValue count] > 1; \
NSInteger value = (hasExplictValue) ? [[labelAndValue objectAtIndex:1] integerValue] : lastValue + 1; \
\
[mutableEnumsByValue setObject:label forKey:[NSNumber numberWithInteger:value]]; \
\
lastValue = value; \
} \
\
enumsByValue = [mutableEnumsByValue copy]; \
} \
\
NSString *label = [enumsByValue objectForKey:[NSNumber numberWithInteger:enumValue]]; \
if (label != nil) return label; \
\
return [NSString stringWithFormat:@"%i not defined as a %s value", enumValue, #ENUM_NAME]; \
}

#endif
