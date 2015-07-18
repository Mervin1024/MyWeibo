//
//  imageScrollView.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/18.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol ImageScrollViewDelegate <NSObject>

- (void) tapImageViewTappedWithObject:(id) sender;

@end

@interface ImageScrollView : UIScrollView

- (void) setContentWithFrame:(CGRect) rect;
- (void) setImage:(UIImage *) image;
- (void) setAnimationRect;
- (void) rechangeInitRdct;

@property (weak, nonatomic) id<ImageScrollViewDelegate> i_delegate;
@end
