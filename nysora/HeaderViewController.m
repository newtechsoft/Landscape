//
//  HeaderViewController.m
//  nysora
//
//  Created by Johan Hörnell on 8/12/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "HeaderViewController.h"
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
    
    NSLog(@"%d", self.whichHeaderAmI);
    
    //Init the json string
    NSLog(@"%@", self.json);
    NSError *error = nil;
    
    //Load the template
    NSString *templateString = [self fetchTemplateData];
    
    //Process the template
    NSString *htmlOutput = [GRMustacheTemplate renderObject:self.json fromString:templateString error:&error];
    NSLog(@"%@", htmlOutput);
    //Show it in the webview
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:bundlePath];
    
    [self.headerWebView loadHTMLString:htmlOutput baseURL:baseURL];
}

#pragma mark - Helper functions

-(NSString *)fetchTemplateData
{
    NSLog(@"%@", self.json);
    NSString *path = [NSString stringWithFormat:@"content/%@/%@", self.whichBlockAmIIn, [self.json objectForKey:@"htmlFile"]];
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
