//
//  LMScrollHelperView.m
//  LM
//
//  Created by Lukasz Dworakowski on 27.03.2014.
//  Copyright (c) 2014 Lukasz Dworakowski. All rights reserved.
//

#import "LMScrollHelperView.h"

@implementation LMScrollHelperView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) addSubview:(UIView *)view{
    if(self.passToScrollViewBlock)
    {
        self.passToScrollViewBlock(view);
    }
}

@end
