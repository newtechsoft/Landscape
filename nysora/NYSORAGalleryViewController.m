//
//  NYSORAGalleryViewController.m
//  nysora
//
//  Created by Johan Hörnell on 8/31/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "NYSORAGalleryViewController.h"

@interface NYSORAGalleryViewController () {
    NSInteger _currImg;
    BOOL _captionIsOut;
}

@end

@implementation NYSORAGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    //Set the background color
    self.view.backgroundColor = [UIColor blackColor];
    
    //Set the currImg to zero
    _currImg = self.initialImage || 0;
    
    //Set up the close button
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton addTarget:self action:@selector(closeGallery:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setTitle:@"" forState:UIControlStateNormal];
    self.closeButton.frame = CGRectMake(0, 0, 40, 40);
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18];
    [self.view addSubview:self.closeButton];
    
    //Set up the image views
    self.captionsArray = [[NSMutableArray alloc] init];
    self.imageViewsArray = [self initializeImageViews:_imagePathsArray];
    //Set the frame for the first image
    [self setStackingOrder:_currImg isFirstCall:YES];
    
    //Set up the thumbnail row
    self.thumbnailRow = [[NYSORAThumbnailRow alloc] initWithArrayOfImagePaths:_imagePathsArray andFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60) andInitialImage:_currImg];
    self.thumbnailRow.delegate = self;
    [self.view addSubview:self.thumbnailRow];
    
    //Set up the gesture recongizers
    _leftGallerySwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    [_leftGallerySwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:_leftGallerySwipe];
    _rightGallerySwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    [_rightGallerySwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:_rightGallerySwipe];
    
    //Set up the caption
    _captionIsOut = YES;
    //Set up the background view
    self.captionBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-100, 320, 40)];
    _captionBackgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    self.captionTextView = [[UITextView alloc] init];
    self.captionTextView.backgroundColor = [UIColor clearColor];
    self.captionTextView.textColor = [UIColor whiteColor];
    self.captionTextView.editable = NO;
    self.captionTextView.selectable = NO;
    self.captionTextView.frame = CGRectMake(5,5,self.captionBackgroundView.frame.size.width - 10, self.captionBackgroundView.frame.size.height - 10);
    [self.captionBackgroundView addSubview:self.captionTextView];
    [self setCaption:_currImg];
    self.toggleCaption = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCaption:)];
    [self.captionBackgroundView addGestureRecognizer:self.toggleCaption];
    [self.view addSubview:self.captionBackgroundView];

}

-(void)toggleCaption:(UITapGestureRecognizer*)toggle
{
    if(_captionIsOut) {
        //Hide caption
        self.captionTextView.text = @"Show caption";
        CGFloat fixedWidth = self.captionTextView.frame.size.width;
        CGSize newSize = [self.captionTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = self.captionTextView.frame;
        newFrame.size = CGSizeMake(fixedWidth, newSize.height);
        newFrame.origin.y = 5;
        newFrame.origin.x = 5;
        self.captionTextView.frame = newFrame;
        CGRect backgroundFrame = newFrame;
        backgroundFrame.origin.x = 0;
        backgroundFrame.origin.y = self.view.frame.size.height - 60 - newFrame.size.height - 10;
        backgroundFrame.size = CGSizeMake(self.view.frame.size.width, newFrame.size.height + 10);
        self.captionBackgroundView.frame = backgroundFrame;
    } else {
        [self setCaption:_currImg];
    }
    _captionIsOut = !_captionIsOut;
}

-(void)setCaption:(NSInteger)captionNumber
{
    self.captionTextView.text = self.captionsArray[captionNumber];
    CGFloat fixedWidth = self.captionTextView.frame.size.width;
    CGSize newSize = [self.captionTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.captionTextView.frame;
    newFrame.size = CGSizeMake(fixedWidth, newSize.height);
    newFrame.origin.y = 5;
    newFrame.origin.x = 5;
    self.captionTextView.frame = newFrame;
    CGRect backgroundFrame = newFrame;
    backgroundFrame.origin.x = 0;
    backgroundFrame.origin.y = self.view.frame.size.height - 60 - newFrame.size.height - 10;
    backgroundFrame.size = CGSizeMake(self.view.frame.size.width, newFrame.size.height + 10);
    self.captionBackgroundView.frame = backgroundFrame;
}

-(void)userDidTapImage:(NSInteger)imageNumber
{
    //NSLog(@"user tapped image %ld", imageNumber);
    [self setStackingOrder:imageNumber isFirstCall:NO];
}

-(void)rightSwipe:(UISwipeGestureRecognizer*)recognizer
{
    if(_currImg > 0) {
        [self setStackingOrder:_currImg-1 isFirstCall:NO];
    }
}

-(void)leftSwipe:(UISwipeGestureRecognizer*)recognizer
{
    if(_currImg + 1 < [self.imageViewsArray count]) {
        [self setStackingOrder:_currImg+1 isFirstCall:NO];
    }
}

-(void)setStackingOrder:(NSInteger)topmostImage isFirstCall:(BOOL)firstCall
{
    if(firstCall) {
        [self.imageViewsArray[_currImg] setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:self.imageViewsArray[_currImg]];
    } else {
        [self.imageViewsArray[_currImg] removeFromSuperview];
        [self.imageViewsArray[topmostImage] setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view insertSubview:self.imageViewsArray[topmostImage] belowSubview:self.captionBackgroundView];
        _currImg = topmostImage;
    }
    [self.thumbnailRow setSelectedImage:_currImg isFirstCall:NO withCallback:NO];
    [self setCaption:_currImg];
}

-(NSMutableArray*)initializeImageViews:(NSMutableArray*)imagePathsArray
{
    NSMutableArray *imageViewsArray = [[NSMutableArray alloc] init];
    for(NSInteger i=0;i<[imagePathsArray count];i++) {
        NSString *processedImagePath = [imagePathsArray[i] substringToIndex:[imagePathsArray[i] length]-4];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:processedImagePath ofType:@"png"];
        UIImage *currImg = [UIImage imageWithContentsOfFile:imagePath];
        if(currImg == nil) {
            NSLog(@"Couldnt find image for path %@", processedImagePath);
            
        } else {
            UIImageView *currImageView = [[UIImageView alloc] initWithImage:currImg];
            currImageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageViewsArray addObject:currImageView];
            [self.captionsArray addObject:self.rawCaptionsArray[i]];
            
        }
    }
    
    return imageViewsArray;
}

-(void)closeGallery:(UIButton*)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
