//
//  COViewController.m
//  CrazyViewController
//
//  Created by Kaszuba Maciej on 10/03/14.
//  Copyright (c) 2014 Kaszuba Maciej. All rights reserved.
//

#import "LMViewControllerBase.h"

#define kLMIphoneLandscapeKeyboardOriginY 418
#define kLMIphonePortraitKeyboardOriginY 352

#define kLMIpadLanscapeKeyboardOriginY 416
#define kLMIpadPortraitKeyboardOriginY 760

#define kLMScrollBottomMargin 10

@interface LMViewControllerBase ()
@property (unsafe_unretained, nonatomic) CGRect currentKeyboardFrame;


- (void)addContentScrollView;
- (void)returnToDefaultScrollContentSize:(BOOL)defaultContent withUserInfoDictionary:(NSDictionary*) userInfo;

@end

@implementation LMViewControllerBase

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self addContentScrollView];
    
    //Add keyboard notifications
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //Only when we instantiate, not sublcass, demo
    if([self isMemberOfClass:[LMViewControllerBase class]])
    {
        UITextField *testTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
        testTextField.backgroundColor = [UIColor greenColor];
        [self addContentSubview:testTextField];
        
        testTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height-350, 100, 30)];
        testTextField.backgroundColor = [UIColor greenColor];
        [self addContentSubview:testTextField];
        
        testTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height-250, 100, 30)];
        testTextField.backgroundColor = [UIColor greenColor];
        [self addContentSubview:testTextField];
        
        testTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height-150, 100, 30)];
        testTextField.backgroundColor = [UIColor greenColor];
        [self addContentSubview:testTextField];
        
        testTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height-30, 100, 30)];
        testTextField.backgroundColor = [UIColor greenColor];
        [self addContentSubview:testTextField];
        
        UIButton *resignButton = [[UIButton alloc] initWithFrame:CGRectMake(210, 100, 50, 50)];
        resignButton.backgroundColor = [UIColor greenColor];
        [resignButton addTarget:self action:@selector(resignBtnOn:) forControlEvents:UIControlEventTouchUpInside];
        [self addContentSubview:resignButton];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    NSLog(@"viewDidLayoutSubviews %@", NSStringFromCGRect(self.currentEditingTextField.frame));
}

#pragma mark -
#pragma mark === IBAction methods ===
- (IBAction)resignBtnOn:(id)sender {
    if(self.currentEditingTextField) {
        [self.currentEditingTextField resignFirstResponder];
    }
}

- (IBAction)textFieldChange:(id)sender {
    if([sender isKindOfClass:[UITextField class]]) {
        self.currentEditingTextField = (UITextField *)sender;
        [self scrollToCurrentTextField];
    }
}

#pragma mark -
#pragma mark === KeyboardNotifications ===
- (void)onKeyboardHide:(NSNotification *)notification {
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
    [self returnToDefaultScrollContentSize:YES withUserInfoDictionary:notification.userInfo];
}

- (void)onKeyboardFrameChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *keyboardBoundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    self.currentKeyboardFrame = [self.view convertRect:[keyboardBoundsValue CGRectValue] fromView:nil];
    if(self.currentKeyboardFrame.origin.y < self.view.bounds.size.height) {
        [self returnToDefaultScrollContentSize:NO withUserInfoDictionary:notification.userInfo];
    } else {
        [self returnToDefaultScrollContentSize:YES withUserInfoDictionary:notification.userInfo];
    }
}

#pragma mark -
#pragma mark === public methods ===
- (void)addContentSubview:(UIView *)v {
    if([v isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)v;
        [textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingDidBegin];
    }
    
    [self.contentScrollView addSubview:v];
}

#pragma mark -
#pragma mark === private methods ===
- (void)returnToDefaultScrollContentSize:(BOOL)defaultContent withUserInfoDictionary:(NSDictionary*) userInfo{
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions options = (curve << 16) | UIViewAnimationOptionBeginFromCurrentState;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if(!userInfo) {
        curve = -1;
        options = -1;
        duration = -1;
    }
    __weak LMViewControllerBase *weakSelf = self;
    if(defaultContent) {
        [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
            [weakSelf.contentScrollView setContentOffset:CGPointMake(0, 0)];
            weakSelf.contentScrollView.contentSize = CGSizeMake(weakSelf.view.bounds.size.width, weakSelf.view.bounds.size.height);
            weakSelf.contentScrollView.scrollEnabled = NO;
        } completion:nil];
    } else {
        [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
            weakSelf.contentScrollView.contentSize = CGSizeMake(weakSelf.view.bounds.size.width, weakSelf.view.bounds.size.height + weakSelf.currentKeyboardFrame.size.height + kLMScrollBottomMargin);
            weakSelf.contentScrollView.scrollEnabled = YES;
            [weakSelf scrollToCurrentTextField];
        } completion:nil];
    }
}

- (void)scrollToCurrentTextField {
    if(self.currentEditingTextField && self.currentKeyboardFrame.origin.y > 0) {
        float posY = floorf(self.currentEditingTextField.frame.origin.y+self.currentEditingTextField.frame.size.height+10);
        if(posY > self.currentKeyboardFrame.origin.y-self.currentKeyboardFrame.size.height) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.contentOffset.x, posY - self.currentKeyboardFrame.origin.y)];
            } completion:^(BOOL finished) {
            }];
        }
    }
}

- (void)addContentScrollView {
    _contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    [self returnToDefaultScrollContentSize:YES withUserInfoDictionary:nil];
    
    [self.view addSubview:self.contentScrollView];
    
    [self.contentScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.contentScrollView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeWidth
                                 multiplier:1
                                   constant:0]];
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.contentScrollView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeHeight
                                 multiplier:1
                                   constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contentScrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contentScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
}

- (void)setBouncesPropertyForRootView: (BOOL) bounces
{
    _contentScrollView.bounces = bounces;
}

-(void)shakeAnimation:(NSArray*) views
{
    const int reset = 5;
    const int maxShakes = 6;
    
    static int shakes = 0;
    static int translate = reset;
    
    [UIView animateWithDuration:0.09-(shakes*.01)
                          delay:0.01f
                        options:(enum UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                     animations:^{
                         for(UIView *v in views)
                         {
                             v.transform = CGAffineTransformMakeTranslation(translate, 0);
                         }
                     }
                     completion:^(BOOL finished){
                         if(shakes < maxShakes)
                         {
                             shakes++;
                             
                             if (translate>0)
                             {
                                 translate--;
                             }
                             translate*=-1;
                             [self shakeAnimation:views];
                             
                         }
                         else
                         {
                             for(UIView *v in views)
                             {
                                 v.transform = CGAffineTransformIdentity;
                             }
                             shakes = 0;
                             translate = reset;
                             return;
                         }
                     }
     ];
}

@end
