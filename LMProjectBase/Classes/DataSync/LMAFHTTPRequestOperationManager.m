//
//  LMAFHTTPRequestOperationManager.m
//  LMProjectBase
//
//  Created by Lukasz Dworakowski on 25.02.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import "LMAFHTTPRequestOperationManager.h"

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

- (AFHTTPRequestOperation *)GETHTTPRequestOperationForClass:(Class)className
                                                 parameters:(NSDictionary *)parameters
                                                succedBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject)) theSucceedBlock
                                               failureBlock:(void(^)(AFHTTPRequestOperation *operation, NSError *error)) theFailureBlock
{
    AFHTTPRequestOperation *operation = nil;
    operation = [self GET:[NSString stringWithFormat:@"classes/%@", NSStringFromClass(className)] parameters:parameters success:theSucceedBlock failure:theFailureBlock];
    return operation;
}

- (AFHTTPRequestOperation*)GETHTTPRequestOperationForAllRecordsOfClass:(Class)className
                                                      updatedAfterDate:(NSDate *)updatedDate
                                                           succedBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject)) theSucceedBlock
                                                          failureBlock:(void(^)(AFHTTPRequestOperation *operation, NSError *error)) theFailureBlock
{
    AFHTTPRequestOperation *operation = nil;
    NSMutableDictionary *paramters = nil;
    if (updatedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        NSString *dateString = [NSString
                                stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",
                                [dateFormatter stringFromDate:updatedDate]];
        
        paramters = [NSMutableDictionary dictionary];
        [paramters setObject:dateString forKey:@"where"];
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


- (NSString*) preapreRelatedToStringRequestForClass: (Class) theOwnerOfTheRelation
                                      ownerGlobalId: (NSString*) theOwnerGlobalId
                               relationNameInTheAPI: (NSString*) theRelationName
{
    return [NSString stringWithFormat:@"{\"$relatedTo\":{\"object\":{\"__type\":\"Pointer\",\"className\":\"%@\",\"objectId\":\"%@\"},\"key\":\"%@\"}}", NSStringFromClass(theOwnerOfTheRelation),theOwnerGlobalId,theRelationName];
}


- (AFHTTPRequestOperation *)GETHTTPRequestOperationForServerMethod:(NSString *)requestString
                                                        parameters:(NSDictionary*)parameters
                                                      succeedBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject)) theSucceedBlock
                                                      failureBlock:(void(^)(AFHTTPRequestOperation *operation, NSError *error)) theFailureBlock{
    AFHTTPRequestOperation *operation = nil;
    operation = [self GET:[NSString stringWithFormat:@"/1/%@",requestString] parameters:parameters success:theSucceedBlock failure:theSucceedBlock];
    return operation;
}

- (AFHTTPRequestOperation *)POSTHTTPRequestOperationForClass:(Class) className
                                                  parameters:(NSDictionary *) parameters
                                                 succedBlock:(succedBlock) theSuccedBlock
                                                failureBlock:(failureBlock) theFailureBlock
                                               returnRelations:(BOOL) includeRelations
{
    AFHTTPRequestOperation *operation;
    //TODO: walidacja parametrow
    operation = [self POST:[NSString stringWithFormat:@"classes/%@", NSStringFromClass(className)] parameters:parameters success:theSuccedBlock failure:theFailureBlock];
    return operation;
}

- (AFHTTPRequestOperation *)POSTHTTPRequestOperationForServerMethod:(NSString*) serverMethod
                                                         parameters:(NSDictionary*) parameters
                                                        succedBlock:(succedBlock) theSuccedBlock
                                                       failureBlock:(failureBlock) theFailureBlock{
    AFHTTPRequestOperation *operation;
    //TODO: walidacja
    operation = [self POST:[NSString stringWithFormat:@"/1/%@",serverMethod] parameters:parameters success:theSuccedBlock failure:theFailureBlock];
    return operation;
}


- (AFHTTPRequestOperation *)PUTHTTPRequestOperationForClass:(Class) className
                                                 parameters:(NSDictionary *) paramters
                                                succedBlock:(succedBlock) theSuccedBlock
                                               failureBlock:(failureBlock) theFailureBlock
{
    AFHTTPRequestOperation *operation;
    //TODO: walidacja parametrow
    operation = [self PUT:[NSString stringWithFormat:@"classes/%@", NSStringFromClass(className)] parameters:paramters success:theSuccedBlock failure:theFailureBlock];
    return operation;
}


- (AFHTTPRequestOperation *)DELETEHTTPRequestOperationForClass:(Class) className
                                                      objectId:(NSString*) globalId
                                                   succedBlock:(succedBlock) theSuccedBlock
                                                  failureBlock:(failureBlock) theFailureBlock
{
    AFHTTPRequestOperation *operation;
    //TODO: walidacja parametrow
    operation = [self DELETE:[NSString stringWithFormat:@"classes/%@/%@", className, globalId] parameters:nil success:theSuccedBlock failure:theFailureBlock];
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

- (NSMutableURLRequest*)POSTHTTPRequestForPhoto: (NSURL*) location
                                   imageQuality: (CGFloat) quaility
                                 localImageName: (NSString*) imageName
                                     completion: (completionBlock) theCompletionBlock
{
    NSMutableString *urlString = [NSMutableString string];
    NSString *pathString = [NSString stringWithFormat:@"files/%@",imageName];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
    assert(image);
    
    //TODO: check file size
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[location path] error:nil];
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    
    NSLog(@"Rozmia zdjecia to %lld bajtow", fileSize);
    
    [urlString appendString:self.baseURL.absoluteString];
    [urlString appendString:pathString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    [self.requestSerializer.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request addValue:obj forHTTPHeaderField:key];
    }];
    
    [request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:UIImageJPEGRepresentation(image, quaility)];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:theCompletionBlock];
    return request;
}

- (NSMutableURLRequest*) POSTHTTPRequestForFile:(NSURL*) location
                                  localFileName: (NSString*) fileName completion: (completionBlock) theCompletionBlock
{
    //TODO: implementacja
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
