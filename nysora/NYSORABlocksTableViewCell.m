//
//  NYSORABlocksTableViewCell.m
//  nysora
//
//  Created by Johan Hörnell on 8/19/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "NYSORABlocksTableViewCell.h"

@implementation NYSORABlocksTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBlockThumbnailWithImagePath:(NSString *)imagePath
{
    NSString* imageName = [[NSBundle mainBundle] pathForResource:imagePath ofType:@"png"];
    self.blockPreviewImageView.image = [UIImage imageWithContentsOfFile:imageName];
    self.blockPreviewImageView.backgroundColor = [UIColor whiteColor];
    if(self.blockPreviewImageView.image == nil) {
        NSLog(@"Couldnt find image at path %@", imagePath);
    }
}

@end
