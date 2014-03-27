//
//  LDArrayFunctions.m
//  LM
//
//  Created by Lukasz Dworakowski on 27.03.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import "LDArrayFunctions.h"

@implementation LDArrayFunctions
NSArray *zip(id(^map)(NSArray *objs), int count, NSArray *first, ...)
{
    va_list ap;
    va_start(ap, first);
    
    NSMutableArray *allArrays = [NSMutableArray array];
    [allArrays addObject:first];
    for(int i = 0; i < count - 1; ++i)
    {
        [allArrays addObject:va_arg(ap, NSArray *)];
    }
    
    NSArray *arrays = [allArrays sortedArrayUsingComparator:^NSComparisonResult(NSArray *array1, NSArray *array2) {
        
        return [@(array1.count) compare:@(array2.count)];
    }];
    
    NSMutableArray *zipped = [NSMutableArray array];
    
    NSInteger iterationCount =  ((NSArray*)arrays[0]).count;
    for(NSUInteger i = 0; i < iterationCount; ++i)
    {
        NSMutableArray *objs = [NSMutableArray array];
        for(NSArray *array in arrays)
        {
            [objs addObject:array[i]];
        }
        
        [zipped addObject:map([objs copy])];
    };
    
    va_end(ap);
    
    return [zipped copy];
}
@end
