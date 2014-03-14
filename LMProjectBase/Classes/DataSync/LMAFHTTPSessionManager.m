//
//  LMAFHTTPSessionManager.m
//  LMProject
//
//  Created by Lukasz Dworakowski on 09.03.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import "LMAFHTTPSessionManager.h"

@interface LMAFHTTPSessionManager()
@property (strong, nonatomic) NSDictionary *requestHeaders;
@end

@implementation LMAFHTTPSessionManager

static NSString * const kAPIBaseURLString = @"kAPIBaseURLString";
static NSString * const kAPIApplicationId = @"kAPIApplicationId";
static NSString * const kAPIKey = @"kAPIKey";
static NSString * const kAPIHeaders = @"kAPIHeaders";

+ (instancetype)sharedClient
{
    static LMAFHTTPSessionManager *sharedClient = nil;
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
        
        NSDictionary *headersDictionary = [settingsDictionary valueForKey:kAPIHeaders];
        
        sharedClient = [[LMAFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString] andHTTPRequestHeaders:headersDictionary];
        
        sharedClient.requestHeaders = [NSDictionary dictionaryWithDictionary:headersDictionary];
    });
    
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url andHTTPRequestHeaders: (NSDictionary*) requestHeaders
{
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


- (void) switchRequestSerializerForJSON
{
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

- (void) switchRequestSerializerForHttp
{
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



@end
