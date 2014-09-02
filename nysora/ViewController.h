//
//  ViewController.h
//  nysora
//
//  Created by Johan Hörnell on 8/11/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYSORAFeaturedContentView.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) NSDictionary *json;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic,strong) UITableView * blocksTableView;
@property (nonatomic, strong) NSMutableArray *arrayOfBlocks;
@property (strong, nonatomic) UIImageView *previewImageView;
@property (strong, nonatomic) NYSORAFeaturedContentView *featuredContentView;
@property (nonatomic, strong) UISwipeGestureRecognizer *featuredContentSwipeLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer *featuredContentSwipeRight;
@property (nonatomic, strong) UITapGestureRecognizer *tapThat;


@end