//
//  HeaderViewController.m
//  nysora
//
//  Created by Johan Hörnell on 8/12/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "HeaderViewController.h"
#import "NYSORAHeaderTableViewCell.h"
#import <GRMustache.h>

@interface HeaderViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *headerWebView;

@end

@implementation HeaderViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    [self renderWebView];
    
    [self setUpHelperViews];
    
}

-(void)setUpHelperViews
{
    //Add the pagination
    self.paginationView = [[NYSORAHeadersPaginationView alloc] initWithFrame:CGRectMake(0, 64, 320, 40)];
    [self.paginationView setNumberOfHeaders:self.howManyHeadersAreThere];
    [self.paginationView setCurrentHeader:self.whichHeaderAmI];
    [self.paginationView setHeaderName:self.whichHeaderNameAmI];
    [self.view addSubview:self.paginationView];
    
    //Set up the swipe recognizers
    self.rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerRight:)];
    [self.rightSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:self.rightSwipeRecognizer];
    self.leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerLeft:)];
    [self.leftSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:self.leftSwipeRecognizer];
    
    //Set title in the navigation bar
    self.navigationItem.title = self.whichBlockNameAmIIn;
}

-(void)renderWebView
{
    NSError *error = nil;
    
    //Load the template
    NSString *templateString = [self fetchTemplateData];
    
    //Process the template
    NSString *htmlOutput = [GRMustacheTemplate renderObject:self.json[self.whichHeaderAmI] fromString:templateString error:&error];
    //NSLog(@"%@", htmlOutput);
    //Show it in the webview
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:bundlePath];
    
    [self.headerWebView loadHTMLString:htmlOutput baseURL:baseURL];
    
}

#pragma mark - Helper functions

-(void)swipeHandlerRight:(UISwipeGestureRecognizer *)recognizer
{
    //We should go back one header
    if(self.whichHeaderAmI > 0) {
        //Decrease the counter
        self.whichHeaderAmI--;
        //Set the new name
        self.whichHeaderNameAmI = [self.json[self.whichHeaderAmI] objectForKey:@"headerName"];
        //Update the view
        [self renderWebView];
        //Change the pagination
        [self.paginationView setCurrentHeader:self.whichHeaderAmI];
        [self.paginationView setHeaderName:self.whichHeaderNameAmI];
    }
}

-(void)swipeHandlerLeft:(UISwipeGestureRecognizer *)recognizer
{
    //We should go forward one header
    if(self.whichHeaderAmI < ([self.json count] - 1)) {
        //Increase the counter
        self.whichHeaderAmI++;
        //Set the new name
        self.whichHeaderNameAmI = [self.json[self.whichHeaderAmI] objectForKey:@"headerName"];
        //Update the view
        [self renderWebView];
        //Change the pagination
        [self.paginationView setCurrentHeader:self.whichHeaderAmI];
        [self.paginationView setHeaderName:self.whichHeaderNameAmI];
    }
}

-(NSString *)fetchTemplateData
{
    NSString *path = [NSString stringWithFormat:@"content/%@/%@", self.whichBlockAmIIn, [self.json[self.whichHeaderAmI] objectForKey:@"htmlFile"]];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:path ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return htmlString;
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
