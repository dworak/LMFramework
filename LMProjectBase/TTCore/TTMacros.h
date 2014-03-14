//
//  TTMacros.h
//  TT
//
//  Created by Andrzej Auchimowicz on 15/05/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#ifndef TTMacros_h
#define TTMacros_h

/**
    Logging macros.
*/

#if LOG_LEVEL >= 4
    #define DBG(...) NSLog(__VA_ARGS__)
#else
    #define DBG(...)
#endif

#if LOG_LEVEL >= 3
    #define INFO(...) NSLog(__VA_ARGS__)
#else
    #define INFO(...)
#endif

#if LOG_LEVEL >= 2
    #define WARN(...) NSLog(__VA_ARGS__)
#else
    #define WARN(...)
#endif

#if LOG_LEVEL >= 1
    #define ERROR(...) NSLog(__VA_ARGS__)
#else
    #define ERROR(...)
#endif

#define LOG_ALWAYS(...) NSLog(__VA_ARGS__)

/**
    TT library specific logging macros.
*/

#define TT_LOG_GOOGLE_SERICE(...) INFO(__VA_ARGS__)
#define TT_LOG_HTML(...) INFO(__VA_ARGS__)

/**
    String macros
*/

#define TT_LOCALIZE(Key) \
    ({ \
        NSString* result = NSLocalizedStringWithDefaultValue(Key, nil, [NSBundle mainBundle], @"TT_DEFAULT_VALUE", @""); \
        assert(![result isEqualToString:@"TT_DEFAULT_VALUE"]); \
        if ([result isEqualToString:@"TT_DEFAULT_VALUE"])\
        {\
            result = Key;\
        }\
        result; \
    })

#define TT_STRINGIZE(Data) ([NSString stringWithFormat:@"%s", #Data])

/**
    Casting macros
*/

#define TT_CAST(Class, Value) \
    ({ \
        id result = nil; \
        \
        if ([Value isMemberOfClass:[Class class]]) \
        { \
            result = (Class*) Value; \
        } \
        \
        result; \
    })

/**
    Exception construction macros
*/

#define TT_MAKE_ERROR(Class, Code, UnderlayingError) [NSError errorWithDomain:NSStringFromClass(Class) code:Code userInfo:UnderlayingError ? @{ NSUnderlyingErrorKey : (id)UnderlayingError } : nil]

#define TT_MAKE_EXCEPTION(Class, Reason, UserInfo) ([NSException exceptionWithName:[NSString stringWithFormat:@"%@Exception", NSStringFromClass(Class)] reason:Reason userInfo:UserInfo])

#define TT_MAKE_REASON_NOT_IMPLEMENTED ([NSString stringWithFormat:@"Method %@ is not implemented", NSStringFromSelector(_cmd)])

/**
    Threading macros
*/

#define TT_TEST_MAIN_THREAD if ([NSThread currentThread] != [NSThread mainThread]) { @throw [NSException exceptionWithName:@"TTInvalidThread" reason:@"This is not main thread!" userInfo:nil]; }

/**
    Warning suppression macros
*/

#define TT_REFERENCE_UNUSED_VARIABLE(T) if (&T);

/**
    Coding conventions
*/

#define TTInternalAction void

/**
    Validation macros
*/

#define TT_CHECK_NOT_NIL(T) \
    ({\
        assert(T); \
        T;\
    })

#endif
