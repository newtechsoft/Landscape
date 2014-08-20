//
//  NYSORAHeadersPaginationView.m
//  nysora
//
//  Created by Johan Hörnell on 8/20/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "NYSORAHeadersPaginationView.h"

@implementation NYSORAHeadersPaginationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //Set the background color
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        
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
        //Add the view
        [self addSubview:self.pageControl];
        //Set up the label
        self.headerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 20)];
        self.headerNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.headerNameLabel];
    }
    return self;
}

- (void)setNumberOfHeaders:(NSInteger)numberOfHeaders
{
    self.pageControl.numberOfPages = numberOfHeaders;
}

- (void)setCurrentHeader:(NSInteger)currentHeader
{
    self.pageControl.currentPage = currentHeader;
}

- (void)setHeaderName:(NSString *)headerName
{
    self.headerNameLabel.text = headerName;
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
