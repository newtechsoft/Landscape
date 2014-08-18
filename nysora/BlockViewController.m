//
//  BlockViewController.m
//  nysora
//
//  Created by Johan Hörnell on 8/11/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "BlockViewController.h"
#import "HeaderViewController.h"

@interface BlockViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *headersTableView;

@property (strong, nonatomic) NSMutableArray *arrayOfHeaders;
@property (nonatomic) int selectedRow;

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
        NSLog(@"hej");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.headersTableView.delegate = self;
    self.headersTableView.dataSource = self;
    
    //Load in the JSON source    
    NSDictionary *json = [self fetchJSONData];
    self.arrayOfHeaders = [json objectForKey:@"headers"];
    self.whichBlockIdAmI = [json objectForKey:@"blockId"];
    //self.arrayOfHeaders = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
    
    //Set title in the navigation bar
    self.navigationItem.title = self.whichBlockNameAmI;
    
}

#pragma mark - Helper Functions

-(NSDictionary *)fetchJSONData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"content/29/29" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return json;
}

#pragma mark - Table View Delegate and Datasource

#pragma mark delegate and datasource functions

//THE FUNCTION THAT GETS CALLED WHEN THE TABLE VIEW ASKS HOW MANY ROWS THERE SHOULD BE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayOfHeaders count];    //return the number of rows in the array that holds all the blocks
}

//THE FUNCTION THAT GETS CALLED WHEN THE TABLE VIEW ASKS FOR THE CONTENT IN A SPECIFIC ROW (indexPath)

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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.arrayOfHeaders[indexPath.row] objectForKey:@"headerName"] ];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"headerViewSegue" sender:self];
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
        //Pass the header number
        hv.whichHeaderAmI = self.selectedRow;
        //Pass the header name
        hv.whichHeaderNameAmI = [self.arrayOfHeaders[hv.whichHeaderAmI] objectForKey:@"headerName"];
        //Pass the actual json
        hv.json = self.arrayOfHeaders[self.selectedRow];
    }
}

#pragma mark - Memory Management


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
