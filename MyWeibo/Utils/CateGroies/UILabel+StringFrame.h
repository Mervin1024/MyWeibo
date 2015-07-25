//
//  UILabel+StringFrame.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/13.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (StringFrame)
- (CGSize)boundingRectWithSize:(CGSize)size;
+ (CGFloat)hightOfLabelWithFontSize:(NSInteger)size linesNumber:(NSInteger)num;
@end
