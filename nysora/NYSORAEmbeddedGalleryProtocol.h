//
//  NYSORAEmbeddedGalleryProtocol.h
//  nysora
//
//  Created by Johan Hörnell on 8/30/14.
//  Copyright (c) 2014 Upload LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NYSORAEmbeddedGalleryProtocol <NSObject>

@optional
-(void)userDidTapImage:(NSInteger)imageNumber;
@end
