//
//  NYSORABlocksTableViewCell.h
//  nysora
//
//  Created by Johan Hörnell on 8/19/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYSORABlocksTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *blockNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *blockPreviewImageView;

-(void)setBlockThumbnailWithImagePath:(NSString *)imagePath;
-(void)setBlockThumbnailWithImageName:(NSString *)imageName;

@end
