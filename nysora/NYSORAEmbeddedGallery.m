//
//  NYSORAEmbeddedGallery.m
//  nysora
//
//  Created by Johan Hörnell on 8/30/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "NYSORAEmbeddedGallery.h"

#define BUTTON_DIMENSION 30

@interface NYSORAEmbeddedGallery () {
    UISwipeGestureRecognizer *_leftGallerySwipe;
    UISwipeGestureRecognizer *_rightGallerySwipe;
    UITapGestureRecognizer *_galleryTap;

    NSInteger _currImg;
}


@end

@implementation NYSORAEmbeddedGallery

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithArrayOfImagePaths:(NSMutableArray*)imagePathArray andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        
        //Initialize the array
        self.imageArray = [[NSMutableArray alloc] init];
        //Set up the scrollview
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        for(NSInteger i=0;i<[imagePathArray count];i++) {
            NSString *processedImagePath = [imagePathArray[i] substringToIndex:[imagePathArray[i] length]-4];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:processedImagePath ofType:@"png"];
            UIImage *currImg = [UIImage imageWithContentsOfFile:imagePath];
            if(currImg == nil) {
                NSLog(@"Couldnt find image for path %@", processedImagePath);
            } else {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320*i,0,320,200)];
                imageView.image = currImg;
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [self.scrollView addSubview:imageView];
            }
        }
        _currImg = 0;
        //Initialize the imageView
        self.scrollView.contentSize = CGSizeMake(320*[imagePathArray                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   count], 200);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        
        [self addSubview:self.scrollView];
        
        //Initialize the next button
        self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nextButton addTarget:self action:@selector(nextTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.nextButton setTitle:@" " forState:UIControlStateNormal];
        self.nextButton.frame = CGRectMake(self.frame.size.width-BUTTON_DIMENSION*5/4, self.frame.size.height/2-BUTTON_DIMENSION/2, BUTTON_DIMENSION, BUTTON_DIMENSION);
        self.nextButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [self.nextButton.layer setCornerRadius:BUTTON_DIMENSION/2];
        [self.nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.nextButton.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18];
        [self.nextButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
        self.nextButton.contentEdgeInsets = UIEdgeInsetsMake(7.5f,0,5,0);
        [self addSubview:self.nextButton];
        
        //Initialize the prev button
        self.prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.prevButton addTarget:self action:@selector(prevTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.prevButton setTitle:@"" forState:UIControlStateNormal];
        self.prevButton.frame = CGRectMake(BUTTON_DIMENSION/4, self.frame.size.height/2-BUTTON_DIMENSION/2, BUTTON_DIMENSION, BUTTON_DIMENSION);
        self.prevButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [self.prevButton.layer setCornerRadius:BUTTON_DIMENSION/2];
        [self.prevButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.prevButton.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18];
        [self.prevButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
        self.prevButton.contentEdgeInsets = UIEdgeInsetsMake(7.5f,0,5,0);
        [self addSubview:self.prevButton];
        
        
        //Initialize the swipe recognizer
        /*_leftGallerySwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
        [_leftGallerySwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:_leftGallerySwipe];
        _rightGallerySwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
        [_rightGallerySwipe setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:_rightGallerySwipe];*/
        
        //Initializes the tap recongizer
        _galleryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:_galleryTap];
        
        //Initialize the page control
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
        self.pageControl.numberOfPages = ([self.imageArray count] > 0) ? [self.imageArray count] : 0;
        self.pageControl.currentPage = 0;
        self.pageControl.pageIndicatorTintColor = [UIColor
                                                   colorWithRed:255.0f
                                                   green:255.0f
                                                   blue:255.0f
                                                   alpha:0.5];
        self.pageControl.currentPageIndicatorTintColor = [UIColor
                                                          colorWithRed:255.0f
                                                          green:255.0f
                                                          blue:255.0f
                                                          alpha:1.0];
        [self addSubview:self.pageControl];
        
    }
    return self;
}

-(void)nextTouch:(UIButton *)button
{
    NSLog(@"next touch");
    if(_currImg + 1 < self.scrollView.contentSize.width/320) {
        [self goToImage:(_currImg+1)];
    }
}
-(void)prevTouch:(UIButton *)button
{
    NSLog(@"prev touch with %ld", _currImg);
    if(_currImg > 0) {
        [self goToImage:(_currImg-1)];
    }
}

-(void)leftSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if(_currImg + 1 < [self.imageArray count]) {
        [self goToImage:(_currImg+1)];
    }
}
-(void)rightSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if(_currImg > 0) {
        [self goToImage:(_currImg-1)];
    }
}

-(void)tap:(UITapGestureRecognizer *)recognizer
{
    [self.delegate userDidTapImage:_currImg];
}

-(void)goToImage:(NSInteger)whichImage
{
    _currImg = whichImage;
    self.scrollView.contentOffset = CGPointMake(320*_currImg, 0);
    self.pageControl.currentPage = _currImg;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //To get the page
    int page = scrollView.contentOffset.x/320;
    if(page >= 0 && page < self.scrollView.contentSize.width/320) {
        _currImg = page;
        self.pageControl.currentPage = page;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
