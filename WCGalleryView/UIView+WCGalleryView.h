//
//  UIView+WCGalleryView.h
//  WCGalleryView
//
//  Created by Wess Cope on 7/25/12.
//  Copyright (c) 2012 Wess Cope. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RADIANS_TO_DEGREES(degrees) (degrees * M_PI / 180)

@interface UIView (WCGalleryView)
#pragma mark - With Callbacks -
- (void)rotateView:(NSInteger)degrees duration:(CGFloat)duration callback:(void(^)())block;
- (void)scaleViewToSize:(CGSize)size duration:(CGFloat)duration callback:(void(^)())block;
- (void)curlViewUpForDuration:(CGFloat)duration callback:(void(^)())block;
- (void)curlViewDownForDuration:(CGFloat)duration callback:(void(^)())block;
- (void)fadeViewInForDuration:(CGFloat)duration callback:(void(^)())block;
- (void)fadeViewOutForDuration:(CGFloat)duration callback:(void(^)())block;

#pragma mark - Without Callbacks -
- (void)rotateView:(NSInteger)degrees duration:(CGFloat)duration;
- (void)scaleViewToSize:(CGSize)size duration:(CGFloat)duration;
- (void)curlViewUpForDuration:(CGFloat)duration;
- (void)curlViewDownForDuration:(CGFloat)duration;
- (void)fadeViewInForDuration:(CGFloat)duration;
- (void)fadeViewOutForDuration:(CGFloat)duration;
@end
