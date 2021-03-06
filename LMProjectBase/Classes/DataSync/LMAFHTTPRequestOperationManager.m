//
//  LMAFHTTPRequestOperationManager.m
//  LMProjectBase
//
//  Created by Lukasz Dworakowski on 25.02.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import "LMAFHTTPRequestOperationManager.h"
#import "NSDictionary+URLEncoding.h"

static NSString * const kAPIBaseURLString = @"kAPIBaseURLString";
static NSString * const kAPIApplicationId = @"kAPIApplicationId";
static NSString * const kAPIKey = @"kAPIKey";
static NSString * const kAPIHeaders = @"kAPIHeaders";

@interface LMAFHTTPRequestOperationManager()
@property (strong, nonatomic) NSDictionary *requestHeaders;
@end

@implementation LMAFHTTPRequestOperationManager

+ (instancetype)sharedClient {
    static LMAFHTTPRequestOperationManager *sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSString * urlString = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
        NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:urlString];
        NSLog(@"%@", urlString);
        if (!settingsDictionary) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"There is no settings.plist file in the project."
                                         userInfo:nil];
        }
        
        NSString *baseURLString = [settingsDictionary valueForKey:kAPIBaseURLString];
        
        if (!baseURLString) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"There is no 'kAPIBaseURLString' key in settings.plist file."
                                         userInfo:nil];
        }
        
        NSDictionary *tempDictionary = [settingsDictionary valueForKey:kAPIHeaders];
        sharedClient = [[LMAFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString] andHTTPRequestHeaders:sharedClient.requestHeaders];
        sharedClient.requestHeaders = [[NSDictionary alloc] initWithDictionary:tempDictionary];
    });
    
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url andHTTPRequestHeaders: (NSDictionary*) requestHeaders{
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [requestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString * obj, BOOL *stop) {
            [self.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    return self;
}

#pragma mark
#pragma mark changind type of requests


- (void) switchRequestSerializerForJSON{
    if(self.requestHeaders){
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString * obj, BOOL *stop) {
            [self.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }else{
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Request headers are missing."
                                     userInfo:nil];
    }
}

- (void) switchRequestSerializerForHttp {
    if(self.requestHeaders){
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self.requestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString * obj, BOOL *stop) {
            [self.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }else{
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Request headers are missing."
                                     userInfo:nil];
    }
}


#pragma mark
#pragma mark return AFHTTPRequestOperation

- (AFHTTPRequestOperation *)GETHTTPRequestOperationForClass: (Class)className
                                                 parameters: (NSDictionary *)parameters
                                                succedBlock: (void(^)(AFHTTPRequestOperation *operation, id responseObject)) theSucceedBlock
                                               failureBlock: (void(^)(AFHTTPRequestOperation *operation, NSError *error)) theFailureBlock
{
    AFHTTPRequestOperation *operation = nil;
    operation = [self GET:[NSString stringWithFormat:@"classes/%@", NSStringFromClass(className)] parameters:parameters success:theSucceedBlock failure:theFailureBlock];
    return operation;
}

- (AFHTTPRequestOperation*)GETHTTPRequestOperationForCountOfAllRecordsOfClass: (Class) className
                                                             updatedAfterDate: (NSDate *)updatedDate
                                                                 succuedBlock: (succedBlock) theSuccedBlock
                                                                 failureBlock: (failureBlock) theFailureBlock
{
    NSMutableDictionary *paramters  = [NSMutableDictionary dictionary];
    

    if (updatedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        NSString *dateString = [NSString
                                stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",
                                [dateFormatter stringFromDate:updatedDate]];
        
        
        [paramters setObject:dateString forKey:@"where"];
    }
    
    AFHTTPRequestOperation *operation = nil;
    
    [paramters setValue:@"1" forKey:@"count"];
    [paramters setValue:@"0" forKey:@"limit"];
    
    operation = [self GETHTTPRequestOperationForClass:className parameters:paramters succedBlock:theSuccedBlock failureBlock:theSuccedBlock];
    return operation;
}

- (AFHTTPRequestOperation*)GETHTTPRequestOperationForAllRecordsOfClass: (Class)className
                                                      updatedAfterDate: (NSDate *)updatedDate
                                                          withRowLimit: (NSUInteger) rowLimit
                                                          skipElements: (NSUInteger) skipElements
                                                           succedBlock: (void(^)(AFHTTPRequestOperation *operation, id responseObject)) theSucceedBlock
                                                          failureBlock: (void(^)(AFHTTPRequestOperation *operation, NSError *error)) theFailureBlock
{
    AFHTTPRequestOperation *operation = nil;
    NSMutableDictionary *paramters  = [NSMutableDictionary dictionary];
    
    if (updatedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        NSString *dateString = [NSString
                                stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",
                                [dateFormatter stringFromDate:updatedDate]];
        
        
        [paramters setObject:dateString forKey:@"where"];
    }
    
    if(rowLimit!=-1)
    {
        [paramters setValue:[NSString stringWithFormat:@"%lu", (unsigned long)rowLimit] forKey:@"limit"];
    }
    
    if(skipElements!=-1)
    {
        [paramters setValue:[NSString stringWithFormat:@"%lu", (unsigned long)skipElements] forKey:@"skip"];
    }
    
    operation = [self GETHTTPRequestOperationForClass:className parameters:paramters succedBlock:theSucceedBlock failureBlock:theFailureBlock];
    return operation;
}


- (AFHTTPRequestOperation*)GETHTTPRequestOperationForRelationName: (NSString*) theRelationName
                                                withOwnerGlobalId: (NSString*) theOwnerGlobalId
                                                          inClass: (Class) ownerClass
                                                    relationClass: (Class) relationClass
                                                  withSuccedBlock: (succedBlock) thesuccedBlock
                                                 withFailureBlock: (failureBlock) theFailureBlock
{
    AFHTTPRequestOperation *operation;
    
    NSString* relatedToString  = [self preapreRelatedToStringRequestForClass:ownerClass ownerGlobalId:theOwnerGlobalId relationNameInTheAPI:theRelationName];
    
    NSDictionary *whereDictionary = [NSDictionary dictionaryWithObject:relatedToString forKey:@"where"];
    operation=[self GETHTTPRequestOperationForServerMethod:[NSString stringWithFormat:@"classes/%@", NSStringFromClass(relationClass)] parameters:whereDictionary succeedBlock:thesuccedBlock failureBlock:theFailureBlock];
    
    return operation;
}

- (AFHTTPRequestOperation*)GETHTTPRequestOperationForRelationName: (NSString*) theRelationName
                                                withOwnerGlobalId: (NSString*) theOwnerGlobalId
                                                          inClass: (Class) ownerClass
                                                     forUserClass: (Class) userClass
                                                  withSuccedBlock: (succedBlock) thesuccedBlock
                                                 withFailureBlock: (failureBlock) theFailureBlock
{
    NSParameterAssert([NSStringFromClass(userClass) isEqualToString:@"User"]);
    AFHTTPRequestOperation *operation;
    
    NSString* relatedToString  = [self preapreRelatedToStringRequestForClass:ownerClass ownerGlobalId:theOwnerGlobalId relationNameInTheAPI:theRelationName];
    
    NSDictionary *whereDictionary = [NSDictionary dictionaryWithObject:relatedToString forKey:@"where"];
    
    
    operation=[self GETHTTPRequestOperationForServerMethod:@"users" parameters:whereDictionary succeedBlock:thesuccedBlock failureBlock:theFailureBlock];
    
    return operation;
}


- (AFHTTPRequestOperation*)GETHTTPRequestOperationForClass: (Class)className
                                           orderDescending: (BOOL) descendingOrder
                                              withRowLimit: (NSUInteger) theRowLimit
                                          includeRelations: (NSArray*) theRelationNames
                                           withSuccedBlock: (succedBlock) theSuccedBlock
                                          withFailureBlock: (failureBlock) theFailureBlock
{
    AFHTTPRequestOperation *operation;
    NSMutableDictionary *queryDictionary = [NSMutableDictionary dictionary];
    
    if(descendingOrder)
    {
        [queryDictionary setObject:@"-createdAt" forKey:@"order"];
    }
    
    if(theRowLimit!=-1)
    {
        [queryDictionary setObject:[NSNumber numberWithInt:(int)theRowLimit] forKey:@"limit"];
    }
    
    if(theRelationNames.count>0)
    {
        [queryDictionary setObject:theRelationNames forKey:@"include"];
    }
    
// PREVIOUSLY:
//    if(descendingOrder)
//    {
//        NSString *descendingOrder = @"{\"order\"=\"-createdAt\"}";
//        [finalQueryString stringByAppendingString:descendingOrder];
//    }
//    
//    if(theRowLimit!=-1)
//    {
//        NSString *rowLimit = [NSString stringWithFormat:@"{\"limit\"=%d}", theRowLimit];
//        if(descendingOrder){
//            [finalQueryString stringByAppendingString:@","];
//        }
//        [finalQueryString stringByAppendingString:rowLimit];
//    }
//    
//    if(theRelationNames.count>0)
//    {
//        NSString *relationFinalQuery = @"{\"include=\"";
//
//        if(descendingOrder || theRowLimit!=-1)
//        {
//            [finalQueryString stringByAppendingString:@","];
//            
//            int i = 0;
//            
//            for(NSString *relation in theRelationNames)
//            {
//                i+=1;
//                
//                [relationFinalQuery stringByAppendingString:relation];
//                
//                if(i!=theRelationNames.count)
//                {
//                    [relationFinalQuery stringByAppendingString:@","];
//                }
//            }
//            
//            [relationFinalQuery stringByAppendingString:@"}"];
//        }
//    }
//    
//    [finalQueryString stringByAppendingString:@"}"];
    
//     NSDictionary *jsonDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
//     @"Sean Plott", @"playerName",
//     [NSNumber numberWithBool:NO], @"cheatMode", nil];
//     
//     NSError *error = nil;
//     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&error];
//     
//     if (!jsonData) {
//     NSLog(@"NSJSONSerialization failed %@", error);
//     }
//     
//     NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//     
//     NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
//     json, @"where", nil];
    
    
// [{"__type":"Pointer","className":"TargetClassNameHere","objectId":"actualObjectIdHere"},{"__type":"Pointer","className":"TargetClassNameHere","objectId":"actualObjectIdHere"}] jako Array
//I wtedy:
//curl -X GET \
-H "X-Parse-Application-Id: HT1sV7Uers3Bj7TRtAcbq2cWysXlcoDJfYqPxrmy" \
-H "X-Parse-REST-API-Key: HcZ2K3z6LMQ2a3N8q95417X56ACm3Q18b4aqgEIK" \
-G \
--data-urlencode 'order=-createdAt' \
--data-urlencode 'limit=10' \
--data-urlencode 'include=post' \
https://api.parse.com/1/classes/Comment

//@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",
    
    operation = [self GETHTTPRequestOperationForClass:className parameters:queryDictionary succedBlock:theSuccedBlock failureBlock:theFailureBlock];
    return operation;
}

- (AFHTTPRequestOperation *)GETHTTPRequestOperationForServerMethod: (NSString *)requestString
                                                        parameters: (NSDictionary*)parameters
                                                      succeedBlock: (void(^)(AFHTTPRequestOperation *operation, id responseObject)) theSucceedBlock
                                                      failureBlock: (void(^)(AFHTTPRequestOperation *operation, NSError *error)) theFailureBlock{
    AFHTTPRequestOperation *operation = nil;
    operation = [self GET:[NSString stringWithFormat:@"/1/%@",requestString] parameters:parameters success:theSucceedBlock failure:theSucceedBlock];
    return operation;
}

- (AFHTTPRequestOperation *)POSTHTTPRequestOperationForClass: (Class) className
                                                  parameters: (NSDictionary *) parameters
                                                 succedBlock: (succedBlock) theSuccedBlock
                                                failureBlock: (failureBlock) theFailureBlock
{
    AFHTTPRequestOperation *operation;
    //TODO: walidacja parametrow
    operation = [self POST:[NSString stringWithFormat:@"classes/%@", NSStringFromClass(className)] parameters:parameters success:theSuccedBlock failure:theFailureBlock];
    return operation;
}

- (AFHTTPRequestOperation *)POSTHTTPRequestOperationForServerMethod: (NSString*) serverMethod
                                                         parameters: (NSDictionary*) parameters
                                                        succedBlock: (succedBlock) theSuccedBlock
                                                       failureBlock: (failureBlock) theFailureBlock{
    AFHTTPRequestOperation *operation;
    //TODO: walidacja parametrow
    operation = [self POST:[NSString stringWithFormat:@"/1/%@",serverMethod] parameters:parameters success:theSuccedBlock failure:theFailureBlock];
    return operation;
}


- (AFHTTPRequestOperation *)PUTHTTPRequestOperationForClass: (Class) className
                                                 parameters: (NSDictionary *) paramters
                                                   globalId: (NSString*) globalId
                                                succedBlock: (succedBlock) theSuccedBlock
                                               failureBlock: (failureBlock) theFailureBlock
{
    AFHTTPRequestOperation *operation;
    //TODO: walidacja parametrow
    operation = [self PUT:[NSString stringWithFormat:@"classes/%@/%@", NSStringFromClass(className),globalId] parameters:paramters success:theSuccedBlock failure:theFailureBlock];
    return operation;
}

- (AFHTTPRequestOperation *)PUTHTTPRequestOperationForServerMethod: (NSString*) serverMethod
                                                     parameters: (NSDictionary*) parameters
                                                    succedBlock: (succedBlock) theSuccedBlock
                                                   failureBlock: (failureBlock) theFailureBlock{
    AFHTTPRequestOperation *operation = [self PUT:[NSString stringWithFormat:@"/1/%@",serverMethod] parameters:parameters success:theSuccedBlock failure:theFailureBlock];
    return operation;
}

- (AFHTTPRequestOperation *) PUTHTTPRelationRequestOperationForParentClass:(Class) parentClassName
                                                             childrenClass:(Class) childrenClassName
                                                              relationName:(NSString*) relationName
                                                        withParentGlobalId:(NSString*) parentGlobalId
                                                      withChildrenGlobalId:(NSString*) childrenGlobalId
                                                               succedBlock:(succedBlock) theSuccedBlock
                                                              failureBlock:(failureBlock) theFailureBlock
{
    AFHTTPRequestOperation *operation;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *localParentName = NSStringFromClass(parentClassName);
    NSString *localChildrenName = NSStringFromClass(childrenClassName);
    
    if([NSStringFromClass(parentClassName) isEqualToString:@"User"])
    {
        localParentName = @"_User";
    }
    else if([NSStringFromClass(childrenClassName) isEqualToString:@"User"])
    {
        localChildrenName = @"_User";
    }
    
    [parameters setObject:@"AddRelation" forKey:@"__op"];
    [parameters setObject:@[@{@"__type":@"Pointer",@"className":localChildrenName,@"objectId":childrenGlobalId}] forKey:@"objects"];
    
    NSMutableDictionary *relationParameters = [NSMutableDictionary dictionaryWithObject:parameters forKey:relationName];
    
    operation = [self PUT:[NSString stringWithFormat:@"classes/%@/%@",localParentName, parentGlobalId] parameters:relationParameters success:theSuccedBlock failure:theFailureBlock];
    return operation;
}


- (AFHTTPRequestOperation *)DELETEHTTPRequestOperationForClass: (Class) className
                                                      objectId: (NSString*) globalId
                                                   succedBlock: (succedBlock) theSuccedBlock
                                                  failureBlock: (failureBlock) theFailureBlock
{
    AFHTTPRequestOperation *operation;
    //TODO: walidacja parametrow
    operation = [self DELETE:[NSString stringWithFormat:@"classes/%@/%@", className, globalId] parameters:nil success:theSuccedBlock failure:theFailureBlock];
    return operation;
}

- (AFHTTPRequestOperation*)DELETEHTTPRequestOperationForServerMethod:(NSString*) serverMethod
                                                         succedBlock:(succedBlock) theSuccedBlock
                                                        failureBlock:(failureBlock) theFailureBlock
{
     AFHTTPRequestOperation *operation = [self DELETE:[NSString stringWithFormat:@"/1/%@",serverMethod] parameters:nil success:theSuccedBlock failure:theFailureBlock];
    return operation;
}


- (AFHTTPRequestOperation*)POSTHTTPRequestOperationForPhoto: (NSURL*) location
                                               imageQuality: (CGFloat) quality
                                             localImageName: (NSString*) imageName
                                                succedBlock: (succedBlock) theSuccedBlock
                                               failureBlock: (failureBlock) theFailureBlock
{
    AFHTTPRequestOperation *operation;
    
    operation = [self POST:[NSString stringWithFormat:@"files/%@", imageName] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:location name:imageName fileName:imageName mimeType:@"image/jpeg" error:nil];
    } success:theSuccedBlock failure:theFailureBlock];
    return operation;
}

#pragma mark
#pragma mark return NSMutableRequests

- (NSMutableURLRequest*)POSTHTTPRequestForPhoto: (NSURL*) location
                                   imageQuality: (CGFloat) quaility
                                 localImageName: (NSString*) imageName
                                     completion: (completionBlock) theCompletionBlock
{
    NSMutableString *urlString = [NSMutableString string];
    NSString *pathString = [NSString stringWithFormat:@"files/%@",imageName];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
    
    assert(image);
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[location path] error:nil];
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    
    NSLog(@"Rozmia zdjecia to %lld bajtow", fileSize);
    
    [urlString appendString:self.baseURL.absoluteString];
    [urlString appendString:pathString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[LMAFHTTPRequestOperationManager sharedClient] switchRequestSerializerForHttp];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    [self.requestSerializer.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request addValue:obj forHTTPHeaderField:key];
    }];
    
    [request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:UIImageJPEGRepresentation(image, quaility)];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:theCompletionBlock];
    
    [[LMAFHTTPRequestOperationManager sharedClient] switchRequestSerializerForJSON];
    
    return request;
}

- (NSMutableURLRequest*) POSTHTTPRequestForFile:(NSURL*) location
                                  localFileName: (NSString*) fileName completion: (completionBlock) theCompletionBlock
{
    //TODO: implementacja
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSString*) preapreRelatedToStringRequestForClass: (Class) theOwnerOfTheRelation
                                      ownerGlobalId: (NSString*) theOwnerGlobalId
                               relationNameInTheAPI: (NSString*) theRelationName
{
    return [NSString stringWithFormat:@"{\"$relatedTo\":{\"object\":{\"__type\":\"Pointer\",\"className\":\"%@\",\"objectId\":\"%@\"},\"key\":\"%@\"}}", NSStringFromClass(theOwnerOfTheRelation),theOwnerGlobalId,theRelationName];
}


@end
