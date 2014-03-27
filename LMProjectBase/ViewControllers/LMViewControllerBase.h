//
//  COViewController.h
//  CrazyViewController
//
//  Created by Kaszuba Maciej on 10/03/14.
//  Copyright (c) 2014 Kaszuba Maciej. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMViewControllerBase : UIViewController
// Add subview to content scroll view
- (void)addContentSubview:(UIView *)v;
@property (strong, nonatomic, readonly) UIScrollView *contentScrollView;
@end
