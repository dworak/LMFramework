//
//  TTAbstractCoreDataManager+Internals.m
//  TT
//
//  Created by Andrzej Auchimowicz on 28/01/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import "TTAbstractCoreDataManager+Internals.h"

@implementation TTAbstractCoreDataManager (Internals)

- (void)enableMerging
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ttMergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void)disableMerging
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void)didMergeChanges
{
}

- (void)ttMergeChanges:(NSNotification*)notification
{
    __weak TTAbstractCoreDataManager* selfWeak = self;
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        TTAbstractCoreDataManager* selfStrong = selfWeak;

        if (!selfStrong)
        {
            return;
        }

        [selfStrong.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        [selfStrong didMergeChanges];
        [selfStrong.delegate coreDataManagerWasUpdatedAfterMerge:selfStrong];
    });
}

@end
