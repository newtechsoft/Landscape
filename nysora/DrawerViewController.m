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

@interface DrawerViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation DrawerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

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
    
        tableViewBackgroundColor = [UIColor colorWithRed:110.0/255.0
                                                   green:113.0/255.0
                                                    blue:115.0/255.0
                                                   alpha:1.0];
   [self.tableView setBackgroundColor:tableViewBackgroundColor];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:66.0/255.0
                                                  green:69.0/255.0
                                                   blue:71.0/255.0
                                                  alpha:1.0]];
    
    UIColor * barColor = [UIColor colorWithRed:161.0/255.0
                                         green:164.0/255.0
                                          blue:166.0/255.0
                                         alpha:1.0];
    [self setTitle:@"Menu"];
}


#pragma mark - Table view data source

-(NSDictionary *)fetchJSONData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"content/blocks" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return json;
    
    // Return the number of sections.
    // return 0;
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
        
    //Add in what information will be on each cell row. Iterate through the array of blocks
    cell.textLabel.text = [self.arrayOfBlocksDrawer[indexPath.row] objectForKey:@"blockName"];
    return cell;
}


@end
