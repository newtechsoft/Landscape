//
//  TextSizingViewController.m
//  nysora
//
//  Created by Martin Greenberg on 9/7/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import "TextSizingViewController.h"

@interface TextSizingViewController ()

@end

@implementation TextSizingViewController





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Initiate and allocate the slider view.
    _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    
    //Set the subview for the slider view
    [self.view addSubview:self.sliderView];

    
    //create and initialize the slider
    self.textSizingSlider = [[UISlider alloc] initWithFrame:CGRectMake(60, 250, 200, 30)];
    //Set Background color
    self.textSizingSlider.backgroundColor = [UIColor blackColor];
    //set the minimum value
    self.textSizingSlider.minimumValue = 0.0;
    //set the maximum value
    self.textSizingSlider.maximumValue = 100.0;
    //set the initial value
    self.textSizingSlider.value = 25.0;
    [self.view addSubview:self.textSizingSlider];
    
    // These number values represent each slider position
    numbers = @[@(-3), @(0), @(2), @(4), @(7), @(10), @(12)];
    // slider values go from 0 to the number of values in your numbers array
    NSInteger numberOfSteps = ((float)[numbers count] - 1);
    self.textSizingSlider.maximumValue = numberOfSteps;
    self.textSizingSlider.minimumValue = 0;
    
    // As the slider moves it will continously call the -valueChanged:
    self.textSizingSlider.continuous = YES; // NO makes it call only once you let go
    [self.textSizingSlider addTarget:self action:@selector(sliderChanged:)forControlEvents:UIControlEventValueChanged];
    
    //Set the background color
    self.sliderView.backgroundColor = [UIColor blackColor];
    
    UILabel *adjustTextTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 100, 320, 100)];
    adjustTextTitle.text = @"Slide the bar to change the text size.";
    adjustTextTitle.textColor = [UIColor colorWithWhite:1 alpha:1];
    adjustTextTitle.font = [UIFont fontWithName:@"FontAwesome" size:15];
    [self.sliderView addSubview:adjustTextTitle];

    //Set text for slider
    UILabel *adjustedText = [[UILabel alloc] initWithFrame:CGRectMake(40, 300, 240, 100)];
    adjustedText.textColor = [UIColor colorWithWhite:1 alpha:1];
    adjustedText.backgroundColor = [UIColor redColor];
//    adjustedText.font = [UIFont fontWithName:@"FontAwesome" size:15];
    adjustedText.text = [NSString stringWithFormat:@"Sample Text"];
    adjustedText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.sliderView addSubview:adjustedText];
    
        NSLog(@"number: %@", self.textSize);
    
        NSLog(@"The value stored is %@",self.adjustedText.text);
    

    
    
    //Set up the close button
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton addTarget:self action:@selector(closeTextSizing:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setTitle:@"" forState:UIControlStateNormal];
    self.closeButton.frame = CGRectMake(0, 0, 60, 60);
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18];
    [self.view addSubview:self.closeButton];
}


- (IBAction)sliderChanged:(id)sender

{
    // round the slider position to the nearest index of the numbers array
    NSUInteger index = (NSUInteger)(self.textSizingSlider.value + 0.5);
    [self.textSizingSlider setValue:index animated:NO];
    self.textSize = numbers[index]; // <-- This numeric value you want
    NSLog(@"sliderIndex: %i", (int)index);


    
    
}

//Close the text sizing view
-(void)closeTextSizing:(UIButton*)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
