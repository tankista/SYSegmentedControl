//
//  SYSegmentedViewController.h
//  SSCore
//
//  Created by Peter Stajger on 1/10/13.
//  Copyright (c) 2013 Synopsi.tv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYSegmentedViewControllerProtocol <NSObject>

- (NSString*)segmentTitle;

@optional
- (void)rightBarButtonTapped:(id)sender;
- (void)leftBarButtonTapped:(id)sender;

@end

@interface SYSegmentedViewController : UIViewController

@property (nonatomic, readonly) NSArray* viewControllers;
@property (nonatomic, readonly) UIViewController <SYSegmentedViewControllerProtocol>* selectedViewController;
@property (nonatomic, weak) IBOutlet UISegmentedControl* segmentedControl;

/**
 * Sets content inset of child view controllers whose root view is subclass of UIScrollView. Content inset is
 * computed by container view controllers topLayoutGuide and bottomLayoutGuide.
 *
 * @note For correct use, set automaticallyAdjustsScrollViewInsets NO.
 *
 * Default value is NO.
 */
@property (nonatomic, assign) BOOL automaticallyAdjustContentInset;

- (void)setViewControllers:(NSArray*)viewControllers;
- (void)setViewControllers:(NSArray*)viewControllers selectedIndex:(NSUInteger)index;


/**
 * View of corresponding view controller will be added as subview to view returned from this method.
 *
 * You can override this method and return desired view that should be used as the container view. 
 * Default implementation returns self.view.
 *
 * @return Container view for segment's controller view
 */
- (UIView*)segmentContainerView;

/**
 * Prepare segment view right before it's added as subview of segment container view. 
 *
 * You should override this method in order to configure view right before it's added to container view. You
 * can set for example frame, scroll position, background color etc. This method is called before viewWillAppearAnimated:
 * is called.
 * Default implementation sets segment container's bounds.
 *
 * @param view This view should be prepared
 * @param controller The view is root view from this controller.
 */
- (void)prepareSegmentView:(UIView*)view fromController:(UIViewController <SYSegmentedViewControllerProtocol>*)controller;

/**
 * This method is called right before *view* is added as a subview to segmentContainerView.
 *
 * @param view This view will be added to container view.
 * @param controller The view is root view from this controller.
 */
- (void)willAddSegmentView:(UIView *)view fromController:(UIViewController <SYSegmentedViewControllerProtocol>*)controller;

/**
 * This method is called right after *view* is added as subview of segment container view.
 *
 * @param view This view was be added to container view.
 * @param controller The view is root view from this controller.
 */
- (void)didAddSegmentView:(UIView*)view fromController:(UIViewController <SYSegmentedViewControllerProtocol>*)controller;

/**
 * Call this method if you set new view controller using convenient methods after view will appear already called. This will
 * call apperiance methods on selected view controller.
 */
- (void)updateSelectedViewController:(BOOL)animated;

@end
