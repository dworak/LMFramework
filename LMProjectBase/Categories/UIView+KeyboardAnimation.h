//
//  UIView+KeyboardAnimation.h
//  LMProjectBaseFramework
//
//  Created by Lukasz Dworakowski on 27.02.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView (KeyboardAnimation)
+ (void)animateWithKeyboardNotification:(NSNotification *)notification
                             animations:(void(^)(CGRect keyboardFrame))animations;
@end
