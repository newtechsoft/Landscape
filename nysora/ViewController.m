//
//  ViewController.m
//  nysora
//
//  Created by Johan Hörnell on 8/11/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "ViewController.h"
#import "BlockViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> //This is where we're telling the compiler that this view controller should conform to these two protocols

@property (nonatomic, strong) NSMutableArray *arrayOfBlocks;
@property (nonatomic) int selectedRow;

@property (weak, nonatomic) IBOutlet UITableView *blocksTableView;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Set the delegate and data source for the blocksTableView
    self.blocksTableView.dataSource = self;
    self.blocksTableView.delegate = self;
    
    //This is the array that holds all the blocks
    //In the app, rather than simple strings, each of these items should be an instance of the block class
    //Kind of like this = [NSMutableArray arrayWithObjects: [Block createBlockFromFile:blockName1], [Block createBlockFromFile:blockName2], nil]
    self.json = [self fetchJSONData];
    NSLog(@"%@", self.json);
    self.arrayOfBlocks = [self.json objectForKey:@"blocks"]; //[NSMutableArray arrayWithObjects:@"block1", @"block2", @"block3", @"block4", nil];
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

//THE FUNCTION THAT GETS CALLED WHEN THE TABLE VIEW ASKS HOW MANY ROWS THERE SHOULD BE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayOfBlocks count];    //return the number of rows in the array that holds all the blocks
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
    cell.textLabel.text = [self.arrayOfBlocks[indexPath.row] objectForKey:@"blockName"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"blockViewSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //I set the segue identifier in the interface builder
    if ([segue.identifier isEqualToString:@"blockViewSegue"]){
        
        //To pass data between segues, in our case which block the user has selected
        //You instantiate an instance of the view controller in question
        BlockViewController *bv = [segue destinationViewController];
        
        //Then you set any property of that view controller, from within this function
        //Like so
        NSLog(@"%d", self.selectedRow);
        
        bv.whichBlockAmI = self.selectedRow + 1; //Remember array indices start at 0
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
