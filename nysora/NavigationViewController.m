//
//  NavigationViewController.m
//  nysora
//
//  Created by Martin Greenberg on 8/15/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "NavigationViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "DrawerViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface NavigationViewController ()


@end

@implementation NavigationViewController

//This changes the status bar style
-(UIStatusBarStyle)preferredStatusBarStyle{
    if(self.mm_drawerController.showsStatusBarBackgroundView){
        return UIStatusBarStyleLightContent;
    }
    else {
        return UIStatusBarStyleDefault;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
