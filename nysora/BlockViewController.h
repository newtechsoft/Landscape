//
//  BlockViewController.h
//  nysora
//
//  Created by Johan Hörnell on 8/11/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockViewController : UIViewController

@property (nonatomic) NSInteger whichBlockAmI;
@property (nonatomic, strong) NSString *whichBlockNameAmI;
@property (nonatomic, strong) NSString *whichBlockIdAmI;

@end
