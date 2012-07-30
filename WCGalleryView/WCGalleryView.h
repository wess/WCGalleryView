//
//  WCGalleryView.h
//  WCGalleryView
//
//  Created by Wess Cope on 7/25/12.
//  Copyright (c) 2012 Wess Cope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    WCGalleryAnimationFade  = 1,
    WCGalleryAnimationFall  = 2,
    WCGalleryAnimationCurl  = 3
} WCGalleryAnimationType;

typedef enum
{
    WCGalleryStackRadiusClockwise           = 1,
    WCGalleryStackRadiusCounterClockwise    = 2,
    WCGalleryStackRadiusRandom              = 3
} WCGalleryStackRadiusDirection;

@interface WCGalleryView : UIView
@property (assign, nonatomic) WCGalleryAnimationType animationType;
@property (assign, nonatomic) WCGalleryStackRadiusDirection stackRadiusDirection;
@property (assign, nonatomic) CGFloat stackRadiusOffset;
@property (assign, nonatomic) CGFloat animationDuration;
@property (assign, nonatomic) BOOL    animate;
@property (assign, nonatomic) UIColor *borderColor;
@property (assign, nonatomic) CGFloat borderWidth;
@property (assign, nonatomic) UIColor *shadowColor;
@property (assign, nonatomic) CGSize  shadowOffset;
@property (assign, nonatomic) CGFloat shadowRadius;
@property (assign, nonatomic) CGFloat shadowOpacity;


- (id)initWithImages:(NSArray *)images frame:(CGRect)frame;
- (void)addImage:(UIImage *)image animated:(BOOL)animated;
- (void)removeImageAtIndex:(NSInteger)index animated:(BOOL)animated;
@end
