//
//  BlockViewController.m
//  nysora
//
//  Created by Johan Hörnell on 8/11/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "BlockViewController.h"
#import "HeaderViewController.h"
#import "NYSORAHeaderTableViewCell.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"


@interface BlockViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    CGFloat _headerImageOffset;
}

@property (strong, nonatomic) UITableView *headersTableView;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

@property (strong, nonatomic) UITextView *summaryTextView;

@property (strong, nonatomic) NSMutableArray *arrayOfHeaders;
@property (nonatomic) NSInteger selectedRow;

@end

@implementation BlockViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if(self) {
        //Custom init
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Edit the navigation back item
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //Set up the table
    self.headersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.headersTableView];
    self.headersTableView.delegate = self;
    self.headersTableView.dataSource = self;
    //self.headersTableView.opaque = NO;
    self.headersTableView.backgroundColor = [UIColor clearColor];
    
    //Set up the imageview
    self.previewImageView.backgroundColor = [UIColor grayColor];
    
    //Load in the JSON source    
    NSDictionary *json = [self fetchJSONData];
    self.arrayOfHeaders = [json objectForKey:@"headers"];
    self.whichBlockIdAmI = [json objectForKey:@"blockId"];
    self.whichBlockNameAmI = [json objectForKey:@"blockName"];
    //self.arrayOfHeaders = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
    
    //Set title in the navigation bar
    self.navigationItem.title = self.whichBlockNameAmI;
    
    //Set the summary image
    NSString* imageName = [[NSBundle mainBundle] pathForResource:[json objectForKey:@"summaryPath"] ofType:@"png"];
    self.previewImageView.image = [UIImage imageWithContentsOfFile:imageName];
    self.previewImageView.backgroundColor = [UIColor whiteColor];
    _headerImageOffset = -20.0;
    CGRect headerImageFrame = CGRectMake(0, _headerImageOffset, 320, 400);
    [self.previewImageView setFrame: headerImageFrame];
    NSLog(@"%@", NSStringFromCGRect(self.previewImageView.frame));
    if(self.previewImageView.image == nil) {
        NSLog(@"Couldnt find image at path %@", imageName);
        
    }
    
    //Set the summary
    self.summaryTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, 320, 300)];
    [self.summaryTextView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [self.summaryTextView setTextColor:[UIColor whiteColor]];
    self.summaryTextView.textContainerInset = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
    self.summaryTextView.textAlignment = NSTextAlignmentCenter;
    self.summaryTextView.editable = NO;
    [self.summaryTextView setText:[json objectForKey:@"summaryText"]];
    [self.view insertSubview: self.summaryTextView belowSubview:self.headersTableView];
    
    //Set up the transparent title
    UIView *tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 244.0)];
    self.headersTableView.tableHeaderView = tableHeaderView;
    
    //Set up the nav bar buttons
    MMDrawerBarButtonItem *rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    //Set the color of the button
    [rightDrawerButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton];
    
}

#pragma mark - Helper Functions

-(void) leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


-(NSDictionary *)fetchJSONData
{
    NSString *jsonPath = [NSString stringWithFormat:@"content/%@/%@", self.whichBlockIdAmI, self.whichBlockIdAmI];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonPath ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return json;
}

#pragma mark - Table View Delegate and Datasource

#pragma mark delegate and datasource functions

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGRect headerImageFrame = self.previewImageView.frame;
    
    if (scrollOffset < 0) {
        // Adjust image proportionally
        headerImageFrame.origin.y = -((scrollOffset / 3));
    } else {
        // We're scrolling up, return to normal behavior
        headerImageFrame.origin.y = -scrollOffset/3;
    }
    self.previewImageView.frame = headerImageFrame;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
//THE FUNCTION THAT GETS CALLED WHEN THE TABLE VIEW ASKS HOW MANY ROWS THERE SHOULD BE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayOfHeaders count];    //return the number of rows in the array that holds all the blocks
}

//THE FUNCTION THAT GETS CALLED WHEN THE TABLE VIEW ASKS FOR THE CONTENT IN A SPECIFIC ROW (indexPath)

- (NYSORAHeaderTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //table views are pretty weird, and a lot of this is far from intuitive. It's just the way it's designed and there's unfortunately no other way of doing it
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    NYSORAHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[NYSORAHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    cell.headerNameLabel.text = [NSString stringWithFormat:@"%@", [self.arrayOfHeaders[indexPath.row] objectForKey:@"headerName"] ];
    cell.headerNumberLabel.text = [NSString stringWithFormat: @"%ld", (indexPath.row + 1)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"headerViewSegue" sender:self];
    [self.headersTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //I set the segue identifier in the interface builder
    if ([segue.identifier isEqualToString:@"headerViewSegue"]){
        
        //To pass data between segues, in our case which block the user has selected
        //You instantiate an instance of the view controller in question
        HeaderViewController *hv = [segue destinationViewController];
        
        //Then you set any property of that view controller, from within this function
        //Like so
        //Pass the block Id
        hv.whichBlockAmIIn = self.whichBlockIdAmI;
        
        hv.whichBlockNameAmIIn = self.whichBlockNameAmI;
        //Pass the header number
        hv.whichHeaderAmI = self.selectedRow;
        //Pass the header name
        hv.whichHeaderNameAmI = [self.arrayOfHeaders[hv.whichHeaderAmI] objectForKey:@"headerName"];
        //Pass the total number of headers
        hv.howManyHeadersAreThere = [self.arrayOfHeaders count];
        //Pass the actual json
        hv.json = self.arrayOfHeaders;
    }
}

#pragma mark - Memory Management


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
