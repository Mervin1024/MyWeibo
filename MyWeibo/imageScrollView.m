//
//  imageScrollView.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/18.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "ImageScrollView.h"

@interface ImageScrollView()<UIScrollViewDelegate>
{
    UIImageView *imageView;
    
    CGRect scaleOriginRect;
    
    CGSize imgSize;
    
    CGRect initRect;
}

@end

@implementation ImageScrollView
#pragma mark - init 方法
- (ImageScrollView *)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        
        imageView = [[UIImageView alloc]init];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
    }
    return self;
}
#pragma mark - 设置图片初始位置及 rect
- (void)setContentWithFrame:(CGRect)rect{
    imageView.frame = rect;
    initRect = rect;
}
#pragma mark - 图片放大后的 rect
- (void)setAnimationRect{
    imageView.frame = scaleOriginRect;
}

- (void)rechangeInitRdct{
    self.zoomScale = 1.0;
    imageView.frame = initRect;
}
#pragma mark - 放大图片
- (void)setImage:(UIImage *)image{

    imageView.image = image;
    imgSize = image.size;

    float scaleX = self.frame.size.width/imgSize.width;
    float scaleY = self.frame.size.height/imgSize.height;

    
    if (scaleX > scaleY) {
        float imageW = imgSize.width*scaleY;
        self.minimumZoomScale = self.frame.size.width/imageW;
        scaleOriginRect = CGRectMake(self.frame.size.width/2-imageW/2, 0, imageW, self.frame.size.height);
    }else{
        float imageH = imgSize.height*scaleX;
        self.maximumZoomScale = self.frame.size.height/imageH;
        scaleOriginRect = CGRectMake(0, self.frame.size.height/2-imageH/2, self.frame.size.width, imageH);
    }
}
#pragma mark -  scroll delegate 协议
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imageFrame = imageView.frame;
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    if (imageFrame.size.width <= boundsSize.width) {
        centerPoint.x = boundsSize.width/2;
    }
    if (imageFrame.size.height <= boundsSize.height) {
        centerPoint.y = boundsSize.height/2;
    }
    imageView.center = centerPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self.i_delegate respondsToSelector:@selector(tapImageViewTappedWithObject:)]) {
        [self.i_delegate tapImageViewTappedWithObject:self];
    }
}

@end
