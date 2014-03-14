//
//  TTFilesystemManager+Internals.h
//  TT
//
//  Created by Andrzej Auchimowicz on 05/07/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import "TTFilesystemManager.h"

@interface TTFilesystemManager (Internals)

- (void)createDirectoryAtUrlIfDoesNotExist:(NSString*)directory;

@end
