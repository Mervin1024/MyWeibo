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

- (void)setContentWithFrame:(CGRect)rect{
    NSLog(@"setContentWithFrame");
    imageView.frame = rect;
    initRect = rect;
}

- (void)setAnimationRect{
    NSLog(@"setAnimationRect");
    NSLog(@"%@",NSStringFromCGRect(scaleOriginRect));
    imageView.frame = scaleOriginRect;
}

- (void)rechangeInitRdct{
    NSLog(@"rechangeInitRdct");
    self.zoomScale = 1.0;
    imageView.frame = initRect;
}

- (void)setImage:(UIImage *)image{
    NSLog(@"setImage");
    imageView.image = image;
    imgSize = image.size;
    
    float scaleX = self.frame.size.width/imgSize.width;
    float scaleY = self.frame.size.height/imgSize.height;
    
    if (scaleX > scaleY) {
//        NSLog(@"a");
        float imageW = imgSize.width*scaleY;
        self.minimumZoomScale = self.frame.size.width/imageW;
        scaleOriginRect = CGRectMake(self.frame.size.width/2-imageW/2, 0, imageW, self.frame.size.height);
    }else{
        NSLog(@"%@",NSStringFromCGSize(imgSize));
        float imageH = imgSize.height*scaleX;
        self.maximumZoomScale = self.frame.size.height/imageH;
        scaleOriginRect = CGRectMake(0, self.frame.size.height/2-imageH/2, self.frame.size.width, imageH);
    }
}
// scroll delegate
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
