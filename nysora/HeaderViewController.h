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
@property (nonatomic, strong) NSString *whichHeaderNameAmI;
@property (nonatomic) NSInteger howManyHeadersAreThere;
@property (nonatomic) int whichHeaderAmI;
@property (nonatomic, strong) NSDictionary *json;

@property (nonatomic, strong) NYSORAHeadersPaginationView *paginationView;

@end
