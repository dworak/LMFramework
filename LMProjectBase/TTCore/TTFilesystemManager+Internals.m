//
//  TTFilesystemManager+Internals.m
//  TT
//
//  Created by Andrzej Auchimowicz on 05/07/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import "TTFilesystemManager+Internals.h"

@implementation TTFilesystemManager (Internals)

- (void)createDirectoryAtUrlIfDoesNotExist:(NSString*)directory
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory])
    {
        NSError* error;
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
    }
}

@end
