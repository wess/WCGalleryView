//
//  WCGalleryExploreView.m
//  WCGalleryView
//
//  Created by Wess Cope on 7/31/12.
//  Copyright (c) 2012 Wess Cope. All rights reserved.
//

#import "WCGalleryExploreView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+WCGalleryView.h"

const CGFloat kWCGalleryControlBarHeight    = 44.0f;
const CGFloat kWCGalleryPinchSizeThreshold  = 0.50f;

@interface WCGalleryExploreView()
{
    UIScrollView                *_scrollView;
    NSMutableArray              *_imageViews;
    UIPinchGestureRecognizer    *_pinchGestureRecognizer;
    CGFloat                     _previousScaling;
    CGAffineTransform           _transform;
    CGRect                      _initialFrame;
    CGSize                      _initialSize;
    CGSize                      _minimalSize;
}
- (void)addImagesToScrollView;
- (void)pinchGestureAction:(UIPinchGestureRecognizer *)gesture;
@end

@implementation WCGalleryExploreView
- (id)initWithImages:(NSArray *)images andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9f];
        _previousScaling     = 1.0f;

        _imageViews         = [[NSMutableArray alloc] init];
        _images             = [images mutableCopy];
        _pagingType         = WCGalleryExplorePageHorizontal;
        _displayType        = WCGalleryExploreDisplayFullScreen;
        _imageInset         = 10.0f;
        _showPagingButtons  = YES;
        _scrollView         = [[UIScrollView alloc] initWithFrame:frame];
        _canPinchToClose    = YES;
        
        _scrollView.pagingEnabled                  = YES;
        
        [self addSubview:_scrollView];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIImage *)generateImageForGalleryWithImage:(UIImage *)image
{
    UIImageView *tmpImageView           = [[UIImageView alloc] initWithImage:image];
    tmpImageView.frame                  = CGRectMake(0.0f, 0.0f, image.size.width, image.size.width);
    tmpImageView.layer.borderColor      = _imageBorderColor.CGColor;
    tmpImageView.layer.borderWidth      = _imageBorderSize;
    tmpImageView.layer.shouldRasterize  = YES;
    
    UIImage *tmpImage   = [UIImage imageFromView:tmpImageView];
    
    return [tmpImage transparentBorderImage:1.0f];
}

- (void)addImagesToScrollView
{
    CGRect imageFrame = _scrollView.frame;
    
    for(UIImage *image in _images)
    {
        CGRect imageViewFrame           = CGRectInset(imageFrame, _imageInset, _imageInset);
        imageViewFrame.origin.y         += 20.0f;
        imageViewFrame.size.height      -= 20.0f;
        
        UIImageView *imageView          = [[UIImageView alloc] initWithImage:[self generateImageForGalleryWithImage:image]];
        imageView.layer.shadowColor     = _imageShadowColor.CGColor;
        imageView.layer.shadowOffset    = _imageShadowOffset;
        imageView.layer.shadowOpacity   = _imageShadowOpacity;
        imageView.layer.shadowRadius    = _imageShadowRadius;
        imageView.layer.shadowPath      = CGPathCreateWithRect(self.bounds, NULL);
        imageView.frame                 = imageViewFrame;

        if(_pagingType == WCGalleryExplorePageVertical)
            imageFrame.origin.y += imageFrame.size.height;
        else
            imageFrame.origin.x += imageFrame.size.width;
        
        [_scrollView addSubview:imageView];
    }
}
- (void)layoutSubviews
{
    if (_displayType == WCGalleryExploreDisplayFullScreen)
        self.frame = [[UIScreen mainScreen] bounds];

    _scrollView.frame = self.frame;
    
    if(_showScrollIndictators)
    {
        _scrollView.showsHorizontalScrollIndicator = (_pagingType == WCGalleryExplorePageHorizontal);
        _scrollView.showsVerticalScrollIndicator   = (_pagingType == WCGalleryExplorePageVertical);
    }
    else
    {
        _scrollView.showsHorizontalScrollIndicator  = NO;
        _scrollView.showsVerticalScrollIndicator    = NO;
    }
    
    _scrollView.contentSize = (_pagingType == WCGalleryExplorePageVertical)? CGSizeMake(self.frame.size.width, (self.frame.size.height * self.images.count)) : CGSizeMake((self.frame.size.width * self.images.count), self.frame.size.height);

    if(_canPinchToClose)
    {
        _transform      = self.transform;
        _initialFrame   = self.frame;
        _initialSize    = self.frame.size;
        _minimalSize    = CGSizeMake((_initialSize.width - (kWCGalleryPinchSizeThreshold * _initialSize.width)), (_initialSize.height - (kWCGalleryPinchSizeThreshold * _initialSize.height)));
        NSLog(@"MIN SIZE: %@", NSStringFromCGSize(_minimalSize));
        
        if(!_pinchGestureRecognizer)
            _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];

        [self addGestureRecognizer:_pinchGestureRecognizer];
    }
    else
    {
        if(_pinchGestureRecognizer)
            [self removeGestureRecognizer:_pinchGestureRecognizer];
    }
    
    [self addImagesToScrollView];
}

#pragma mark - Gestures -

- (void)pinchGestureAction:(UIPinchGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        _previousScaling = 1.0f;

        CGSize currentSize  = self.frame.size;
        CGFloat width       = currentSize.width;
        CGFloat height      = currentSize.height;
        CGFloat minWidth    = _minimalSize.width;
        CGFloat minHeight   = _minimalSize.height;

        if((width <= minWidth) && (height <= minHeight))
        {
            [UIView animateWithDuration:0.2f animations:^{
                CGAffineTransform currentTransform = self.transform;
                CGAffineTransform newTransform     = CGAffineTransformScale(currentTransform, 0.0f, 0.0f);
                self.transform                     = newTransform;
                self.alpha                         = 0.0f;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.2f animations:^{
                self.transform = _transform;
            }];
            
            return;
        }
        
        return;
    }

    CGFloat scale = 1.0f - (_previousScaling - gesture.scale);
    CGAffineTransform currentTransform = self.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    self.transform = newTransform;

    _previousScaling = gesture.scale;
    
    NSLog(@"VIEW SIZE: %@", NSStringFromCGSize(self.frame.size));
}

@end
