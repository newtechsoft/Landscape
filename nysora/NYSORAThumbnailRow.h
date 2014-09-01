//
//  NYSORAThumbnailRow.h
//  nysora
//
//  Created by Johan Hörnell on 8/31/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYSORAThumbnailRowProtocol.h"

@interface NYSORAThumbnailRow : UIScrollView

@property (strong, nonatomic) NSMutableArray *imageViewsArray;
@property (weak, nonatomic) id <NYSORAThumbnailRowProtocol> delegate;


-(id)initWithArrayOfImagePaths:(NSMutableArray *)imagePathsArray andFrame:(CGRect)frame andInitialImage:(NSInteger)initialImage;
-(void)setSelectedImage:(NSInteger)imageNumber isFirstCall:(BOOL)firstCall withCallback:(BOOL)callback;

@end
