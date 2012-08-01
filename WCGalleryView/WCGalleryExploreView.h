//
//  WCGalleryExploreView.h
//  WCGalleryView
//
//  Created by Wess Cope on 7/31/12.
//  Copyright (c) 2012 Wess Cope. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WCGalleryExplorePageHorizontal  = 1,
    WCGalleryExplorePageVertical    = 2
} WCGalleryExplorePagingType;

typedef enum {
    WCGalleryExploreDisplayFullScreen   = 1,
    WCGalleryExploreDisplayModal        = 2
} WCGalleryExploreDisplayType;

@protocol WCGalleryExploreDataSource;
@interface WCGalleryExploreView : UIView<UIScrollViewDelegate>
@property (assign, nonatomic) id<WCGalleryExploreDataSource> datesource;
@property (assign, nonatomic) WCGalleryExplorePagingType     pagingType;
@property (assign, nonatomic) WCGalleryExploreDisplayType    displayType;
@property (strong, nonatomic) NSMutableArray                 *images;
@property (assign, nonatomic) BOOL                           showPagingButtons;
@property (assign, nonatomic) BOOL                           showScrollIndictators;
@property (assign, nonatomic) BOOL                           canPinchToClose;
@property (assign, nonatomic) CGFloat                        imageInset;
@property (assign, nonatomic) CGFloat                        imageBorderSize;
@property (assign, nonatomic) UIColor                        *imageBorderColor;
@property (assign, nonatomic) UIColor                        *imageShadowColor;
@property (assign, nonatomic) CGSize                         imageShadowOffset;
@property (assign, nonatomic) CGFloat                        imageShadowRadius;
@property (assign, nonatomic) CGFloat                        imageShadowOpacity;


- (id)initWithImages:(NSArray *)images andFrame:(CGRect)frame;
@end
