//
//  LMObjectManager.h
//  LMProject
//
//  Created by Lukasz Dworakowski on 10.03.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMObjectManager : NSObject
- (void) uploadChangedObjects;
- (void) uploadNewObjects;
- (void) downloadInitialData;
- (void) downloadAllRowsChangedAfterData: (NSDate*) date;
- (void) downloadAllRowsForClass: (Class) className;
- (void) downloadAllRowsForClass: (Class) className withPredicate: (NSPredicate*) predicate withSortDescriptors: (NSArray*) sortDescriptors withCount: (int) maxCount;
- (void) uploadNewObjectForEntityName: (NSString*) entity withParameters: (NSDictionary*) parameters;
- (void) uploadChangedObjectsForEntityName: (Class) entityClass;
- (BOOL) deleteObjectWithGlobalId: (NSString*) globalId;
@end
