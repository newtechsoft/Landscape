//
//  NYSORAThumbnailRow.m
//  nysora
//
//  Created by Johan Hörnell on 8/31/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "NYSORAThumbnailRow.h"

#define IMG_DIMENSIONS 40
#define kBorderWidth 3.0f

@interface NYSORAThumbnailRow () {
    NSInteger _selectedImage;
}

@end

@implementation NYSORAThumbnailRow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(id)initWithArrayOfImagePaths:(NSMutableArray *)imagePathsArray andFrame:(CGRect)frame andInitialImage:(NSInteger)initialImage
{
    self = [super initWithFrame:frame];
    if(self) {
        //Set the background color
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        //Set up the images
        self.imageViewsArray = [[NSMutableArray alloc] init];
        for(NSInteger i=0;i<[imagePathsArray count];i++) {
            NSString *processedImagePath = [imagePathsArray[i] substringToIndex:[imagePathsArray[i] length]-4];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:processedImagePath ofType:@"png"];
            UIImage *currImg = [UIImage imageWithContentsOfFile:imagePath];
            if(currImg == nil) {
                NSLog(@"Couldnt find image for path %@", processedImagePath);
            } else {
                /*UIImageView *imageView = [[UIImageView alloc] initWithImage:currImg];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.frame = CGRectMake(0,0,IMG_DIMENSIONS, IMG_DIMENSIONS);
                imageView.clipsToBounds = YES;*/
                UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [imageButton addTarget:self action:@selector(userTappedThumbnail:) forControlEvents:UIControlEventTouchUpInside];
                [imageButton setImage:currImg forState:UIControlStateNormal];
                imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageButton.imageView.clipsToBounds = YES;
                imageButton.frame = CGRectMake(10+(10+IMG_DIMENSIONS)*i, 10, IMG_DIMENSIONS, IMG_DIMENSIONS);
                imageButton.tag = [self.imageViewsArray count];
                [self.imageViewsArray addObject:imageButton];
                [self addSubview:self.imageViewsArray[[self.imageViewsArray count] - 1]];
                
            }
        }
        //Set the content size
        self.contentSize = CGSizeMake(20+IMG_DIMENSIONS*[self.imageViewsArray count], 60);
        
        //Set the selected image
        [self setSelectedImage:initialImage isFirstCall:YES withCallback:NO];
    }
    return self;
}

-(void)userTappedThumbnail:(UIButton *)button
{
    //NSLog(@"user tapped button number %ld", button.tag);
    [self setSelectedImage:button.tag isFirstCall:NO withCallback:YES];
}

-(void)setSelectedImage:(NSInteger)imageNumber isFirstCall:(BOOL)firstCall withCallback:(BOOL)callback
{
    if (!firstCall) {
        //This is not the first call to this function, we have old borders to "remove" (ie set their widths to zero)
        [[(UIButton *)[self.imageViewsArray objectAtIndex:_selectedImage] layer] setBorderWidth:0];
    }
    _selectedImage = imageNumber;

    //Add the new border
    [[(UIButton *)[self.imageViewsArray objectAtIndex:imageNumber] layer] setBorderWidth:kBorderWidth];
    [[(UIButton *)[self.imageViewsArray objectAtIndex:imageNumber] layer] setBorderColor:[UIColor
                                                                                             colorWithRed:60/255.0f
                                                                                             green:130/255.0f
                                                                                             blue:146/255.0f
                                                                                           alpha:1.0].CGColor];
    if(callback) {
        [self.delegate userDidTapImage:_selectedImage];
    }
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
