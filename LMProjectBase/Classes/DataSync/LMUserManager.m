//
//  LMUserManager.m
//  
//
//  Created by Lukasz Dworakowski on 11.03.2014.
//
//

#import "LMUserManager.h"
#import "LMAFHTTPRequestOperationManager.h"

@implementation LMUserManager
+ (instancetype) sharedInstance{
    static dispatch_once_t once;
    static LMUserManager *instance;
    dispatch_once(&once, ^{
        instance = [[LMUserManager alloc] init];
    });
    return instance;
}

- (void) loginUser:(NSString*) userName
      withPassword:(NSString*) password
   withSuccedBlock:(succedBlock) theSuccedBlock
  withFailureBlock:(failureBlock) theFailureBlock;
{
    LMAFHTTPRequestOperationManager *manager = [LMAFHTTPRequestOperationManager sharedClient];
    [manager switchRequestSerializerForJSON];
    NSDictionary *loginDictionary = @{@"username":userName, @"password":password};
    [manager GETHTTPRequestOperationForServerMethod:@"login" parameters:loginDictionary succeedBlock:theSuccedBlock failureBlock:theFailureBlock];
}

- (void) registerUser:(NSString*) userName
         withPassword:(NSString*) password
      withSuccedBlock:(succedBlock) theSuccedBlock
     withFailureBlock:(failureBlock) theFailureBlock
{
    NSDictionary *registerDictionary = @{@"username": userName, @"password":password};
    
    LMAFHTTPRequestOperationManager *manager = [LMAFHTTPRequestOperationManager sharedClient];
    [manager switchRequestSerializerForJSON];
    [manager POSTHTTPRequestOperationForServerMethod:@"users" parameters:registerDictionary succedBlock:theSuccedBlock failureBlock:theSuccedBlock];
    
}

- (void) getAllRegisteredUsersWithQueryParamters: (NSDictionary*) parameters
                                     succedBlock: (succedBlock) theSuccedBlock
                                    failureBlock: (failureBlock) theFailureBlock
{
    LMAFHTTPRequestOperationManager *manager = [LMAFHTTPRequestOperationManager sharedClient];
    [manager switchRequestSerializerForHttp];
    NSDictionary *parametersForQuery;
    if (parameters) {
        
//        TODO: tworzenie odpowiednio sformatowanych zapytan
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//        
//        NSString *jsonString = [NSString
//                                stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",
//                                [dateFormatter stringFromDate:updatedDate]];

        parametersForQuery = [NSDictionary dictionaryWithObject:parameters forKey:@"where"];
    }
    
    [manager GETHTTPRequestOperationForServerMethod:@"users" parameters:parametersForQuery succeedBlock:theSuccedBlock failureBlock:theFailureBlock];
}


- (void) validateSessionToken:(NSString*) sessionToken
              withSuccedBlock:(succedBlock) theSuccedBlock
                 failureBlock:(failureBlock) theFailureBlock
{
    LMAFHTTPRequestOperationManager *manager = [LMAFHTTPRequestOperationManager sharedClient];
    [manager switchRequestSerializerForJSON];
    [manager.requestSerializer setValue:sessionToken forHTTPHeaderField:@"X-Parse-Session-Token"];
    [manager GETHTTPRequestOperationForServerMethod:@"users/me" parameters:nil succeedBlock:theSuccedBlock failureBlock:theFailureBlock];
}

- (void) retriveUserByGlobalUserId:(NSString*) globalUserId
                   withSuccedBlock:(succedBlock) theSuccedBlock
                  withFailureBlock:(failureBlock) theFailureBlock
{
    LMAFHTTPRequestOperationManager *manager = [LMAFHTTPRequestOperationManager sharedClient];
    [manager switchRequestSerializerForJSON];
    [manager GETHTTPRequestOperationForServerMethod:[NSString stringWithFormat:@"users/%@", globalUserId]  parameters:nil succeedBlock:theSuccedBlock failureBlock:theFailureBlock];
}

- (void)updateUserId: (NSString*) userId
    forParameterName: (NSString*) parameterName
            newValue: (NSString*) valueToBeSet
    withSessionToken: (NSString*) sessionToken
     withSuccedBlock: (succedBlock) theSuccedBlock
    withFailureBlock: (failureBlock) theFailueBlock
{
    LMAFHTTPRequestOperationManager *manager = [LMAFHTTPRequestOperationManager sharedClient];
    [manager switchRequestSerializerForJSON];
    [manager.requestSerializer setValue:sessionToken forHTTPHeaderField:@"X-Parse-Session-Token"];
    [manager PUTHTTPRequestOperationForServerMethod:[NSString stringWithFormat:@"users/%@", userId] parameters:@{parameterName:valueToBeSet} succedBlock:theSuccedBlock failureBlock:theFailueBlock];
    
}

- (void) deleteUserId: (NSString*) userId
     withSessionToken: (NSString*) sessionToken
      withSuccedBlock: (succedBlock) theSuccedBlock
     withFailureBlock: (failureBlock) theFailureBlock
{
    LMAFHTTPRequestOperationManager *manager = [LMAFHTTPRequestOperationManager sharedClient];
    [manager switchRequestSerializerForJSON];
    [manager.requestSerializer setValue:sessionToken forHTTPHeaderField:@"X-Parse-Session-Token"];
    [manager DELETEHTTPRequestOperationForServerMethod:[NSString stringWithFormat:@"users/%@", userId] succedBlock:theSuccedBlock failureBlock:theFailureBlock];
}


@end
