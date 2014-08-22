//
//  AppDelegate.m
//  nysora
//
//  Created by Johan Hörnell on 8/11/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "ViewController.h"
#import "DrawerViewController.h"
#import "MMDrawerVisualState.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "NavigationViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface AppDelegate ()
@property (nonatomic,strong) MMDrawerController *drawerController;

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    //Allocate and initiate the drawer, center view and navigation controller
    UIViewController *leftSideDrawerViewController = [[DrawerViewController alloc] init];
    
    UIViewController *centerViewController = [[ViewController alloc] init];
    
    UINavigationController *navigationController = [[NavigationViewController alloc] initWithRootViewController:centerViewController];
    //Sets the restoration ID so the user can close the app and still come back to the same area when they reopen it
    [navigationController setRestorationIdentifier:@"CenterNavigationControllerRestorationKey"];
    
    //If the version of OS is at least iOS7
//    if(OSVersionIsAtLeastiOS7()){
        UINavigationController * leftSideNavController = [[NavigationViewController alloc] initWithRootViewController:leftSideDrawerViewController];
		[leftSideNavController setRestorationIdentifier:@"LeftNavigationControllerRestorationKey"];

        //Allocate and initiate the drawerController (a property of MMDrawer) with the view controller we allocated and initialized earlier
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:navigationController
                                 leftDrawerViewController:leftSideNavController
                                 ];
        [self.drawerController setShowsShadow:NO];
//    }
//    else{
//        self.drawerController = [[MMDrawerController alloc]
//                                 initWithCenterViewController:navigationController
//                                 leftDrawerViewController:leftSideDrawerViewController
//                                 ];
//    }
//    [self.drawerController setRestorationIdentifier:@"MMDrawer"];

    //Set the Maximum Drawer Width
//    [self.drawerController setMaximumRightDrawerWidth:200.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeTapCenterView|MMCloseDrawerGestureModeTapNavigationBar];
    
    
    //I have no idea what this means
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    //This is important - here we set the root view controller to the drawer
    [self.window setRootViewController:self.drawerController];
    
    //Set navigation controller title
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Here we set the logic for the restoration identifier path
//Depending on which key has been kept we will return the view associated with that key
- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    NSString * key = [identifierComponents lastObject];
    if([key isEqualToString:@"MMDrawer"]){
        return self.window.rootViewController;
    }
    else if ([key isEqualToString:@"MMExampleCenterNavigationControllerRestorationKey"]) {
        return ((MMDrawerController *)self.window.rootViewController).centerViewController;
    }
    else if ([key isEqualToString:@"MMExampleRightNavigationControllerRestorationKey"]) {
        return ((MMDrawerController *)self.window.rootViewController).rightDrawerViewController;
    }
    else if ([key isEqualToString:@"MMExampleLeftNavigationControllerRestorationKey"]) {
        return ((MMDrawerController *)self.window.rootViewController).leftDrawerViewController;
    }
    else if ([key isEqualToString:@"MMExampleLeftSideDrawerController"]){
        UIViewController * leftVC = ((MMDrawerController *)self.window.rootViewController).leftDrawerViewController;
        if([leftVC isKindOfClass:[UINavigationController class]]){
            return [(UINavigationController*)leftVC topViewController];
        }
        else {
            return leftVC;
        }
        
    }
    else if ([key isEqualToString:@"MMExampleRightSideDrawerController"]){
        UIViewController * rightVC = ((MMDrawerController *)self.window.rootViewController).rightDrawerViewController;
        if([rightVC isKindOfClass:[UINavigationController class]]){
            return [(UINavigationController*)rightVC topViewController];
        }
        else {
            return rightVC;
        }
    }
    return nil;
}


@end
