//
//  ViewController.h
//  nysora
//
//  Created by Johan Hörnell on 8/11/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) NSDictionary *json;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, weak) UILabel *textLabel;
@property (strong, nonatomic) UITableView *blocksTableView;
@property (strong, nonatomic) UIImageView *previewImageView;

@end