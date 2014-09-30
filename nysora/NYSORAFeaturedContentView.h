//
//  NYSORAFeaturedContentView.h
//  nysora
//
//  Created by Johan Hörnell on 8/23/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYSORAFeaturedContentView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) UIImageView *contentImage;
@property (nonatomic, strong) UITextView *contentText;
@property (nonatomic, strong) UIView *contentTextBackground;
@property (nonatomic, strong) NSMutableArray *featuredContent;
@property (nonatomic, strong) NSTimer *featuredContentTimer;

- (id)initWithFeaturedContent:(NSMutableArray *)content frame:(CGRect)frame;

- (void)setCurrentFeaturedContent:(NSInteger)currFeaturedContent;

@end
