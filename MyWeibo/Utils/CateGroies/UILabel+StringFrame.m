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

- (CGFloat)hightOfLabelWithFontSize:(NSInteger)size linesNumber:(NSInteger)num{
    // 根据字体 行数 计算高度
    UILabel *la = [[UILabel alloc]init];
    la.font = [UIFont systemFontOfSize:size];
    la.text = @"啊";
    la.numberOfLines = 0;
    CGSize aLineOfText = [la boundingRectWithSize:CGSizeMake(100, 0)];
    CGFloat laH = aLineOfText.height;
    for (int i = 1; i < num; i++) {
        la.text = [la.text stringByAppendingString:@"啊"];
        CGSize laSize = [la boundingRectWithSize:CGSizeMake(aLineOfText.height, 0)];
        laH = laSize.height;
    }
    return laH;
}
@end
