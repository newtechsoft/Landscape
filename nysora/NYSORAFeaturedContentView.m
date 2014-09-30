//
//  NYSORAFeaturedContentView.m
//  nysora
//
//  Created by Johan Hörnell on 8/23/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "NYSORAFeaturedContentView.h"

@implementation NYSORAFeaturedContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFeaturedContent:(NSMutableArray *)content frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        //Load the content
        self.featuredContent = [[NSMutableArray alloc] init];
        self.imageViews = [[NSMutableArray alloc] init];
        //Set up the scrollview
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        for(NSInteger i=0;i<[content count];i++) {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:content[i][@"imagePath"] ofType:@"png"];
            UIImage *currImg = [UIImage imageWithContentsOfFile:imagePath];
            if(currImg == nil) {
                NSLog(@"Couldnt find image for path %@", imagePath);
            }
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320*i,0,320,200)];
            imageView.image = currImg;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.scrollView addSubview:imageView];
            NSDictionary *currDict = [[NSDictionary alloc] initWithObjectsAndKeys:currImg, @"image",content[i][@"text"], @"text",  nil];
            [self.featuredContent addObject:currDict];
        }
        
        self.scrollView.contentSize = CGSizeMake(320*[self.featuredContent count], 200);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        
        [self addSubview:self.scrollView];
        
        //Set up the text view
        self.contentText = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, 30)];
        self.contentText.backgroundColor = [UIColor clearColor];
        self.contentText.editable = NO;
        self.contentText.textColor = [UIColor whiteColor];
        self.contentText.textAlignment = NSTextAlignmentCenter;
        self.contentTextBackground = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        self.contentTextBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.contentTextBackground addSubview:self.contentText];
        [self addSubview:self.contentTextBackground];
        [self setContentCaption:self.featuredContent[0][@"text"]];
        
        
        //Set up the page control
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 180, 320, 20)];
        self.pageControl.numberOfPages = [self.featuredContent count];
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
        
        [self setTimerForFeaturedContent];
        
    }
    return self;
}

- (void)setTimerForFeaturedContent
{
    self.featuredContentTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(rotateFeaturedContent)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)rotateFeaturedContent
{
    //1. which page should we go to
    int currentPage = self.scrollView.contentOffset.x/320;
    if((currentPage+1) < [self.featuredContent count]) {
        self.scrollView.contentOffset = CGPointMake((currentPage+1)*320, 0);
        [self setContentCaption:self.featuredContent[currentPage][@"text"]];
        self.pageControl.currentPage = currentPage+1;
    } else {
        //Go back to zero
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self setContentCaption:self.featuredContent[0][@"text"]];
        self.pageControl.currentPage = 0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    //To get the page
    int page = scrollView.contentOffset.x/320;
    if(page >= 0 && page < [self.featuredContent count]) {
        [self setContentCaption:self.featuredContent[page][@"text"]];
        self.pageControl.currentPage = page;
    }
}

- (void)setCurrentFeaturedContent:(NSInteger)currFeaturedContent
{
    /*if(currFeaturedContent >= 0 && currFeaturedContent < [self.featuredContent count]) {
        //Set the text
        //self.contentText.text = self.featuredContent[currFeaturedContent][@"text"];
        [self setContentCaption:self.featuredContent[currFeaturedContent][@"text"]];
        //Set the image
        self.scrollView.contentOffset = CGPointMake(320*currFeaturedContent, 0);
        self.pageControl.currentPage = currFeaturedContent;
    }*/
}

- (void)setContentCaption:(NSString*)text
{
    self.contentText.text = text;
    CGFloat fixedWidth = self.contentText.frame.size.width;
    CGSize newSize = [self.contentText sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.contentText.frame;
    newFrame.size = CGSizeMake(fixedWidth, newSize.height);
    newFrame.origin.y = 0;
    newFrame.origin.x = 5;
    self.contentText.frame = newFrame;
    CGRect backgroundFrame = newFrame;
    backgroundFrame.origin.x = 0;
    backgroundFrame.origin.y = self.frame.size.height - newFrame.size.height - 20;
    backgroundFrame.size = CGSizeMake(self.frame.size.width, newFrame.size.height + 20);
    self.contentTextBackground.frame = backgroundFrame;
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
