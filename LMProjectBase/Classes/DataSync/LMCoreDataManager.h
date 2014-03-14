//
//  LMCoreDataManager.h
//  LMProject
//
//  Created by Lukasz Dworakowski on 10.03.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMCoreDataManager : NSObject
+ (instancetype)sharedInstance;
+ (NSArray*)getRowsFromEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate andSortDescriptors:(NSArray*)sortDescriptors fromRow:(NSUInteger)from maxCount:(NSUInteger)maxCount inContext:(NSManagedObjectContext*)context;
+ (NSArray*)getRowsFromEntity:(Class)entityClass inContext:(NSManagedObjectContext*)context;
+ (id)getRowWithURI:(NSURL*)uri inContext:(NSManagedObjectContext*)context;
- (NSURL *)applicationDocumentsDirectory;

- (NSManagedObjectContext *)masterManagedObjectContext;
- (NSManagedObjectContext *)backgroundManagedObjectContext;
- (NSManagedObjectContext *)newManagedObjectContext;
- (void)saveMasterContext;
- (void)saveBackgroundContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
@end
