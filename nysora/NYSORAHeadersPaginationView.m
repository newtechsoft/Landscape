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
        
        //Set up the label
        self.headerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 320, 20)];
        self.headerNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.headerNameLabel setFont:[UIFont systemFontOfSize:14]];
        self.headerNameLabel.numberOfLines = 1;
        [self addSubview:self.headerNameLabel];
        
        //Add the circle
        [self addCircle];

    }
    return self;
}

- (void)addCircle
{
    //Set up the mini super small tiny circle
    //Such tiny much small. WOW
    _tinyCircle = [[CALayer alloc] init];
    _tinyCircle.frame = CGRectMake(0, 0, 16, 16);
    _tinyCircle.borderWidth = 2;
    _tinyCircle.borderColor = [UIColor
                                   colorWithRed:60/255.0f
                                   green:130/255.0f
                                   blue:146/255.0f
                                   alpha:1.0].CGColor;
    [_tinyCircle setCornerRadius:8.0f];
    _tinyCircle.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1].CGColor;
    [self.layer addSublayer:_tinyCircle];
}


- (void)moveCircle
{
    CGRect newFrame = CGRectMake(self.headerNameLabel.frame.origin.x-22, 5, 16, 16);
    [self.tinyCircle setFrame:newFrame];
    [self drawCircleNumber];
}

- (void)drawCircleNumber
{
    [self.tinyCircle.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    CATextLayer *label = [[CATextLayer alloc] init];
    [label setFont:@"Helvetica-Bold"];
    [label setFontSize:11];
    [label setFrame:CGRectMake(0, 1, 16, 16)];
    [label setString:[NSString stringWithFormat:@"%ld", (self.currentPage+1)]];
    [label setAlignmentMode:kCAAlignmentCenter];
    [label setForegroundColor:[[UIColor colorWithRed:60/255.0f
                                               green:130/255.0f
                                                blue:146/255.0f
                                               alpha:1.0] CGColor]];
    [self.tinyCircle addSublayer:label];
}

- (void)setNumberOfHeaders:(NSInteger)numberOfHeaders
{
    self.numberOfPages = numberOfHeaders;
}

- (void)setCurrentHeader:(NSInteger)currentHeader
{
    self.currentPage = currentHeader;
}

- (void)setHeaderName:(NSString *)headerName
{
    self.headerNameLabel.text = headerName;
    [self.headerNameLabel sizeToFit];
    //Move the label to the middle + 10 px for the circle
    CGRect newFrame = CGRectMake(self.frame.size.width/2 - self.headerNameLabel.frame.size.width/2 + 11, 3, self.headerNameLabel.frame.size.width, 20);
    [self.headerNameLabel setFrame:newFrame];
    [self moveCircle];
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
