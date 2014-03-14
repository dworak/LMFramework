//
//  TTHostViewController.m
//  TT
//
//  Created by Andrzej Auchimowicz on 30/11/2012.
//  Copyright (c) 2012 Transition Technologies. All rights reserved.
//

#import "TTHostViewController.h"
#import "LMDeviceInfo.h"
@interface TTHostViewController ()

@end

@implementation TTHostViewController

@synthesize childViewController = _childViewController;

- (UIViewController<TTChildViewControllerProtocol>*)childViewController
{
    [self ttSetup];
    return _childViewController;
}

- (void)ttSetup
{
    if (_childViewController)
    {
        return;
    }
    
    if (self.childClassName || self.childXibName)
    {
        if (self.childStoryboardName || self.childStoryboardId)
        {
            @throw  [NSException exceptionWithName:@"Child xib and storyboard properties should not be set at the same time" reason:@"Child xib and storyboard properties should not be set at the same time" userInfo:@{@"class":[self class]}];
        }
        
        Class childClass = NSClassFromString(self.childClassName);
        assert(childClass);
        
        _childViewController = (UIViewController<TTChildViewControllerProtocol>*)[TTHostViewController loadViewControllerWithClass:childClass andXibName:self.childXibName];
        
        if (![_childViewController conformsToProtocol:@protocol(TTChildViewControllerProtocol)])
        {
            @throw  [NSException exceptionWithName:@"Child xib or class name is invalid" reason:@"Child xib or class name is invalid" userInfo:@{@"class":[self class]}];
        }
        
        [self addChildViewController:_childViewController];
    }
    
    if (self.childStoryboardName || self.childStoryboardId)
    {
        if (self.childClassName || self.childXibName)
        {
            @throw  [NSException exceptionWithName:@"Child xib and storyboard properties should not be set at the same time" reason:@"Child xib and storyboard properties should not be set at the same time" userInfo:@{@"class":[self class]}];
        }
        
        _childViewController = (UIViewController<TTChildViewControllerProtocol>*)[TTHostViewController loadViewControllerWithStoryboardName:self.childStoryboardName andStoryboardId:self.childStoryboardId];
        
        if ([_childViewController conformsToProtocol:@protocol(TTChildViewControllerProtocol)])
        {
        }
        else
        {
            @throw  [NSException exceptionWithName:@"Child storyboard id or storyboard name is invalid" reason:@"Child storyboard id or storyboard name is invalid" userInfo:@{@"class":[self class]}];
        }
        
        [self addChildViewController:_childViewController];
    }
}

+ (UIViewController*)loadViewControllerWithClass:(Class)class andXibName:(NSString*)xibName
{
    xibName = [LMDeviceInfo getFullXibNameForCurrentDevice:xibName];
    
    UIViewController* result = [[class alloc] initWithNibName:xibName bundle:[NSBundle mainBundle]];
    
    if (result && [result isKindOfClass:[UIViewController class]])
    {
    }
    else
    {
        @throw  [NSException exceptionWithName:@"Child xib or class name is invalid" reason:@"Child xib or class name is invalid" userInfo:@{@"class":[self class]}];
    }
    
    return result;
}

+ (UIViewController*)loadViewControllerWithStoryboardName:(NSString*)storyboardName andStoryboardId:(NSString*)storyboardId
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController* result = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
    
    if (result && [result isKindOfClass:[UIViewController class]])
    {
    }
    else
    {
        @throw  [NSException exceptionWithName:@"Child storyboard id or storyboard name is invalid" reason:@"Child storyboard id or storyboard name is invalid" userInfo:@{@"class":[self class]}];
    }
    
    return result;
}

//MARK Initialization

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
    }
    
    return self;
}

- (void)dealloc
{
}

- (void)loadView
{
    [super loadView];
    
    [self ttSetup];
    
    if (_childViewController)
    {
        UIView* hostingView = self.childHostingView ? self.childHostingView : self.view;
        
        CGRect frame = hostingView.bounds;
        self.childViewController.view.frame = frame;
        
        self.childViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [hostingView addSubview:_childViewController.view];
    }
}

//MARK: View events

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.childViewController respondsToSelector:@selector(parentViewWillAppear:)])
    {
        [self.childViewController parentViewWillAppear:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.childViewController respondsToSelector:@selector(parentViewDidAppear:)])
    {
        [self.childViewController parentViewDidAppear:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.childViewController respondsToSelector:@selector(parentViewWillDisappear:)])
    {
        [self.childViewController parentViewWillDisappear:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if ([self.childViewController respondsToSelector:@selector(parentViewDidDisappear:)])
    {
        [self.childViewController parentViewDidDisappear:animated];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    [self.childViewController prepareChildForSegue:segue sender:sender];
}

- (BOOL)shouldAutorotate
{
    return [self.childViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.childViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
