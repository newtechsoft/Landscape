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
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "NYSORAEmbeddedGallery.h"
#import "NYSORAEmbeddedGalleryProtocol.h"
#import "NYSORAGalleryViewController.h"

#define GALLERY_HEIGHT 200
#define BUTTON_DIMENSION 30
#define BOTTOM_BUTTONS_MARGIN 35
#define PRIMARY_COLOR [UIColor colorWithRed:60/255.0f green:130/255.0f blue:146/255.0f alpha:1.0]

@interface HeaderViewController () <UIScrollViewDelegate, UIWebViewDelegate, NYSORAEmbeddedGalleryProtocol>

@property (strong, nonatomic) UIWebView *headerWebView;
@property (strong, nonatomic) UIScrollView *containerScrollView;
@property (strong, nonatomic) NYSORAEmbeddedGallery *gallery;
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
    // Set up the scroll view, web view and gallery view
    //Scrollview
    self.containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 92, self.view.frame.size.width, self.view.frame.size.height-92)];
    self.containerScrollView.delegate = self;
    //WebView
    self.headerWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ([self.containerScrollView.subviews containsObject: self.gallery])?200:0, 320, 568)];
    self.headerWebView.scrollView.scrollEnabled = NO;
    self.headerWebView.delegate = self;
    [self.containerScrollView addSubview:self.headerWebView];
    
    [self renderWebView];
    
    [self setUpHelperViews];
    
    

}

-(void)setUpGalleryView
{
    if([self.containerScrollView.subviews containsObject: self.gallery]) {
        [self.gallery removeFromSuperview];
        self.gallery = nil;
    }
    //Gallery view
    NSMutableArray *imagePathsArray = [self generateImageArray];
    if([imagePathsArray count] > 0) {
        self.gallery = [[NYSORAEmbeddedGallery alloc] initWithArrayOfImagePaths:imagePathsArray andFrame:CGRectMake(0, 0, 320, GALLERY_HEIGHT)];
        self.gallery.backgroundColor = [UIColor blackColor];
        self.gallery.delegate = self;
        [self.containerScrollView addSubview:self.gallery];
        [self.view addSubview:self.containerScrollView];
        self.containerScrollView.contentSize = CGSizeMake(320, GALLERY_HEIGHT);
    }
}

-(void)setUpHelperViews
{
    NSLog(@"setting up helper views");
    //Add the pagination
    self.paginationView = [[NYSORAHeadersPaginationView alloc] initWithFrame:CGRectMake(0, 64, 320, 28)];
    [self.paginationView setNumberOfHeaders:[self.json count]];
    [self.paginationView setCurrentHeader:self.whichHeaderAmI];
    [self.paginationView setHeaderName:self.json[self.whichHeaderAmI][@"headerName"]];
    [self.view addSubview:self.paginationView];
    
    //Add the page control
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
    //Set the tint color
    self.pageControl.pageIndicatorTintColor = [UIColor
                                               colorWithRed:60/255.0f
                                               green:130/255.0f
                                               blue:146/255.0f
                                               alpha:0.5];
    self.pageControl.currentPageIndicatorTintColor = [UIColor
                                                      colorWithRed:60/255.0f
                                                      green:130/255.0f
                                                      blue:146/255.0f
                                                      alpha:1.0];
    self.pageControl.numberOfPages = [self.json count];
    self.pageControl.currentPage = self.whichHeaderAmI;
    //Add the view
    [self.containerScrollView addSubview:self.pageControl];
    
    //Set up the swipe recognizers
    self.rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerRight:)];
    [self.rightSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.headerWebView addGestureRecognizer:self.rightSwipeRecognizer];
    self.leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerLeft:)];
    [self.leftSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.headerWebView addGestureRecognizer:self.leftSwipeRecognizer];
    [self.headerWebView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.rightSwipeRecognizer];
    [self.headerWebView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.leftSwipeRecognizer];

    
    //Set title in the navigation bar
    self.navigationItem.title = self.whichBlockNameAmIIn;
    
    //Set up the nav bar buttons
    MMDrawerBarButtonItem *rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    //Set the color of the button
    [rightDrawerButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton];
    
    //Set up the bottom arrows
    //Previous header button
    self.prevHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.prevHeaderButton addTarget:self action:@selector(prevTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.prevHeaderButton setTitle:@"" forState:UIControlStateNormal];
    //self.prevHeaderButton.frame = CGRectMake(BUTTON_DIMENSION/4, self.view.frame.size.height/2-BUTTON_DIMENSION/2, BUTTON_DIMENSION, BUTTON_DIMENSION);
    self.prevHeaderButton.backgroundColor = PRIMARY_COLOR;
    [self.prevHeaderButton.layer setCornerRadius:BUTTON_DIMENSION/2];
    [self.prevHeaderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.prevHeaderButton.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18];
    [self.prevHeaderButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
    self.prevHeaderButton.contentEdgeInsets = UIEdgeInsetsMake(7.5f,0,5,0);
    [self.containerScrollView addSubview:self.prevHeaderButton];
    //Next header button
    self.nextHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextHeaderButton addTarget:self action:@selector(nextTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextHeaderButton setTitle:@" " forState:UIControlStateNormal];
    //self.nextHeaderButton.frame = CGRectMake(BUTTON_DIMENSION/4, self.view.frame.size.height/2-BUTTON_DIMENSION/2, BUTTON_DIMENSION, BUTTON_DIMENSION);
    self.nextHeaderButton.backgroundColor = PRIMARY_COLOR;
    [self.nextHeaderButton.layer setCornerRadius:BUTTON_DIMENSION/2];
    [self.nextHeaderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextHeaderButton.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18];
    [self.nextHeaderButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
    self.nextHeaderButton.contentEdgeInsets = UIEdgeInsetsMake(7.5f,0,5,0);
    [self.containerScrollView addSubview:self.nextHeaderButton];

}

-(void)nextTouch:(UIButton *)button
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
        self.pageControl.currentPage = self.whichHeaderAmI;
    }
}
-(void)prevTouch:(UIButton *)button
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
        self.pageControl.currentPage = self.whichHeaderAmI;

    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *URL = [request URL];
    if ([[URL scheme] isEqualToString:@"nysora"]) {
        // parse the rest of the URL object and execute functions
        if([[URL host] isEqualToString:@"gallery"]) {
            //Get the image src
            NSArray *params = [[URL absoluteString] componentsSeparatedByString:@"?"];
            NSString *imageName = [params lastObject];
            NSInteger imageNumber = [self identifyImageNumberFromName:imageName];
            
            [self userDidTapImage:imageNumber];
        }
        return NO;
    }
    
    return YES;
}

- (NSInteger)identifyImageNumberFromName:(NSString*)imageName
{
    NSArray *comparisonArray = [self generateImageArray];
    for(NSInteger i=0;i<[comparisonArray count];i++) {
        if([(NSString*)comparisonArray[i] rangeOfString:imageName].location != NSNotFound) {
            return i;
        }
    }
    return 0;
}

- (void) webViewDidFinishLoad:(UIWebView *)webview
{
    //Evaluate the height
    //NSLog(@"jquery says: %@", [self.headerWebView stringByEvaluatingJavaScriptFromString:@"$(document).height()"]);
    int h = [[self.headerWebView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
    
    //Scroll to top
    [self.containerScrollView setContentOffset:CGPointMake(0, 0)];
    //Print it to the console
    //NSLog(@"js says: %d", h);
    //Set the height of the webview
    CGRect newFrame = self.headerWebView.frame;
    newFrame.size.height = h;
    newFrame.origin.y = ([self.containerScrollView.subviews containsObject: self.gallery])?200:0;
    [self.headerWebView setFrame:newFrame];
    //Set the height of the scrollview

    self.containerScrollView.contentSize = CGSizeMake(self.view.frame.size.width, (GALLERY_HEIGHT + BOTTOM_BUTTONS_MARGIN*2 + BUTTON_DIMENSION + h));
    //Move the buttons to the bottom
    self.prevHeaderButton.frame = CGRectMake(20, GALLERY_HEIGHT + h + BOTTOM_BUTTONS_MARGIN, BUTTON_DIMENSION, BUTTON_DIMENSION);
    //Move the buttons to the bottom
    self.nextHeaderButton.frame = CGRectMake(self.view.frame.size.width-20-BUTTON_DIMENSION, GALLERY_HEIGHT + h + BOTTOM_BUTTONS_MARGIN, BUTTON_DIMENSION, BUTTON_DIMENSION);
    self.pageControl.frame = CGRectMake(0, GALLERY_HEIGHT + h + BOTTOM_BUTTONS_MARGIN, self.view.frame.size.width, 30);

    //Pull in the global text size from the user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.globalTextSize = [defaults objectForKey:@"textSizeKey"];
    NSLog(@"global text size: %@",self.globalTextSize);
    
    //Check to see what size the font is in the web view and input the global text size
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@%%'",                            self.globalTextSize];
    
    [self.headerWebView stringByEvaluatingJavaScriptFromString:jsString];
}

-(void)userDidTapImage:(NSInteger)imageNumber
{
    //Load an instance of the gallery
    NYSORAGalleryViewController *gallery = [[NYSORAGalleryViewController alloc] init];
    //Set the image paths array
    gallery.imagePathsArray = [self generateImageArray];
    //Set the captions
    gallery.rawCaptionsArray = [self generateCaptionArray];
    gallery.initialImage = imageNumber;
    [self presentViewController:gallery animated:YES completion:nil];
}

- (NSMutableArray*)generateImageArray
{
    NSMutableArray *imagePathsArray = [[NSMutableArray alloc] init];
    for(id key in self.json[self.whichHeaderAmI][@"imgs"]) {
        [imagePathsArray addObject:[self.json[self.whichHeaderAmI][@"imgs"] objectForKey: key][@"src"]];
    }
    return imagePathsArray;
}

- (NSMutableArray*)generateCaptionArray
{
    NSMutableArray *captionArray = [[NSMutableArray alloc] init];
    for(id key in self.json[self.whichHeaderAmI][@"imgs"]) {
        [captionArray addObject:[self.json[self.whichHeaderAmI][@"imgs"] objectForKey: key][@"alt"]];
    }
    return captionArray;
}

-(void) leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)renderWebView
{
    [self setUpGalleryView];
    //set the height to 1 in order to force a redraw
    CGRect newFrame = self.headerWebView.frame;
    newFrame.size.height = 1;
    [self.headerWebView setFrame:newFrame];

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

@end
