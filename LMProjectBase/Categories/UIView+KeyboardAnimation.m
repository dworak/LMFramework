//
//  UIView+KeyboardAnimation.m
//  LMProjectBaseFramework
//
//  Created by Lukasz Dworakowski on 27.02.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import "UIView+KeyboardAnimation.h"

@implementation UIView (KeyboardAnimation)
+ (void)animateWithKeyboardNotification:(NSNotification *)notification
                             animations:(void(^)(CGRect keyboardFrame))animations {
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        CGFloat height = CGRectGetHeight(keyboardFrame);
        keyboardFrame.size.height = CGRectGetWidth(keyboardFrame);
        keyboardFrame.size.width = height;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    animations(keyboardFrame);
    
    [UIView commitAnimations];
}

@end
