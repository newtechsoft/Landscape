//
//  NYSORAFeaturedContentView.h
//  nysora
//
//  Created by Johan Hörnell on 8/23/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYSORAFeaturedContentView : UIView

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *contentImage;
@property (nonatomic, strong) UITextView *contentText;
@property (nonatomic, strong) UIView *contentTextBackground;
@property (nonatomic, strong) NSMutableArray *featuredContent;

- (id)initWithFeaturedContent:(NSMutableArray *)content frame:(CGRect)frame;

- (void)setCurrentFeaturedContent:(NSInteger)currFeaturedContent;

@end
