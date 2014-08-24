//
//  DrawerViewController.m
//  nysora
//
//  Created by Martin Greenberg on 8/17/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "ViewController.h"
#import "DrawerViewController.h"
#import "MMTableViewCell.h"
#import "MMSideDrawerTableViewCell.h"
#import "NavigationViewController.h"
#import "BlockViewController.h"

@interface DrawerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) int selectedRowDrawer;
@property(nonatomic, retain) UIColor *barTintColor;
@end

@implementation DrawerViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Initiate and allocate the header view at the top.
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 87)];
    
    //Initiate and allocate the table view about 60 pixels down.
    _tableViewDrawer = [[UITableView alloc] initWithFrame:CGRectMake(0, 87, 320, self.view.frame.size.height-(87)) style:UITableViewStylePlain];
    
    //Set the subview for the table view
    [self.view addSubview:self.tableViewDrawer];
    
    //Set the subview for the header view
    [self.view addSubview:self.headerView];
    
    //Set the delegate and data source to self
    [self.tableViewDrawer setDelegate:self];
    [self.tableViewDrawer setDataSource:self];
    
    //Add in the home icon in the header view
    UILabel *homeIcon = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, 20, 20)];
    homeIcon.text = @"\uf02e";
    homeIcon.textColor = [UIColor colorWithWhite:1 alpha:1];
    homeIcon.font = [UIFont fontWithName:@"FontAwesome" size:18];
    [self.headerView addSubview:homeIcon];
    
    //Add in the home button in the header view
  
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [homeButton addTarget:self
               action:@selector(homeButtonAction:)
    forControlEvents:UIControlEventTouchUpInside];
    [homeButton setTitle:@"Home" forState:UIControlStateNormal];
    homeButton.frame = CGRectMake(-33.0, 16.0, 200.0, 20.0);
    homeButton.tintColor = [UIColor colorWithWhite:1 alpha:1];
    homeButton.font = [UIFont fontWithName:@"Avenir-Heavy" size:18];
    [self.headerView addSubview:homeButton];
    
    //Add in the block icon in the header view
    UILabel *blockIcon = [[UILabel alloc] initWithFrame:CGRectMake(16, 57, 200, 20)];
    blockIcon.text = @"\uf02d";
    blockIcon.textColor = [UIColor colorWithWhite:1 alpha:1];
    blockIcon.font = [UIFont fontWithName:@"FontAwesome" size:18];
    [self.headerView addSubview:blockIcon];
    
    //Add in the block title in the header view
    UILabel *blockText = [[UILabel alloc] initWithFrame:CGRectMake(40, 57, 200, 20)];
    blockText.text = @"Blocks";
    blockText.textColor = [UIColor colorWithWhite:1 alpha:1];
    blockText.font = [UIFont fontWithName:@"Avenir-Heavy" size:18];
    [self.headerView addSubview:blockText];
    
    
    
    //Add in a black line under the "home" title
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 46, 320, .5)];
    lineView.backgroundColor =[UIColor colorWithWhite:0 alpha:1];
    [self.headerView addSubview:lineView];
    
    //Add in a blue line under the "blocks" title
    UIView *blocksLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 85, 260, 1.5)];
    blocksLineView.backgroundColor =[UIColor colorWithRed:60.0/255.0
                                                    green:130.0/255.0
                                                     blue:146.0/255.0
                                                    alpha:1];
    [self.headerView addSubview:blocksLineView];
    
    //Load in the JSON source
    NSDictionary *json = [self fetchJSONData];
    //    NSLog(@"%@", self.json);
    self.arrayOfBlocksDrawer = [json objectForKey:@"blocks"];
    NSLog(@"%@", self.arrayOfBlocksDrawer );
    
    //Set the background color for the table view
    UIColor * tableViewBackgroundColor;
    
    tableViewBackgroundColor = [UIColor colorWithRed:55.0/255.0
                                               green:54.0/255.0
                                                blue:54.0/255.0
                                               alpha:1.0];
    [self.tableViewDrawer setBackgroundColor:tableViewBackgroundColor];
    
    //Set the background color for the header view
    UIColor * headerViewBackgroundColor;
    
    headerViewBackgroundColor = [UIColor colorWithRed:55.0/255.0
                                                green:54.0/255.0
                                                 blue:54.0/255.0
                                                alpha:1.0];
    [self.headerView setBackgroundColor:tableViewBackgroundColor];
    
    
    
    // This will remove extra separators at the bottom of the table view
    self.tableViewDrawer.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //This gets rid of the separators alltogether
    [self.tableViewDrawer setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //This will change the color of the separators in the table view
    [self.tableViewDrawer setSeparatorColor:[UIColor colorWithRed:60.0/255.0
                                                            green:130.0/255.0
                                                             blue:146.0/255.0
                                                            alpha:1]];
    
    //This will get rid of scrolling in the table view
    //    self.tableView.scrollEnabled = NO;
    
    //Set the nysora logo in the title slot
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];// Here you can set View width and height as per your requirement for displaying titleImageView position in navigationbar
    [backView setBackgroundColor:[UIColor colorWithRed:55.0/255.0
                                                 green:54.0/255.0
                                                  blue:54.0/255.0
                                                 alpha:1.0]];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NYSORA_Logo_Simple"]];
    
    [backView addSubview:titleImageView];
    self.navigationItem.titleView = backView;
    
    //Based on the iOS version - set the tint color of the nav bar
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:55/255.0
                                                                            green:54.0/255.0
                                                                             blue:54.0/255.0
                                                                            alpha:1];
    } else {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:55/255.0
                                                                               green:54.0/255.0
                                                                                blue:54.0/255.0
                                                                               alpha:1];
        self.navigationController.navigationBar.translucent = NO;
    }
    
    //Set the title of the navigation bar
    [self setTitle:@"Blocks"];
    
}


#pragma mark - Table view data source

-(NSDictionary *)fetchJSONData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"content/blocks" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return json;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.arrayOfBlocksDrawer count];
    //    NSLog(@"This is to check the number of blocks being counted: %@", self.arrayOfBlocksDrawer);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //table views are pretty weird, and a lot of this is far from intuitive. It's just the way it's designed and there's unfortunately no other way of doing it
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    //Set the background color of the cell in the drawer table view
    cell.backgroundColor = [UIColor colorWithRed:55/255.0
                                           green:54.0/255.0
                                            blue:54.0/255.0
                                           alpha:1];
    
    //Set the color of the text in the drawer table view cell
    cell.textColor = [UIColor colorWithRed:60.0/255.0
                                     green:130.0/255.0
                                      blue:146.0/255.0
                                     alpha:1];
    
    //Set the font size of the text in the drawer table view cell
    UIFont *textLabelFont = [UIFont fontWithName: @"Avenir-Heavy" size: 15.00 ];
    cell.textLabel.font  = textLabelFont;
    
    //NSArray* fontNames = [UIFont fontNamesForFamilyName:@"Avenir"];
    /*for( NSString* aFontName in fontNames ) {
     NSLog( @"Font name: %@", aFontName );
     }*/
    
    //Add in what information will be on each cell row. Iterate through the array of blocks
    cell.textLabel.text = [self.arrayOfBlocksDrawer[indexPath.row] objectForKey:@"blockName"];
    
    
    return cell;
}

    //Home Button leads to ViewController
- (void)homeButtonAction:(UIButton*)button
{
    //Checking to see if the button was clicked
//    NSLog(@"Button  clicked.");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    //popToRootViewControllerAnimated
    
    //Create an instance of ViewController
    ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    UINavigationController *nav = (UINavigationController *)self.mm_drawerController.centerViewController;
    [nav pushViewController:viewController animated:YES];
    
    //Here we tell the Drawer View Controller to push the center view controller to the navigation controller
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRowDrawer = indexPath.row;
    
    //To pass data between view controllers, in our case which block the user has selected
    //You instantiate an instance of the view controller in question
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    BlockViewController *bv = [storyboard instantiateViewControllerWithIdentifier:@"BlockViewController"];
    
    //    Here we pass the BlockViewController its specific row
    bv.whichBlockAmI = self.selectedRowDrawer + 1;
    //    NSLog(@"%d", self.selectedRow);
    UINavigationController *nav = (UINavigationController *)self.mm_drawerController.centerViewController;
    [nav pushViewController:bv animated:YES];
    
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    
}




@end
