//
//  UIImage+WCGalleryView.h
//  WCGalleryView
//
//  Created by Wess Cope on 7/25/12.
//  Copyright (c) 2012 Wess Cope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WCGalleryView)
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;
+ (UIImage *)imageFromView:(UIView *)view;
@end
