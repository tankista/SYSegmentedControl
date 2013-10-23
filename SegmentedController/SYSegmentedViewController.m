//
//  SYSegmentedViewController.m
//  SSCore
//
//  Created by Peter Stajger on 1/10/13.
//  Copyright (c) 2013 Synopsi.tv. All rights reserved.
//

#import "SYSegmentedViewController.h"

@interface SYSegmentedViewController ()

@end

@implementation SYSegmentedViewController
{
    NSUInteger  _defaultSelectedIndex;
}

@synthesize viewControllers = _viewControllers;
@synthesize selectedViewController = _selectedViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.segmentedControl addTarget:self
                              action:@selector(segmentedControlValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateSelectedViewController:animated];
}

- (void)updateSelectedViewController:(BOOL)animated
{
    if (self.segmentedControl.selectedSegmentIndex == UISegmentedControlNoSegment) {
        //display default controller
        if ([[self childViewControllers] count] >= _defaultSelectedIndex) {
            [self.segmentedControl setSelectedSegmentIndex:_defaultSelectedIndex];
            UIViewController<SYSegmentedViewControllerProtocol> *selectedViewController = [[self childViewControllers] objectAtIndex:_defaultSelectedIndex];
            [self displayContentViewController:selectedViewController endApperianceTransition:NO];
        }
    }
    else {
        [self.selectedViewController beginAppearanceTransition:YES animated:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.selectedViewController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition:NO animated:animated];    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];    
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

#pragma mark
#pragma mrak Public Methods

- (void)setViewControllers:(NSArray*)viewControllers
{
    [self setViewControllers:viewControllers selectedIndex:0];
}

- (void)setViewControllers:(NSArray*)viewControllers selectedIndex:(NSUInteger)index
{
    _defaultSelectedIndex = index;
    
    //remove old childs if present
    NSArray *currentChilds = [self childViewControllers];
    for (UIViewController* child in currentChilds) {
        [self removeContentViewController:child];
    }
    [self.segmentedControl removeAllSegments];
    
    //add new childs
    for (UIViewController<SYSegmentedViewControllerProtocol>* child in viewControllers) {
        [self addContentViewController:child];
    }
    
    NSEnumerator *reverseEnum = [[self childViewControllers] reverseObjectEnumerator];
    for (UIViewController <SYSegmentedViewControllerProtocol> *contentController in reverseEnum) {
        NSString *segmentTitle = nil;
#ifdef DEBUG
        segmentTitle = NSStringFromClass([contentController class]);
        if ([contentController respondsToSelector:@selector(segmentTitle)]) {
            segmentTitle = [contentController segmentTitle];
        }
#else
        segmentTitle = [contentController segmentTitle];
#endif

        [self.segmentedControl insertSegmentWithTitle:segmentTitle atIndex:0 animated:NO];
    }
}

- (NSArray*)viewControllers
{
    return [self childViewControllers];
}

- (UIViewController<SYSegmentedViewControllerProtocol>*)selectedViewController
{
    return _selectedViewController;
}

- (UIView*)segmentContainerView
{
    return self.view;
}



- (void)prepareSegmentView:(UIView *)view fromController:(UIViewController <SYSegmentedViewControllerProtocol>*)controller
{
    view.frame = [[self segmentContainerView] bounds];
}


- (void)willAddSegmentView:(UIView *)view fromController:(UIViewController <SYSegmentedViewControllerProtocol>*)controller
{

}


- (void)didAddSegmentView:(UIView *)view fromController:(UIViewController <SYSegmentedViewControllerProtocol>*)controller
{

}

//- (void)viewWillLayoutSubviews
//{
//    if (self.automaticallyAdjustContentInset) {
//        for (UIViewController *child in [self childViewControllers]) {
//            if ([child.view isKindOfClass:[UIScrollView class]]) {
//                UIScrollView *scrollView = (UIScrollView*)child.view;
//                UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
//                [scrollView setContentInset:contentInsets];
//                [scrollView setScrollIndicatorInsets:contentInsets];
//            }
//        }
//    }
//}

#pragma mark
#pragma mark Private Methods

- (void)removeContentViewController:(UIViewController*)controller
{
    [controller willMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

- (void)addContentViewController:(UIViewController*)controller
{
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    NSUInteger selectedSegmentIndex = sender.selectedSegmentIndex;
    UIViewController<SYSegmentedViewControllerProtocol> *selectingChildViewController = [[self childViewControllers] objectAtIndex:selectedSegmentIndex];
    [self displayContentViewController:selectingChildViewController endApperianceTransition:YES];
}

- (void)displayContentViewController:(UIViewController<SYSegmentedViewControllerProtocol>*)controller endApperianceTransition:(BOOL)endTransition
{
    UIViewController<SYSegmentedViewControllerProtocol> *selectedViewController = [self selectedViewController];
    UIViewController<SYSegmentedViewControllerProtocol> *selectingViewController = controller;
    
    if (selectedViewController) {
        [selectedViewController beginAppearanceTransition:NO animated:NO];
        selectedViewController.view.hidden = YES;
        [selectedViewController endAppearanceTransition];
    }
    
    [self prepareSegmentView:selectingViewController.view fromController:selectingViewController];
    [self willAddSegmentView:selectingViewController.view fromController:selectingViewController];
    [selectingViewController beginAppearanceTransition:YES animated:NO];
    
    if ([selectingViewController.view isDescendantOfView:[self segmentContainerView]] == NO) {
        [[self segmentContainerView] addSubview:selectingViewController.view];
    }
    selectingViewController.view.hidden = NO;

    if (endTransition) {
        [selectingViewController endAppearanceTransition];
    }
    
    _selectedViewController = selectingViewController;
    [self didAddSegmentView:selectingViewController.view fromController:selectingViewController];
}



@end
