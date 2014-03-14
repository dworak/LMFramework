//
//  LMObjectManager.m
//  LMProject
//
//  Created by Lukasz Dworakowski on 10.03.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import "LMObjectManager.h"
#import "LMAFHTTPRequestOperationManager.h"
#import "LMCoreDataManager.h"
#import <CoreData/CoreData.h>

@implementation LMObjectManager
- (void) uploadChangedObjects
{

}

- (void) uploadNewObjects
{
    
}

- (void) downloadInitialData
{
    
}
- (void) downloadAllRowsChangedAfterData: (NSDate*) date
{
    
}

- (void) downloadAllRowsForClass: (Class) className
{
    
}
- (void) downloadAllRowsForClass: (Class) className withPredicate: (NSPredicate*) predicate withSortDescriptors: (NSArray*) sortDescriptors withCount: (int) maxCount
{
    
}

- (void) uploadNewObjectForEntityName: (NSString*) entity withParameters: (NSDictionary*) parameters
{
//    [[LMAFHTTPRequestOperationManager sharedClient] ]
}

- (void) uploadChangedObjectsForEntityName: (Class) entityClass
{
    NSParameterAssert(entityClass);
    NSAssert([entityClass isSubclassOfClass:[NSManagedObject class]], @"Your class isn't subclass of NSManagedObject class");
    
    NSManagedObjectContext *masterContext = [[LMCoreDataManager sharedInstance] masterManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(entityClass) inManagedObjectContext:masterContext];
    
    NSPredicate *predicateForNotUploaded = [NSPredicate predicateWithFormat:@"uploaded == %@", [NSNumber numberWithBool:NO]];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicateForNotUploaded];
    
    NSError *error;
    NSArray *fetchedObjects = [masterContext executeFetchRequest:fetchRequest error:&error];
    
    [fetchedObjects enumerateObjectsUsingBlock:^(NSManagedObject *obj, NSUInteger idx, BOOL *stop) {
        
    }];
}

- (BOOL) deleteObjectWithGlobalId: (NSString*) globalId{
    return NO;
}
@end
