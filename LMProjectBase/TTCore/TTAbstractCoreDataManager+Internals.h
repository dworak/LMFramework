//
//  TTAbstractCoreDataManager+Internals.h
//  TT
//
//  Created by Andrzej Auchimowicz on 28/01/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import "TTAbstractCoreDataManager.h"

/**
    @ingroup TTDatabaseGroup
*/

@interface TTAbstractCoreDataManager (Internals)

/**
    @name Enable or disable automatic merging.
    Usefull mostly for main context initialization and deallocation.
*/

/// @{

- (void)enableMerging;
- (void)disableMerging;

/// @}

/**
    Called before analogous delegate method. Use it to save context etc.
*/

- (void)didMergeChanges;

@end
