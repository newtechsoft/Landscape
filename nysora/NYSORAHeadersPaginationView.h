//
//  NYSORAHeadersPaginationView.h
//  nysora
//
//  Created by Johan Hörnell on 8/20/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYSORAHeadersPaginationView : UIView

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UILabel *headerNameLabel;
@property (strong, nonatomic) CALayer *tinyCircle;

- (void)setCurrentHeader:(NSInteger)currentHeader;
- (void)setNumberOfHeaders:(NSInteger)numberOfHeaders;
- (void)setHeaderName:(NSString *)headerName;

@end
