//
//  TTChildViewControllerProtocol.h
//  TT
//
//  Created by Andrzej Auchimowicz on 30/11/2012.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

@class UIStoryboardSegue;

@protocol TTChildViewControllerProtocol <NSObject>

- (void)prepareChildForSegue:(UIStoryboardSegue*)segue sender:(id)sender;

@optional

- (void)parentViewWillAppear:(BOOL)animated;
- (void)parentViewWillDisappear:(BOOL)animated;

- (void)parentViewDidAppear:(BOOL)animated;
- (void)parentViewDidDisappear:(BOOL)animated;

@end
