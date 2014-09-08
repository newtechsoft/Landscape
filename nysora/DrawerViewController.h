//
//  DrawerViewController.h
//  nysora
//
//  Created by Martin Greenberg on 8/17/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"
#import <QuartzCore/QuartzCore.h>


@interface DrawerViewController : UIViewController
@property (nonatomic, strong) NSDictionary *json;
@property (nonatomic, strong) UITableView * tableViewDrawer;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIView * textSizingView;
@property (nonatomic, strong) UIView * contactUsView;
@property (nonatomic, strong) NSMutableArray *arrayOfBlocksDrawer;
@property (strong, nonatomic) UIImageView *drawerHeader;
-(IBAction)contactUsButton:(id)sender;


@end
