//
//  NYSORAThumbnailRowProtocol.h
//  nysora
//
//  Created by Johan Hörnell on 8/31/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NYSORAThumbnailRowProtocol <NSObject>

@optional
-(void)userDidTapImage:(NSInteger)imageNumber;

@end
