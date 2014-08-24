//
//  NYSORABlocksTableViewCell.m
//  nysora
//
//  Created by Johan Hörnell on 8/19/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "NYSORABlocksTableViewCell.h"

@implementation NYSORABlocksTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.blockPreviewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 50, 40)];
        [self addSubview:self.blockPreviewImageView];
        self.blockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 220, 20)];
        [self addSubview:self.blockNameLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews {
    [super layoutSubviews];
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

-(void)setBlockThumbnailWithImageName:(NSString *)imageName
{
    self.blockPreviewImageView.image = [UIImage imageNamed:imageName];
    self.blockPreviewImageView.backgroundColor = [UIColor whiteColor];
    self.blockPreviewImageView.contentMode = UIViewContentModeScaleAspectFit;
    if(self.blockPreviewImageView.image == nil) {
        NSLog(@"Couldnt find image at path %@", imageName);
    }
}

@end
