//
//  HeaderViewController.h
//  nysora
//
//  Created by Johan Hörnell on 8/12/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderViewController : UIViewController

@property (nonatomic, strong) NSString *whichBlockAmIIn;
@property (nonatomic) int whichHeaderAmI;
@property (nonatomic, strong) NSDictionary *json;

@end
