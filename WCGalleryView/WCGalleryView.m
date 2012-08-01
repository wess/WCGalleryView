//
//  WCGalleryView.m
//  WCGalleryView
//
//  Created by Wess Cope on 7/25/12.
//  Copyright (c) 2012 Wess Cope. All rights reserved.
//

#import "WCGalleryView.h"
#import "UIView+WCGalleryView.h"
#import "UIImage+WCGalleryView.h"

@interface WCGalleryView()
{
    NSOperationQueue        *_imageQueue;
    NSMutableArray          *_images;
    BOOL                    _haveBuiltImageViews;
    CGFloat                 _previousScaling;
    CGPoint                 _center;
}

@property (strong) NSMutableArray *imageViews;


- (void)runLoadImage:(NSArray *)imageDetails;
- (void)loadImage:(UIImage *)image animated:(BOOL)animated;
- (UIImage *)generateImageForGalleryWithImage:(UIImage *)image;
- (void)insertImageViewAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)rotateImageView:(UIImageView *)imageView withControl:(NSInteger)control animated:(BOOL)animated callback:(void(^)())block;
//- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gesture;
- (void)touchAction:(UITapGestureRecognizer *)gesture;
@end

@implementation WCGalleryView

- (id)initWithImages:(NSArray *)images frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.autoresizesSubviews    = NO;

        _imageQueue = [[NSOperationQueue alloc] init];
        _imageQueue.maxConcurrentOperationCount = 1;
        [_imageQueue setSuspended:YES];
        
        _images                 = [images mutableCopy];
        _borderWidth            = 0.0f;
        _imageViews             = [[NSMutableArray alloc] init];
        _animationType          = WCGalleryAnimationFade;
        _stackRadiusOffset      = 4.0f;
        _stackRadiusDirection   = WCGalleryStackRadiusRandom;
        _animationDuration      = -1.0f;
        _animate                = YES;
        _haveBuiltImageViews    = NO;
        _previousScaling        = 1.0f;
        
//        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
//        self.gestureRecognizers = @[pinchGesture];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)addImage:(UIImage *)image animated:(BOOL)animated
{
    [_imageQueue addOperationWithBlock:^{
        [self performSelectorOnMainThread:@selector(runLoadImage:) withObject:@[image, [NSNumber numberWithBool:animated]] waitUntilDone:YES];
    }];
}

- (void)removeImageAtIndex:(NSInteger)index animated:(BOOL)animated
{
    
    [_imageViews removeObjectAtIndex:index];
}

#pragma mark - Private Methods -
 - (void)runLoadImage:(NSArray *)imageDetails
{
    [self loadImage:[imageDetails objectAtIndex:0] animated:[[imageDetails objectAtIndex:1] boolValue]];
}

- (void)loadImage:(UIImage *)image animated:(BOOL)animated
{
    [_imageQueue setSuspended:YES];
    UIImageView *topImageView       = [self.subviews lastObject]; //(self.imageViews.count > 0)? [self.imageViews objectAtIndex:0] : nil;
    UIImage *tmpImage               = [self generateImageForGalleryWithImage:image];
    UIImageView *imageView          = [[UIImageView alloc] initWithImage:tmpImage];
    imageView.frame                 = self.bounds;
    imageView.layer.shadowColor     = _shadowColor.CGColor;
    imageView.layer.shadowOffset    = _shadowOffset;
    imageView.layer.shadowRadius    = _shadowRadius;
    imageView.layer.shadowOpacity   = _shadowOpacity;
    imageView.alpha                 = 0.0f;
    
    [self.imageViews addObject:imageView];
    
    CGRect fromFrame,
           toFrame;
    
    switch (_animationType)
    {
        case WCGalleryAnimationFall:
        {
            fromFrame                 = imageView.frame;
            fromFrame.size.width     *= 2.0f;
            fromFrame.size.height    *= 2.0f;
            fromFrame.origin.x        = ([[UIScreen mainScreen] bounds].size.width / 2)  - (toFrame.size.width / 2);
            fromFrame.origin.y        = ([[UIScreen mainScreen] bounds].size.height / 2) - (toFrame.size.height / 2);
            
            toFrame             = self.bounds;
            imageView.frame     = fromFrame;
            imageView.center    = self.center;

            [self addSubview:imageView];
            
            [UIView animateWithDuration:_animationDuration animations:^{
                if(topImageView != nil)
                    [self rotateImageView:topImageView withControl:[self.subviews indexOfObject:topImageView] animated:NO callback:nil];
                
                imageView.alpha = 1.0f;
                imageView.frame = toFrame;
            } completion:^(BOOL finished) {
                [_imageQueue setSuspended:NO];
            }];
        }
        break;
        
        case WCGalleryAnimationCurl:
        {
            toFrame = self.bounds;

            imageView.frame = toFrame;
            [UIView transitionWithView:topImageView duration:_animationDuration options:UIViewAnimationOptionTransitionCurlDown animations:^{
                [self addSubview:imageView];
                imageView.alpha = 1.0f;

            } completion:^(BOOL finished) {
                if(topImageView != nil)
                {
                    [self rotateImageView:topImageView withControl:[self.subviews indexOfObject:topImageView] animated:YES callback:^{
                        [_imageQueue setSuspended:NO];
                    }];
                }
            }];
        }
        break;
            
        default:
        {
            [self addSubview:imageView];
            
            [UIView animateWithDuration:_animationDuration animations:^{
                if(topImageView != nil)
                    [self rotateImageView:topImageView withControl:[self.subviews indexOfObject:topImageView] animated:NO callback:nil];
                
                imageView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [_imageQueue setSuspended:NO];
            }];    
        }
        break;
    }
}

- (UIImage *)generateImageForGalleryWithImage:(UIImage *)image
{
    UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:image];
    tmpImageView.frame                  = CGRectMake(0.0f, 0.0f, image.size.width, image.size.width);
    tmpImageView.layer.borderColor      = _borderColor.CGColor;
    tmpImageView.layer.borderWidth      = _borderWidth;
    tmpImageView.layer.shouldRasterize  = YES;
    
    UIImage *tmpImage   = [UIImage imageFromView:tmpImageView];

    return [tmpImage transparentBorderImage:1.0f];
}

- (void)rotateImageView:(UIImageView *)imageView withControl:(NSInteger)control animated:(BOOL)animated callback:(void(^)())block
{
    CGFloat degrees;
    
    switch (_stackRadiusDirection)
    {
        case WCGalleryStackRadiusClockwise:
            degrees = (control * _stackRadiusOffset);
            break;
        case WCGalleryStackRadiusCounterClockwise:
            degrees = -(control * _stackRadiusOffset);
            break;
            
        case WCGalleryStackRadiusRandom:
            degrees = ((arc4random() % (int)(_stackRadiusOffset)) * control);
            degrees = ((rand() % 2) == 0)? degrees : -(degrees);
            break;
            
        default:
            break;
    }
    
    CGFloat animationDuration = (!animated)? 0 : (((_animationDuration == -1)? ((control == 0)? 0 : degrees / 100) : _animationDuration));
    
    [imageView rotateView:degrees duration:animationDuration callback:block];
}

- (void)insertImageViewAtIndex:(NSInteger)index animated:(BOOL)animated
{
    UIImageView *imageView          = [_imageViews objectAtIndex:index];
    imageView.autoresizingMask      =   UIViewAutoresizingFlexibleTopMargin     |
                                        UIViewAutoresizingFlexibleRightMargin   |
                                        UIViewAutoresizingFlexibleBottomMargin  |
                                        UIViewAutoresizingFlexibleLeftMargin    |
                                        UIViewAutoresizingFlexibleHeight        |
                                        UIViewAutoresizingFlexibleWidth;
    
    imageView.frame                 = self.bounds;
    imageView.layer.shadowColor     = _shadowColor.CGColor;
    imageView.layer.shadowOffset    = _shadowOffset;
    imageView.layer.shadowRadius    = _shadowRadius;
    imageView.layer.shadowOpacity   = _shadowOpacity;
    
    if(index > 0)
    {
        UIImageView *lastImageView = [_imageViews objectAtIndex:index - 1];
        [self insertSubview:imageView belowSubview:lastImageView];
    }
    else
    {
        [self addSubview:imageView];
    }

   [self rotateImageView:imageView withControl:index animated:animated callback:nil];
    
    if([[_imageViews lastObject] isEqual:imageView])
        [_imageQueue setSuspended:NO];
}

- (void)layoutSubviews
{
    _center = self.center;

    if(!_haveBuiltImageViews)
    {
        for(UIImage *image in _images)
        {
            UIImage *tmpImage               = [self generateImageForGalleryWithImage:image];
            UIImageView *imageView          = [[UIImageView alloc] initWithImage:tmpImage];
            imageView.frame                 = self.bounds;
            imageView.layer.shadowColor     = _shadowColor.CGColor;
            imageView.layer.shadowOffset    = _shadowOffset;
            imageView.layer.shadowRadius    = _shadowRadius;
            imageView.layer.shadowOpacity   = _shadowOpacity;
            
            [_imageViews addObject:imageView];
        }
        
        for(NSInteger total = 0; total < _imageViews.count; total++)
            [self insertImageViewAtIndex:total animated:_animate];
            
        _haveBuiltImageViews = YES;
    }
}

#pragma mark - Gesture handlers -

- (void)touchAction:(UITapGestureRecognizer *)gesture
{
    CGRect exploreFrame = [[UIApplication sharedApplication] keyWindow].frame;

    WCGalleryExploreView *exploreView   = [[WCGalleryExploreView alloc] initWithImages:_images andFrame:exploreFrame];
    exploreView.alpha                   = 0.0f;

    [[[UIApplication sharedApplication] keyWindow] addSubview:exploreView];

    [UIView animateWithDuration:0.2f animations:^{
        exploreView.alpha  = 1.0f;
    }];
}

// Coming soon....
//- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gesture
//{
//    if(gesture.state == UIGestureRecognizerStateEnded)
//    {
//        _previousScaling = 1.0f;
//        return;
//    }
//    
//    CGFloat scale = 1.0f - (_previousScaling - gesture.scale);
////    CGAffineTransform currentTransform = self.transform;
////    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
////    self.transform = newTransform;
//
//    CGAffineTransform rectTransform = CGAffineTransformMakeScale(scale, scale);
//    CGRect newFrame = CGRectApplyAffineTransform(self.frame, rectTransform);
//    self.bounds = newFrame;
//    
//    for(UIImageView *view in self.subviews)
//        view.center = self.center;
//    
//    
//    _previousScaling = gesture.scale;
//}

@end
