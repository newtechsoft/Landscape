//
//  DrawerViewController.h
//  nysora
//
//  Created by Martin Greenberg on 8/17/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"


@interface DrawerViewController : UITableViewController
@property (nonatomic, strong) NSDictionary *json;
@property (nonatomic, strong) UITableView * tableViewDrawer;
@property (nonatomic, strong) NSMutableArray *arrayOfBlocksDrawer;
@property (strong, nonatomic) UIImageView *drawerHeader;


@end
