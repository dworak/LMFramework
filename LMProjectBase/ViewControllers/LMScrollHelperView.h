//
//  LMScrollHelperView.h
//  LM
//
//  Created by Lukasz Dworakowski on 27.03.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LMScrollHelperView : UIView
@property (copy,nonatomic)  void (^passToScrollViewBlock)(UIView *view);
@end
