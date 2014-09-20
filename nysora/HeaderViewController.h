//
//  HeaderViewController.h
//  nysora
//
//  Created by Johan Hörnell on 8/12/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYSORAHeadersPaginationView.h"

@interface HeaderViewController : UIViewController

@property (nonatomic, strong) NSString *whichBlockAmIIn;
@property (nonatomic, strong) NSString *whichBlockNameAmIIn;
@property (nonatomic, strong) NSString *whichHeaderNameAmI;
@property (nonatomic) NSInteger howManyHeadersAreThere;
@property (nonatomic) int whichHeaderAmI;
@property (nonatomic, strong) NSMutableArray *json;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeRecognizer;

@property (nonatomic, strong) NYSORAHeadersPaginationView *paginationView;
@property (nonatomic, strong) NSString *globalTextSize;


-(void)swipeHandlerRight:(UISwipeGestureRecognizer *)recognizer;
-(void)swipeHandlerLeft:(UISwipeGestureRecognizer *)recognizer;

@end
