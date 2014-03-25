//
//  LMUserManager.h
//  
//
//  Created by Lukasz Dworakowski on 11.03.2014.
//
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

typedef void (^succedBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^failureBlock)(AFHTTPRequestOperation *operation, NSError *error);

typedef void (^completionBlock)(NSURLResponse * response, NSData *data, NSError *error);

@interface LMUserManager : NSObject
+ (instancetype) sharedInstance;
- (void) loginUser:(NSString*) userName
      withPassword:(NSString*) password
   withSuccedBlock:(succedBlock) theSuccedBlock
  withFailureBlock:(failureBlock) theFailureBlock;

- (void) registerUser:(NSString*) userName
         withPassword:(NSString*) password
      withSuccedBlock:(succedBlock) theSuccedBlock
     withFailureBlock:(failureBlock) theFailureBlock;

- (void)updateUserId: (NSString*) userId
    forParameterName: (NSString*) parameterName
            newValue: (NSString*) valueToBeSet
    withSessionToken: (NSString*) sessionToken
     withSuccedBlock: (succedBlock) theSuccedBlock
    withFailureBlock: (failureBlock) theFailueBlock;

- (void) retriveUserByGlobalUserId:(NSString*) globalUserId
                   withSuccedBlock:(succedBlock) theSuccedBlock
                  withFailureBlock:(failureBlock) theFailureBlock;

- (void) validateSessionToken:(NSString*) sessionToken
              withSuccedBlock:(succedBlock) theSuccedBlock
                 failureBlock:(failureBlock) theFailureBlock;

- (void) getAllRegisteredUsersWithQueryParamters: (NSDictionary*) parameters
                                     succedBlock: (succedBlock) theSuccedBlock
                                    failureBlock: (failureBlock) theFailureBlock;

- (void) deleteUserId: (NSString*) userId
     withSessionToken: (NSString*) sessionToken
      withSuccedBlock: (succedBlock) theSuccedBlock
     withFailureBlock: (failureBlock) theFailureBlock;
@end
