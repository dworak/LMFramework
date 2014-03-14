//
//  LMProjectBase.m
//  LMProjectBase
//
//  Created by Lukasz Dworakowski on 25.02.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//
//  Abstract class that needs to be overwritten.

#import "LMProjectBaseDelegate.h"
#import <UIKit/UIKit.h>

@implementation LMProjectBase

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self doesNotRecognizeSelector:_cmd];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
