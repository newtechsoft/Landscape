//
//  TextSizingViewController.h
//  nysora
//
//  Created by Martin Greenberg on 9/7/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "ViewController.h"

@interface TextSizingViewController : ViewController{

    NSArray *numbers;}

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView * sliderView;
@property (nonatomic, strong) IBOutlet UILabel * adjustedText;
@property (nonatomic, strong) IBOutlet UILabel * adjustTextTitle;
@property (nonatomic, strong) IBOutlet UISlider * textSizingSlider;

@end
