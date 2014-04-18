//
//  LMAFApiManager.h
//  LMProjectBase
//
//  Created by Lukasz Dworakowski on 25.02.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//
#import "AFNetworking.h"
#import <UIKit/UIKit.h>


typedef void (^succedBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^failureBlock)(AFHTTPRequestOperation *operation, NSError *error);

typedef void (^completionBlock)(NSURLResponse * response, NSData *data, NSError *error);

@interface LMAFHTTPRequestOperationManager : AFHTTPRequestOperationManager
+ (instancetype)sharedClient;

- (void) switchRequestSerializerForHttp;
- (void) switchRequestSerializerForJSON;

#pragma mark -
#pragma mark HTTP

- (AFHTTPRequestOperation*)GETHTTPRequestOperationForCountOfAllRecordsOfClass: (Class) className
                                                             updatedAfterDate: (NSDate *)updatedDate
                                                                 succuedBlock: (succedBlock) theSuccedBlock
                                                                 failureBlock: (failureBlock) theFailureBlock;

- (AFHTTPRequestOperation *)GETHTTPRequestOperationForClass: (Class)className
                                                 parameters: (NSDictionary *)parameters
                                                succedBlock: (succedBlock) theSucceedBlock
                                               failureBlock: (failureBlock) theFailureBlock;

- (AFHTTPRequestOperation*)GETHTTPRequestOperationForAllRecordsOfClass: (Class)className
                                                      updatedAfterDate: (NSDate *)updatedDate
                                                          withRowLimit: (NSUInteger) rowLimit
                                                          skipElements: (NSUInteger) skipElements
                                                           succedBlock: (void(^)(AFHTTPRequestOperation *operation, id responseObject)) theSucceedBlock
                                                          failureBlock: (void(^)(AFHTTPRequestOperation *operation, NSError *error)) theFailureBlock;


- (AFHTTPRequestOperation*)GETHTTPRequestOperationForRelationName: (NSString*) theRelationName
                                                withOwnerGlobalId: (NSString*) theOwnerGlobalId
                                                          inClass: (Class) ownerClass
                                                    relationClass: (Class) relationClass
                                                  withSuccedBlock: (succedBlock) thesuccedBlock
                                                 withFailureBlock: (failureBlock) theFailureBlock;

- (AFHTTPRequestOperation*)GETHTTPRequestOperationForClass: (Class)className
                                           orderDescending: (BOOL) descendingOrder
                                              withRowLimit: (NSUInteger) theRowLimit
                                          includeRelations: (NSArray*) theRelationNames
                                           withSuccedBlock: (succedBlock) theSuccedBlock
                                          withFailureBlock: (failureBlock) theFailureBlock;

- (AFHTTPRequestOperation*)GETHTTPRequestOperationForRelationName: (NSString*) theRelationName
                                                withOwnerGlobalId: (NSString*) theOwnerGlobalId
                                                          inClass: (Class) ownerClass
                                                     forUserClass: (Class) userClass
                                                  withSuccedBlock: (succedBlock) thesuccedBlock
                                                 withFailureBlock: (failureBlock) theFailureBlock;

- (AFHTTPRequestOperation *)GETHTTPRequestOperationForServerMethod:(NSString *)requestString
                                                        parameters:(NSDictionary*)parameters
                                                      succeedBlock:(succedBlock) theSucceedBlock
                                                      failureBlock:(failureBlock) theFailureBlock;


- (AFHTTPRequestOperation *)POSTHTTPRequestOperationForServerMethod:(NSString*) serverMethod
                                                         parameters:(NSDictionary*) parameters
                                                        succedBlock:(succedBlock) theSuccedBlock
                                                       failureBlock:(failureBlock) theFailureBlock;


- (AFHTTPRequestOperation *)POSTHTTPRequestOperationForClass: (Class) className
                                                  parameters: (NSDictionary *) parameters
                                                 succedBlock: (succedBlock) theSuccedBlock
                                                failureBlock: (failureBlock) theFailureBlock;

- (NSMutableURLRequest*)POSTHTTPRequestForPhoto: (NSURL*) location
                                   imageQuality: (CGFloat) quaility
                                 localImageName: (NSString*) imageName
                                     completion: (completionBlock) theCompletionBlock;

- (AFHTTPRequestOperation*)POSTHTTPRequestOperationForPhoto: (NSURL*) location
                                               imageQuality: (CGFloat) quality
                                             localImageName: (NSString*) imageName
                                                succedBlock: (succedBlock) theSuccedBlock
                                               failureBlock: (failureBlock) theFailureBlock;

- (AFHTTPRequestOperation *)PUTHTTPRequestOperationForClass: (Class) className
                                                 parameters: (NSDictionary *) paramters
                                                   globalId: (NSString*) globalId
                                                succedBlock: (succedBlock) theSuccedBlock
                                               failureBlock: (failureBlock) theFailureBlock;

- (AFHTTPRequestOperation *)PUTHTTPRequestOperationForServerMethod: (NSString*) serverMethod
                                                        parameters: (NSDictionary*) parameters
                                                       succedBlock: (succedBlock) theSuccedBlock
                                                      failureBlock: (failureBlock) theFailureBlock;

- (AFHTTPRequestOperation *) PUTHTTPRelationRequestOperationForParentClass:(Class) parentClassName
                                                             childrenClass:(Class) childrenClassName
                                                              relationName:(NSString*) relationName
                                                        withParentGlobalId:(NSString*) parentGlobalId
                                                      withChildrenGlobalId:(NSString*) childrenGlobalId
                                                               succedBlock:(succedBlock) theSuccedBlock
                                                              failureBlock:(failureBlock) theFailureBlock;

- (AFHTTPRequestOperation *)DELETEHTTPRequestOperationForClass: (Class) className
                                                      objectId: (NSString*) globalId
                                                   succedBlock: (succedBlock) theSuccedBlock
                                                  failureBlock: (failureBlock) theFailureBlock;

- (AFHTTPRequestOperation*)DELETEHTTPRequestOperationForServerMethod: (NSString*) serverMethod
                                                         succedBlock: (succedBlock) theSuccedBlock
                                                        failureBlock: (failureBlock) theFailureBlock;
@end
