//
//  LMAFHTTPSessionManager.h
//  LMProject
//
//  Created by Lukasz Dworakowski on 09.03.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface LMAFHTTPSessionManager : AFHTTPSessionManager
+ (instancetype)sharedClient;
- (void) switchRequestSerializerForJSON;
- (void) switchRequestSerializerForHttp;
@end
