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
        for(NSInteger i=0;i<[content count];i++) {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:content[i][@"imagePath"] ofType:@"png"];
            UIImage *currImg = [UIImage imageWithContentsOfFile:imagePath];
            if(currImg == nil) {
                NSLog(@"Couldnt find image for path %@", imagePath);
            }
            NSDictionary *currDict = [[NSDictionary alloc] initWithObjectsAndKeys:currImg, @"image",content[i][@"text"], @"text",  nil];
            [self.featuredContent addObject:currDict];
        }
        
        //Set up the imageview
        self.contentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        self.contentImage.image = self.featuredContent[0][@"image"];
        self.contentImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.contentImage];
        
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
        
        
        
    }
    return self;
}

- (void)setCurrentFeaturedContent:(NSInteger)currFeaturedContent
{
    if(currFeaturedContent >= 0 && currFeaturedContent < [self.featuredContent count]) {
        //Set the text
        //self.contentText.text = self.featuredContent[currFeaturedContent][@"text"];
        [self setContentCaption:self.featuredContent[currFeaturedContent][@"text"]];
        //Set the image
        self.contentImage.image = self.featuredContent[currFeaturedContent][@"image"];
        self.pageControl.currentPage = currFeaturedContent;
    }
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
