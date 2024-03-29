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
@property (nonatomic) NSNumber* textSize;
@property (nonatomic) NSNumber* testProperty;
@property (nonatomic, strong) IBOutlet UILabel * adjustedText;
@property (nonatomic, strong) IBOutlet UILabel * sliderLabel1;
@property (nonatomic, strong) IBOutlet UILabel * sliderLabel2;
@property (nonatomic, strong) IBOutlet UILabel * sliderLabel3;
@property (nonatomic, strong) IBOutlet UILabel * sliderLabel4;
@property (nonatomic, strong) IBOutlet UILabel * adjustTextTitle;
@property (nonatomic, strong) IBOutlet UISlider * textSizingSlider;


@end
