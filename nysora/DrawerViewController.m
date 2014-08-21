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
    
    
    //Initiate and allocate the table view within the bounds of the window.
    _tableViewDrawer = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    //Set the delegate and data source to self
    [self.tableViewDrawer setDelegate:self];
    [self.tableViewDrawer setDataSource:self];
    
    //Set a subview
    [self.view addSubview:self.tableViewDrawer];
    
    //Load in the JSON source
    NSDictionary *json = [self fetchJSONData];
    //    NSLog(@"%@", self.json);
    self.arrayOfBlocksDrawer = [json objectForKey:@"blocks"];
    NSLog(@"%@", self.arrayOfBlocksDrawer );
    
    //Set the background color
    UIColor * tableViewBackgroundColor;
    
    tableViewBackgroundColor = [UIColor colorWithRed:55.0/255.0
                                               green:54.0/255.0
                                                blue:54.0/255.0
                                               alpha:1.0];
    [self.tableViewDrawer setBackgroundColor:tableViewBackgroundColor];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    
    //Set the nysora logo in the title slot
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];// Here you can set View width and height as per your requirement for displaying titleImageView position in navigationbar
    [backView setBackgroundColor:[UIColor colorWithRed:55.0/255.0
                                                 green:54.0/255.0
                                                  blue:54.0/255.0
                                                 alpha:1.0]];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NYSORA_Logo_Simple"]];
    
    //    titleImageView.frame.size.width, titleImageView.frame.size.height
    //titleImageView.frame = CGRectMake(7, -2, 180,70);
    [backView addSubview:titleImageView];
    //titleImageView.contentMode = UIViewContentModeCenter;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRowDrawer = indexPath.row;
    
    //To pass data between view controllers, in our case which block the user has selected
    //You instantiate an instance of the view controller in question
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    BlockViewController *bv = [storyboard instantiateViewControllerWithIdentifier:@"BlockViewController"];
    
    //Here we pass the BlockViewController its specific row
    bv.whichBlockAmI = self.selectedRowDrawer + 1;
    //    NSLog(@"%d", self.selectedRow);
    UINavigationController *nav = (UINavigationController *)self.mm_drawerController.centerViewController;
    [nav pushViewController:bv animated:YES];
    
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    
}




@end
