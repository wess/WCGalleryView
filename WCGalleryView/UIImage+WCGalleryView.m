//
//  UIImage+WCGalleryView.m
//  WCGalleryView
//
//  Created by Wess Cope on 7/25/12.
//  Copyright (c) 2012 Wess Cope. All rights reserved.
//

#import "UIImage+WCGalleryView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (WCGalleryView)
#pragma mark - Private helper methods -

- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size
{
    CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceGray();
    CGContextRef maskContext    = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaNone);

    CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));

    CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));

    CGImageRef imageRef = CGBitmapContextCreateImage(maskContext);
    
    CGContextRelease(maskContext);
    CGColorSpaceRelease(colorSpace);
    
    return imageRef;
}

#pragma mark - Public Category Methods -
- (BOOL)hasAlpha
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaLast || alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
}

// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)imageWithAlpha
{
    if ([self hasAlpha])
        return self;
    
    CGImageRef imageRef = self.CGImage;
    size_t width        = CGImageGetWidth(imageRef);
    size_t height       = CGImageGetHeight(imageRef);
    
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGImageGetColorSpace(imageRef), kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CGImageRef alphaImageRef    = CGBitmapContextCreateImage(context);
    UIImage *alphaImage         = [UIImage imageWithCGImage:alphaImageRef];
    
    CGContextRelease(context);
    CGImageRelease(alphaImageRef);
    
    return alphaImage;
}

- (UIImage *)transparentBorderImage:(NSUInteger)borderSize
{
    UIImage *image          = [self imageWithAlpha];
    CGRect frame            = CGRectMake(0, 0, image.size.width + borderSize * 2, image.size.height + borderSize * 2);
    CGContextRef bitmap     = CGBitmapContextCreate(NULL, frame.size.width, frame.size.height, CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage));
    CGRect locationFrame    = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
    
    CGContextDrawImage(bitmap, locationFrame, self.CGImage);
    
    CGImageRef borderImageRef               = CGBitmapContextCreateImage(bitmap);
    CGImageRef maskImageRef                 = [self newBorderMask:borderSize size:frame.size];
    CGImageRef transparentBorderImageRef    = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage         = [UIImage imageWithCGImage:transparentBorderImageRef];

    CGContextRelease(bitmap);
    CGImageRelease(borderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

+ (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *rasterizedView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rasterizedView;
}
@end
