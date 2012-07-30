//
//  UIView+WCGalleryView.m
//  WCGalleryView
//
//  Created by Wess Cope on 7/25/12.
//  Copyright (c) 2012 Wess Cope. All rights reserved.
//

#import "UIView+WCGalleryView.h"


@implementation UIView (WCGalleryView)
#pragma mark - With Callbacks -
- (void)rotateView:(NSInteger)degrees duration:(CGFloat)duration  callback:(void(^)())block
{
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, RADIANS_TO_DEGREES(degrees));
                     }
                     completion:^(BOOL finished) {
                         if(block)
                             block();
                     }];
}

- (void)scaleViewToSize:(CGSize)size duration:(CGFloat)duration callback:(void(^)())block
{
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, size.width, size.height);
                     } completion:^(BOOL finished) {
                         if(block)
                             block();
                     }];
}

- (void)curlViewUpForDuration:(CGFloat)duration callback:(void(^)())block
{
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         self.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         if(block)
                             block();
                     }];
}

- (void)curlViewDownForDuration:(CGFloat)duration callback:(void(^)())block
{
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCurlDown
                     animations:^{
                         self.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         if(block)
                             block();
                     }];
}

- (void)fadeViewInForDuration:(CGFloat)duration callback:(void(^)())block
{
}

- (void)fadeViewOutForDuration:(CGFloat)duration callback:(void(^)())block
{
}


#pragma mark - Without Callbacks -

- (void)rotateView:(NSInteger)degrees duration:(CGFloat)duration
{
    [self rotateView:degrees duration:duration callback:nil];
}

- (void)scaleViewToSize:(CGSize)size duration:(CGFloat)duration
{
    [self scaleViewToSize:size duration:duration callback:nil];
}

- (void)curlViewUpForDuration:(CGFloat)duration
{
    [self curlViewUpForDuration:duration callback:nil];
}

- (void)curlViewDownForDuration:(CGFloat)duration
{
    [self curlViewDownForDuration:duration callback:nil];
}

- (void)fadeViewInForDuration:(CGFloat)duration
{
    [self fadeViewInForDuration:duration callback:nil];
}

- (void)fadeViewOutForDuration:(CGFloat)duration
{
    [self fadeViewOutForDuration:duration callback:nil];
}
@end
