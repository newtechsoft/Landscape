//
//  NYSORAGalleryViewController.h
//  nysora
//
//  Created by Johan Hörnell on 8/31/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYSORAThumbnailRow.h"
#import "NYSORAThumbnailRowProtocol.h"

@interface NYSORAGalleryViewController : UIViewController <NYSORAThumbnailRowProtocol>

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSMutableArray *imageViewsArray;
@property (nonatomic, strong) NSMutableArray *imagePathsArray;
@property (nonatomic, strong) NSMutableArray *rawCaptionsArray;
@property (nonatomic, strong) NSMutableArray *captionsArray;
@property (nonatomic, strong) NYSORAThumbnailRow *thumbnailRow;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftGallerySwipe;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightGallerySwipe;
@property (nonatomic, strong) UITapGestureRecognizer *toggleCaption;
@property (nonatomic, strong) UITextView *captionTextView;
@property (nonatomic, strong) UIView *captionBackgroundView;
@property (nonatomic, strong) UIScrollView *panAndZoomView;
@property (nonatomic) NSInteger initialImage;


@end
