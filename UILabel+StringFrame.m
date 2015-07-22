//
//  UILabel+StringFrame.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/13.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)
#pragma mark - 计算文本内容 Size
- (CGSize)boundingRectWithSize:(CGSize)size{
    NSDictionary *attribute = @{NSFontAttributeName:self.font};
    CGSize retSize =  [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return retSize;
}
@end
