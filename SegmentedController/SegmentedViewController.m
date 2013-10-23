//
//  SegmentedViewController.m
//  SegmentedController
//
//  Created by Peter Stajger on 23/10/13.
//  Copyright (c) 2013 Tankista. All rights reserved.
//

#import "SegmentedViewController.h"

@interface SegmentedViewController ()

@end

@implementation SegmentedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITableViewController *firstController = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstControllerId"];
    UITableViewController *secondController = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondControllerId"];
    
    [self setViewControllers:@[firstController, secondController]];
}


@end
