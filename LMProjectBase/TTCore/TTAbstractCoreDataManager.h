//
//  TTAbstractCoreDataManager.h
//  TT
//
//  Created by Andrzej Auchimowicz on 28/01/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import "TTSingleton.h"

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TTAbstractCoreDataManager;

/**
    @ingroup TTDatabaseGroup
*/

@protocol TTCoreDataManagerDelegate <NSObject>

- (void)coreDataManagerWasUpdatedAfterMerge:(TTAbstractCoreDataManager*)coreDataManager;

@end

/**
    @ingroup TTDatabaseGroup
*/

@interface TTAbstractCoreDataManager : TTSingleton
{
@protected
    NSManagedObjectContext* _managedObjectContext;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@property (weak, nonatomic) id<TTCoreDataManagerDelegate> delegate;

/**
    @name Entity selection methods
*/

/// @{

- (id)getRowFromRowInAnotherContext:(id)row;
+ (id)getRowInContext:(NSManagedObjectContext*)context fromRowInAnotherContext:(id)row;

- (id)getRowsFromRowsInAnotherContext:(NSArray*)rows;
+ (id)getRowsInContext:(NSManagedObjectContext*)context fromRowsInAnotherContext:(NSArray*)rows;

- (id)getRowWithURI:(NSURL*)uri;
+ (id)getRowWithURI:(NSURL*)uri inContext:(NSManagedObjectContext*)context;

- (NSArray*)getRowsFromEntity:(Class)entityClass;
- (NSArray*)getRowsFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate andSortDescriptors:(NSArray*)sortDescriptors fromRow:(NSUInteger)from maxCount:(NSUInteger)maxCount;

- (id)getRowFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate;
+ (id)getRowFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate inContext:(NSManagedObjectContext*)context;

+ (NSArray*)getRowsFromEntity:(Class)entityClass inContext:(NSManagedObjectContext*)context;
+ (NSArray*)getRowsFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate andSortDescriptors:(NSArray*)sortDescriptors fromRow:(NSUInteger)from maxCount:(NSUInteger)maxCount inContext:(NSManagedObjectContext*)context;

/// @}

/**
    @name Entity counting methods
*/

/// @{

- (NSUInteger)countRowsFromEntity:(Class)entityClass;
- (NSUInteger)countRowsFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate fromRow:(NSUInteger)from maxCount:(NSUInteger)maxCount;

+ (NSUInteger)countRowsFromEntity:(Class)entityClass inContext:(NSManagedObjectContext*)context;
+ (NSUInteger)countRowsFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate fromRow:(NSUInteger)from maxCount:(NSUInteger)maxCount inContext:(NSManagedObjectContext*)context;

/// @}

/**
    @name Entity deletion methods
*/

/// @{

- (void)removeObject:(NSManagedObject*)object;
- (BOOL)removeAllObjectsFromEntity:(Class)entityClass;

+ (void)removeObject:(NSManagedObject*)object;
+ (BOOL)removeAllObjectsFromEntity:(Class)entityClass inContext:(NSManagedObjectContext*)context;

/// @}

@end
