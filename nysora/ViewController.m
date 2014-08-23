//
//  ViewController.m
//  nysora
//
//  Created by Johan Hörnell on 8/11/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "BlockViewController.h"
#import "DrawerViewController.h"
#import "NavigationViewController.h"

#import "MMExampleDrawerVisualStateManager.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"


//Import custom table view cell
#import "NYSORABlocksTableViewCell.h"



typedef NS_ENUM(NSInteger, MMCenterViewControllerSection){
    MMCenterViewControllerSectionLeftViewState,
    MMCenterViewControllerSectionLeftDrawerAnimation,
    MMCenterViewControllerSectionRightViewState,
    MMCenterViewControllerSectionRightDrawerAnimation,
};


@interface ViewController () <UITableViewDataSource, UITableViewDelegate> //This is where we're telling the compiler that this view controller should conform to these two protocols

@property (nonatomic) NSInteger selectedRow;

@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setRestorationIdentifier:@"MMExampleCenterControllerRestorationKey"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //Some navigation bar setup
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIImage *imageForNavBar = [UIImage imageNamed:@"NYSORA_Logo_Simple"];
    UIImageView *imageViewForNavBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 120, 30)];
    imageViewForNavBar.image = imageForNavBar;
    imageViewForNavBar.contentMode = UIViewContentModeScaleAspectFit;
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 42)];
    [shadowView addSubview:imageViewForNavBar];
    self.navigationItem.titleView = shadowView;
    //Set title of the view controller
    self.title = @"NYSORA";
    
    //Initiate and allocate the table view within the bounds of the window.
    self.blocksTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, 320, self.view.frame.size.height-(200)) style:UITableViewStylePlain];
    self.blocksTableView.delegate = self;
    self.blocksTableView.dataSource = self;
    self.blocksTableView.tableHeaderView = nil;
    self.blocksTableView.tableFooterView = nil;
    
    //Add a subview
    [self.view addSubview:self.blocksTableView];

    //Set the delegate and data source for the blocksTableView
    self.blocksTableView.dataSource = self;
    self.blocksTableView.delegate = self;
    
    
    self.json = [self fetchJSONData];
    //NSLog(@"%@", self.json);
    self.arrayOfBlocks = [self.json objectForKey:@"blocks"];
    
    //Initiate and allocate the preview image
    self.featuredContentView = [[NYSORAFeaturedContentView alloc] initWithFeaturedContent:self.json[@"featuredContent"] frame:CGRectMake(0, 64, 320, 200)];
    [self.view addSubview:self.featuredContentView];
    
    //Apply the left menu button to self
    [self setupLeftMenuButton];
    

    //Set the bar color for the navigation bar
    UIColor * barColor = [UIColor
                            colorWithRed:60/255.0f
                            green:130/255.0f
                            blue:146/255.0f
                            alpha:1.0];
    [self.navigationController.navigationBar setBarTintColor:barColor];



}

//Set up animations during the different stages of the view controller
-(void)viewWillAppear:(BOOL)animated{
    self.title = @"NYSORA";
    [super viewWillAppear:animated];
//    NSLog(@"Center will appear");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"Center did appear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    NSLog(@"Center will disappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    NSLog(@"Center did disappear");
}

//Setup the left menu button
-(void)setupLeftMenuButton{
    //Create an instance of the MMDrawerBarButtonItem
    //Create an action based on when the button is pressed
    //Set the navigation item for the navigation bar to the button created
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    //Set the color of the button
    [leftDrawerButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

#pragma mark - Helper Functions

-(NSDictionary *)fetchJSONData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"content/blocks" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return json;
}

#pragma mark delegate and datasource functions

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@", [self.json[@"sections"] objectAtIndex:section]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.json[@"sections"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return the number of rows in the array that holds all the blocks
    NSInteger numOfSections = 0;
    for(NSInteger i=0;i<[self.arrayOfBlocks count];i++) {
        NSInteger sectionId = [[self.arrayOfBlocks objectAtIndex:i][@"sectionId"] integerValue];
        if(sectionId == section) {
            numOfSections++;
        }
    }
    
    return numOfSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//THE FUNCTION THAT GETS CALLED WHEN THE TABLE VIEW ASKS FOR THE CONTENT IN A SPECIFIC ROW (indexPath)

- (NYSORABlocksTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //table views are pretty weird, and a lot of this is far from intuitive. It's just the way it's designed and there's unfortunately no other way of doing it
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    NYSORABlocksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NYSORABlocksTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //Add in what information will be on each cell row. Iterate through the array of blocks
    //Figure out which row to call
    //1. get section
    NSInteger sectionId = indexPath.section;
    NSInteger rowCount = 0;
    for(NSInteger i=0;i<[self.arrayOfBlocks count];i++) {
        if([self.arrayOfBlocks[i][@"sectionId"] integerValue] == sectionId) {
            if(rowCount == indexPath.row) {
                cell.blockNameLabel.text = [self.arrayOfBlocks[i] objectForKey:@"blockName"];
                [cell setBlockThumbnailWithImagePath:[self.arrayOfBlocks[i] objectForKey:@"thumbnailPath"]];
                cell.tag = i;
            } else {
                rowCount++;
            }
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    
    //Working on manually creating the segue
    
    //To pass data between view controllers, in our case which block the user has selected
    //You instantiate an instance of the view controller in question
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    BlockViewController *bv = [storyboard instantiateViewControllerWithIdentifier:@"BlockViewController"];
    bv.whichBlockAmI = self.selectedRow + 1;
    bv.whichBlockIdAmI = self.arrayOfBlocks[[tableView cellForRowAtIndexPath:indexPath].tag][@"blockId"];
    UINavigationController *nav = (UINavigationController *)self.mm_drawerController.centerViewController;
    [nav pushViewController:bv animated:YES];
    
    //Deselect the row
    [self.blocksTableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //I set the segue identifier in the interface builder
    if ([segue.identifier isEqualToString:@"blockViewSegue"]){
        
        //To pass data between segues, in our case which block the user has selected
        //You instantiate an instance of the view controller in question
        BlockViewController *bv = [segue destinationViewController];
        
        //Then you set any property of that view controller, from within this function
        //Like so
//        NSLog(@"%d", self.selectedRow);
        
        bv.whichBlockAmI = self.selectedRow + 1; //Remember array indices start at 0
        
        //Here I am trying to get the name of the Block that was selected so that we can show it as the title on the navigation bar for the next screen. This will be passed to the next navigation controller.
        bv.whichBlockNameAmI = [self.arrayOfBlocks[bv.whichBlockAmI - 1] objectForKey:@"blockName"];
        
    }
}
*/

#pragma mark - Drawer menu functions



-(void) leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void) doubleTap:(UITapGestureRecognizer*)gesture{
    //[self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

-(void) twoFingerDoubleTap:(UITapGestureRecognizer*)gesture{
    //[self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideRight completion:nil];
}

@end
