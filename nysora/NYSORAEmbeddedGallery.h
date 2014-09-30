//
//  NYSORAEmbeddedGallery.h
//  nysora
//
//  Created by Johan Hörnell on 8/30/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYSORAEmbeddedGalleryProtocol.h"

@interface NYSORAEmbeddedGallery : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) UIImageView *galleryView;
@property (strong, nonatomic) UIButton *prevButton;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (weak, nonatomic) id <NYSORAEmbeddedGalleryProtocol> delegate;

-(void)leftSwipe:(UISwipeGestureRecognizer *)recognizer;
-(void)rightSwipe:(UISwipeGestureRecognizer *)recognizer;
-(void)tap:(UITapGestureRecognizer *)recognizer;

- (id)initWithArrayOfImagePaths:(NSMutableArray*)imagePathArray andFrame:(CGRect)frame;

@end
