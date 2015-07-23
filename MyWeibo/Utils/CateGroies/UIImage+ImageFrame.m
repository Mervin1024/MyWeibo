//
//  UIImage+ImageFrame.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/13.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "UIImage+ImageFrame.h"

@implementation UIImage (ImageFrame)
#pragma mark - 计算图片 Size
- (CGSize)sizeOfViewImageWithWidth:(CGFloat)viewWidth{
    CGFloat scale = viewWidth / self.size.width;
    CGSize size = CGSizeMake(viewWidth, self.size.height * scale);
    return size;
    // 固定宽计算图片缩放大小
}

- (CGSize)sizeOfViewImageWithHight:(CGFloat)viewHight{
    CGFloat scale = viewHight / self.size.height;
    CGSize size = CGSizeMake(self.size.width * scale, viewHight);
    return size;
    // 固定高计算图片缩放大小
}
@end
