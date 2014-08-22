//
//  NYSORAHeaderTableViewCell.m
//  nysora
//
//  Created by Johan Hörnell on 8/19/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "NYSORAHeaderTableViewCell.h"

@implementation NYSORAHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //Set size of cell
        self.frame = CGRectMake(0, 0, 320, 60);
        
        //Set up the headerNumberLabel
        self.headerNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 320, 60)];
        self.headerNumberLabel.textColor = [UIColor
                                           colorWithRed:60/255.0f
                                           green:130/255.0f
                                           blue:146/255.0f
                                            alpha:1.0];
        [self addSubview:self.headerNumberLabel];
        //Set up the circle
        CALayer *circleLayer = [[CALayer alloc] init];
        circleLayer.masksToBounds = YES;
        circleLayer.frame = CGRectMake(10, 10, 40, 40);
        circleLayer.bounds = CGRectMake(0, 0, 40, 40);
        circleLayer.borderWidth = 2;
        circleLayer.borderColor = [UIColor
                                       colorWithRed:60/255.0f
                                       green:130/255.0f
                                       blue:146/255.0f
                                       alpha:1.0].CGColor;
        [circleLayer setCornerRadius:20.0f];
        circleLayer.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0].CGColor;
        [self.layer insertSublayer:circleLayer below:self.headerNumberLabel.layer];
        
        //Set up the headerNameLabel
        self.headerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 320, 60)];
        [self addSubview:self.headerNameLabel];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
