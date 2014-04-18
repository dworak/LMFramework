//
//  LMCoreDataManager.m
//  LMProject
//
//  Created by Lukasz Dworakowski on 10.03.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import "LMCoreDataManager.h"
#import <CoreData/CoreData.h>
#import "LMAppDelegate.h"

@interface LMCoreDataManager()
@property (strong, nonatomic) NSManagedObjectContext *masterManagedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation LMCoreDataManager
+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static LMCoreDataManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
return sharedInstance;
}

#pragma mark - Get all elements from db
- (NSArray*)getRowsFromEntity:(Class)entityClass
{
    return [LMCoreDataManager getRowsFromEntity:entityClass inContext:[self masterManagedObjectContext]];
}

- (NSArray*)getRowsFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate andSortDescriptors:(NSArray*)sortDescriptors fromRow:(NSUInteger)from maxCount:(NSUInteger)maxCount
{
    return [LMCoreDataManager getRowsFromEntity:entityClass withPredicate:predicate andSortDescriptors:sortDescriptors fromRow:from maxCount:maxCount inContext:[self masterManagedObjectContext]];
}

+ (NSArray*)getRowsFromEntity:(Class)entityClass inContext:(NSManagedObjectContext*)context
{
    NSError* error;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSString* entityName = NSStringFromClass(entityClass);
    NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

+ (NSArray*)getRowsFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate andSortDescriptors:(NSArray*)sortDescriptors fromRow:(NSUInteger)from maxCount:(NSUInteger)maxCount inContext:(NSManagedObjectContext*)context
{
    NSError* error;
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSString* entityName = NSStringFromClass(entityClass);
    NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
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

+ (id)getRowWithURI:(NSURL*)uri inContext:(NSManagedObjectContext*)context
{
    NSManagedObjectID* objectId = [context.persistentStoreCoordinator managedObjectIDForURIRepresentation:uri];
    
    NSError* error;
    NSManagedObject* object = [context objectWithID:objectId];
    
    if (error)
    {
        NSLog(@"getRowWithURI:inContext failed with error: %@", error);
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



#pragma mark - Core Data stack

// Used to propegate saves to the persistent store (disk) without blocking the UI
- (NSManagedObjectContext *)masterManagedObjectContext {
    if (_masterManagedObjectContext != nil) {
        return _masterManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _masterManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        [_masterManagedObjectContext performBlockAndWait:^{
            [_masterManagedObjectContext setPersistentStoreCoordinator:coordinator];
            
        }];
        
    }
    return _masterManagedObjectContext;
}

// Return the NSManagedObjectContext to be used in the background during sync
- (NSManagedObjectContext *)backgroundManagedObjectContext {
    if (_backgroundManagedObjectContext != nil) {
        return _backgroundManagedObjectContext;
    }
    
    NSManagedObjectContext *masterContext = [self masterManagedObjectContext];
    if (masterContext != nil) {
        _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundManagedObjectContext performBlockAndWait:^{
            [_backgroundManagedObjectContext setParentContext:masterContext];
        }];
    }
    
    return _backgroundManagedObjectContext;
}

// Return the NSManagedObjectContext to be used in the background during sync
- (NSManagedObjectContext *)newManagedObjectContext {
    NSManagedObjectContext *newContext = nil;
    NSManagedObjectContext *masterContext = [self masterManagedObjectContext];
    if (masterContext != nil) {
        newContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [newContext performBlockAndWait:^{
            [newContext setParentContext:masterContext];
        }];
    }
    
    return newContext;
}

- (void)saveMasterContext {
    [self.masterManagedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.masterManagedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save master context due to %@", error);
        }
    }];
}

- (void)saveBackgroundContext {
    [self.backgroundManagedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.backgroundManagedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save background context due to %@", error);
        }
    }];
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSString *projectName =  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:projectName withExtension:@"momd"];
    
    NSAssert1(modelURL, @"There is no model named %@",projectName);
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"]];
    NSAssert(settingsDictionary, @"There is no settings.plist file in your mainBundle");
    
    NSString *projectName = [settingsDictionary valueForKey:@"projectName"];
    
    NSAssert(projectName, @"There is no value for projectName in your settings.plist");
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",projectName]];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,
                              NSInferMappingModelAutomaticallyOption:@YES,
                              NSSQLitePragmasOption: @{@"journal_mode": @"WAL"}
                              };
    
    // Check if we need a migration
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:storeURL error:&error];
    NSManagedObjectModel *destinationModel = [_persistentStoreCoordinator managedObjectModel];
    BOOL isModelCompatible = (sourceMetadata == nil) || [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
    if (! isModelCompatible) {
        // We need a migration, so we set the journal_mode to DELETE
        options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,
                    NSInferMappingModelAutomaticallyOption:@YES,
                    NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}
                    };
    }
    
    NSPersistentStore *persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
    if (! persistentStore) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Reinstate the WAL journal_mode
    if (! isModelCompatible) {
        [_persistentStoreCoordinator removePersistentStore:persistentStore error:NULL];
        options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,
                    NSInferMappingModelAutomaticallyOption:@YES,
                    NSSQLitePragmasOption: @{@"journal_mode": @"WAL"}
                    };
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
    }
    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
