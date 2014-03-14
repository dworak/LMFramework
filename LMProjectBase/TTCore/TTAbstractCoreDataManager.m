//
//  TTAbstractCoreDataManager.m
//  TT
//
//  Created by Andrzej Auchimowicz on 28/01/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import "TTAbstractCoreDataManager.h"

#import "NSArray+TT.h"
#import "TTAbstractCoreDataManager+Internals.h"
#import "TTMacros.h"

@interface NSManagedObject (TT)

/**
    This will only work when you use Mogenerator.
*/

+ (NSString*)entityName;

@end

@implementation TTAbstractCoreDataManager

@synthesize managedObjectContext = __managedObjectContext;

- (void)setDelegate:(id<TTCoreDataManagerDelegate>)delegate
{
    if (self.delegate)
    {
        assert(self.delegate == delegate);
    }
    
    _delegate = delegate;
}

//MARK: Initialization

- (void)dealloc
{
    [self disableMerging];
}

//MARK: Get rows.

- (id)getRowFromRowInAnotherContext:(id)row
{
    assert(row);
    
    NSURL* url = [[row objectID] URIRepresentation];
    return [self getRowWithURI:url];
}

+ (id)getRowInContext:(NSManagedObjectContext*)context fromRowInAnotherContext:(id)row
{
    assert(context && row);
    assert([row managedObjectContext] != context); // This assert is more of a performance warning that invalid code indicator...
    
    NSURL* url = [[row objectID] URIRepresentation];
    return [self getRowWithURI:url inContext:context];
}

- (id)getRowsFromRowsInAnotherContext:(NSArray*)rows
{
    return [TTAbstractCoreDataManager getRowsInContext:self.managedObjectContext fromRowsInAnotherContext:rows];
}

+ (id)getRowsInContext:(NSManagedObjectContext*)context fromRowsInAnotherContext:(NSArray*)rows
{
    assert(context && rows.count > 0);
    
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:rows.count];
    
    for (id i in rows)
    {
        [result addObject:[TTAbstractCoreDataManager getRowInContext:context fromRowInAnotherContext:i]];
    }
    
    return result;
}

- (id)getRowWithURI:(NSURL*)uri
{
    return [TTAbstractCoreDataManager getRowWithURI:uri inContext:self.managedObjectContext];
}

+ (id)getRowWithURI:(NSURL*)uri inContext:(NSManagedObjectContext*)context
{
    assert(uri && context);
    
    NSManagedObjectID* objectId = [context.persistentStoreCoordinator managedObjectIDForURIRepresentation:uri];
    
    NSError* error;
    NSManagedObject* object = [context existingObjectWithID:objectId error:&error];
    
    if (error)
    {
        ERROR(@"getRowWithURI:inContext failed with error: %@", error);
        return nil;
    }
    
    if (!object)
    {
        return nil;
    }
    
    //return object;
    
    // For some reason [context refreshObject:mergeChanges:] is not enough
    // to refresh object. Refetching seems to work though...
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self == %@", object];
    
    NSArray* results = [self getRowsFromEntity:[object class] withPredicate:predicate andSortDescriptors:nil fromRow:-1 maxCount:2 inContext:context];
    
    if (results.count == 0)
    {
        return nil;
    }
    
    object = [results objectAtIndex:0];
    [context refreshObject:object mergeChanges:YES];
    return object;
}

- (NSArray*)getRowsFromEntity:(Class)entityClass
{
    return [TTAbstractCoreDataManager getRowsFromEntity:entityClass inContext:[self managedObjectContext]];
}

- (NSArray*)getRowsFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate andSortDescriptors:(NSArray*)sortDescriptors fromRow:(NSUInteger)from maxCount:(NSUInteger)maxCount
{
    return [TTAbstractCoreDataManager getRowsFromEntity:entityClass withPredicate:predicate andSortDescriptors:sortDescriptors fromRow:from maxCount:maxCount inContext:[self managedObjectContext]];
}

- (id)getRowFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate
{
    return [TTAbstractCoreDataManager getRowFromEntity:entityClass withPredicate:predicate inContext:self.managedObjectContext];
}

+ (id)getRowFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate inContext:(NSManagedObjectContext*)context
{
    if (predicate == nil)
    {
        @throw TT_MAKE_EXCEPTION([self class], @"Fetching single row without predicate is forbidden", nil);
    }
    
    NSArray* results = [self getRowsFromEntity:entityClass withPredicate:predicate andSortDescriptors:nil fromRow:-1 maxCount:2 inContext:context];
    assert(results.count <= 1);
    return [results firstObject];
}

+ (NSArray*)getRowsFromEntity:(Class)entityClass inContext:(NSManagedObjectContext*)context
{
    assert(context);
    
    NSError* error;
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString* entityName = [entityClass entityName];
    assert(entityName);
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    assert(entity);
    
    [fetchRequest setEntity:entity];
    
    NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

+ (NSArray*)getRowsFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate andSortDescriptors:(NSArray*)sortDescriptors fromRow:(NSUInteger)from maxCount:(NSUInteger)maxCount inContext:(NSManagedObjectContext*)context
{
    assert(context);
    
    NSError* error;
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString* entityName = [entityClass entityName];
    assert(entityName);
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    assert(entity);
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    if (from != -1)
    {
        [fetchRequest setFetchOffset:from];
    }
    
    if (maxCount != -1)
    {
        [fetchRequest setFetchLimit:maxCount];
    }
    
    NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

//MARK: Count rows.

- (NSUInteger)countRowsFromEntity:(Class)entityClass
{
    return [TTAbstractCoreDataManager countRowsFromEntity:entityClass inContext:self.managedObjectContext];
}

- (NSUInteger)countRowsFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate fromRow:(NSUInteger)from maxCount:(NSUInteger)maxCount
{
    return [TTAbstractCoreDataManager countRowsFromEntity:entityClass withPredicate:predicate fromRow:from maxCount:maxCount inContext:self.managedObjectContext];
}

+ (NSUInteger)countRowsFromEntity:(Class)entityClass inContext:(NSManagedObjectContext*)context
{
    assert(context);
    
    NSError* error;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString* entityName = [entityClass entityName];
    assert(entityName);
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    assert(entity);
    
    [fetchRequest setEntity:entity];
    
    return [context countForFetchRequest:fetchRequest error:&error];
}

+ (NSUInteger)countRowsFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate fromRow:(NSUInteger)from maxCount:(NSUInteger)maxCount inContext:(NSManagedObjectContext*)context
{
    assert(context);
    
    NSError* error;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString* entityName = [entityClass entityName];
    assert(entityName);
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    assert(entity);
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    if (from != -1)
    {
        [fetchRequest setFetchOffset:from];
    }
    
    if (maxCount != -1)
    {
        [fetchRequest setFetchLimit:maxCount];
    }
    
    NSUInteger result = [context countForFetchRequest:fetchRequest error:&error];
    return result;
}

//MARK: Delete entities.

- (void)removeObject:(NSManagedObject*)object
{
    assert(object.managedObjectContext == [self managedObjectContext]);
    [TTAbstractCoreDataManager removeObject:object];
}

- (BOOL)removeAllObjectsFromEntity:(Class)entityClass
{
    return [TTAbstractCoreDataManager removeAllObjectsFromEntity:entityClass inContext:[self managedObjectContext]];
}

+ (void)removeObject:(NSManagedObject*)object
{
    assert(object);
    [object.managedObjectContext deleteObject:object];
}

+ (BOOL)removeAllObjectsFromEntity:(Class)entityClass inContext:(NSManagedObjectContext*)context
{
    assert(context);
    
    NSFetchRequest* rows = [[NSFetchRequest alloc] init];
    
    NSString* entityName = [entityClass entityName];
    assert(entityName);
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    assert(entity);
    
    [rows setEntity:entity];
    [rows setIncludesPropertyValues:NO]; // Only fetch the managedObjectID
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:rows error:&error];
    
    if (error)
    {
        ERROR(@"All entity row fetch for removal failed with error %@", error);
        return NO;
    }
    
    for (NSManagedObject* row in results)
    {
        [context deleteObject:row];
    }
    
    return YES;
}

@end