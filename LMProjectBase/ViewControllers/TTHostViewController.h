//
//  TTHostViewController.h
//  TT
//
//  Created by Andrzej Auchimowicz on 30/11/2012.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import "TTChildViewControllerProtocol.h"

#import <UIKit/UIKit.h>

@interface TTHostViewController : UIViewController

/**
    Setting both xib and storyboard properties will throw an exception on load
    attempt.
*/

/// @{

@property (strong, nonatomic) NSString* childClassName; // Child view controller class name.
@property (strong, nonatomic) NSString* childXibName; // Child view controller xib name. Setting xib name without device modifier will load ~iphone or ~ipad versions if they exist.

@property (strong, nonatomic) NSString* childStoryboardName; // Child view controller storyboard name.
@property (strong, nonatomic) NSString* childStoryboardId; // Child view controller storyboard identifier.

/// @}

@property (weak, nonatomic) IBOutlet UIView* childHostingView;

@property (readonly, strong, nonatomic) UIViewController<TTChildViewControllerProtocol>* childViewController;

+ (UIViewController*)loadViewControllerWithClass:(Class)class andXibName:(NSString*)xibName;

+ (UIViewController*)loadViewControllerWithStoryboardName:(NSString*)storyboardName andStoryboardId:(NSString*)storyboardId;

@end
