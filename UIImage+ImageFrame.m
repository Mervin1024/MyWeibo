//
//  UIImage+ImageFrame.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/13.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "UIImage+ImageFrame.h"

@implementation UIImage (ImageFrame)
- (CGSize)sizeOfViewImage:(CGFloat)viewWidth{
    CGFloat scale = viewWidth / self.size.width;
    CGSize size = CGSizeMake(viewWidth, self.size.height * scale);
    return size;
}
@end
