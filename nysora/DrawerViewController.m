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
#import "TextSizingViewController.h"
#import <Mixpanel/Mixpanel.h>
#import <MessageUI/MessageUI.h>



@interface DrawerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) int selectedRowDrawer;
@property(nonatomic, retain) UIColor *barTintColor;
@end

@implementation DrawerViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Initiate and allocate the header view at the top.
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 47)];
    
    //Initiate and allocate the table view about 60 pixels down.
    _tableViewDrawer = [[UITableView alloc] initWithFrame:CGRectMake(0, 47, 320, self.view.frame.size.height-(47)) style:UITableViewStylePlain];
    
    //Initiate and allocate the text sizing view at the top.
    _textSizingView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 100)];

    //Initiate and allocate the text sizing view at the top.
    _contactUsView = [[UIView alloc] initWithFrame:CGRectMake(0, 230, 320, 100)];

    
    //Set the subviews
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableViewDrawer];
    [self.view addSubview:self.textSizingView];
    [self.view addSubview:self.contactUsView];
    
    
    //Set the delegate and data source to self
    [self.tableViewDrawer setDelegate:self];
    [self.tableViewDrawer setDataSource:self];
    
    
    //Add in the block icon in the header view
    UILabel *blockIcon = [[UILabel alloc] initWithFrame:CGRectMake(16, 17, 200, 20)];
    blockIcon.text = @"\uf02d";
    blockIcon.textColor = [UIColor colorWithWhite:1 alpha:1];
    blockIcon.font = [UIFont fontWithName:@"FontAwesome" size:18];
    [self.headerView addSubview:blockIcon];
    
    
    UIButton *blockButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [blockButton addTarget:self
                         action:@selector(homeButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
    [blockButton setTitle:@"Blocks" forState:UIControlStateNormal];
    blockButton.frame = CGRectMake(-33, 17, 200, 20);
    blockButton.tintColor = [UIColor colorWithWhite:1 alpha:1];
    blockButton.font = [UIFont fontWithName:@"Avenir-Heavy" size:18];
    [self.headerView addSubview:blockButton];
    
    //Add in the text sizing icon
    UILabel *textSizingIcon = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, 20, 20)];
        textSizingIcon.text = @"\uf002";
        textSizingIcon.textColor = [UIColor colorWithWhite:1 alpha:1];
        textSizingIcon.font = [UIFont fontWithName:@"FontAwesome" size:18];
        [self.textSizingView addSubview:textSizingIcon];
    
    //Add in the text sizing button
    
       UIButton *textSizingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
       [textSizingButton addTarget:self
                 action:@selector(textSizingButtonAction:)
      forControlEvents:UIControlEventTouchUpInside];
       [textSizingButton setTitle:@"Text Size" forState:UIControlStateNormal];
       textSizingButton.frame = CGRectMake(-23.0, 6.0, 200.0, 20.0);
       textSizingButton.tintColor = [UIColor colorWithWhite:1 alpha:1];
       textSizingButton.font = [UIFont fontWithName:@"Avenir-Heavy" size:18];
       [self.textSizingView addSubview:textSizingButton];
    
    //Add in the contact us icon
    UILabel *contactUsIcon = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, 20, 20)];
    contactUsIcon.text = @"\uf0e0";
    contactUsIcon.textColor = [UIColor colorWithWhite:1 alpha:1];
    contactUsIcon.font = [UIFont fontWithName:@"FontAwesome" size:18];
    [self.contactUsView addSubview:contactUsIcon];
    
    //Add in the contact us button
    
    UIButton *contactUsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [contactUsButton addTarget:self
                         action:@selector(contactUsButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
    [contactUsButton setTitle:@"Contact Us" forState:UIControlStateNormal];
    contactUsButton.frame = CGRectMake(-13.0, 6.0, 200.0, 20.0);
    contactUsButton.tintColor = [UIColor colorWithWhite:1 alpha:1];
    contactUsButton.font = [UIFont fontWithName:@"Avenir-Heavy" size:18];
    [self.contactUsView addSubview:contactUsButton];


    
    //Add in a blue line under the "blocks" title
    UIView *blocksLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 45, 260, 1.5)];
    blocksLineView.backgroundColor =[UIColor colorWithRed:60.0/255.0
                                                    green:130.0/255.0
                                                     blue:146.0/255.0
                                                    alpha:1];
    [self.headerView addSubview:blocksLineView];
    
    //Add in a second blue line under the blocks
    UIView *blocksSecondLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 145, 260, 1.5)];
    blocksSecondLineView.backgroundColor =[UIColor colorWithRed:60.0/255.0
                                                    green:130.0/255.0
                                                     blue:146.0/255.0
                                                    alpha:1];
    [self.tableViewDrawer addSubview:blocksSecondLineView];
    
    //Load in the JSON source
    NSDictionary *json = [self fetchJSONData];
    self.arrayOfBlocksDrawer = [json objectForKey:@"blocks"];
    
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

- (void)contactUsButtonAction:(UIButton*)button
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:info@uploadapps.com"]] ];
    
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
    cell.textLabel.textColor = [UIColor colorWithRed:60.0/255.0
                                     green:130.0/255.0
                                      blue:146.0/255.0
                                     alpha:1];
    
    //Set the font size of the text in the drawer table view cell
    UIFont *textLabelFont = [UIFont fontWithName: @"Avenir-Heavy" size: 15.00 ];
    cell.textLabel.font  = textLabelFont;
    
    //Add in what information will be on each cell row. Iterate through the array of blocks
    cell.textLabel.text = [self.arrayOfBlocksDrawer[indexPath.row] objectForKey:@"blockName"];
    
    return cell;
}

    //Home button leads to ViewController
- (void)homeButtonAction:(UIButton*)button
{
    ViewController * center = [[ViewController alloc] init];
    
    UINavigationController * nav = [[NavigationViewController alloc] initWithRootViewController:center];
    
    [self.mm_drawerController
     setCenterViewController:nav
     withCloseAnimation:YES
     completion:nil];

    //Track the action in Mixpanel
    [[Mixpanel sharedInstance] track:@"Drawer Home Button Clicked"];

    
}

//Text sizing button leads to TextSizingViewController
- (void)textSizingButtonAction:(UIButton*)button
{

    //Load an instance of the text sizing view
    TextSizingViewController *textSizing = [[TextSizingViewController alloc] init];
    
    [self presentViewController:textSizing animated:YES completion:nil];
    
    //Track the action in Mixpanel
    [[Mixpanel sharedInstance] track:@"Text Sizing Home Button Clicked"];
    
    
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
    bv.whichBlockIdAmI = self.arrayOfBlocksDrawer[indexPath.row][@"blockId"];
    UINavigationController *nav = (UINavigationController *)self.mm_drawerController.centerViewController;
    [nav pushViewController:bv animated:YES];
    
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    [self.tableViewDrawer deselectRowAtIndexPath:indexPath animated:YES];
    
    //Track the action in Mixpanel
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //Here we create an instance of NSString and assign it the block name selected
    NSString *whichBlockNameAmI = self.arrayOfBlocksDrawer[indexPath.row][@"blockName"];;
    //Here we track the block name that was chosen
    [mixpanel track:@"drawer block selected" properties:@{@"block": whichBlockNameAmI}];
    
}


@end
