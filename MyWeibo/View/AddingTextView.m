//
//  AddingTextView.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/25.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "AddingTextView.h"

@implementation AddingTextView

#pragma mark - 重载 setContentSize 方法
- (void)setContentSize:(CGSize)contentSize{
    CGSize oriSize = self.contentSize;
    [super setContentSize:contentSize];
    if (oriSize.height != self.contentSize.height) {
        if (self.text.length == 0) {
        }else{
            if ([self.delegate respondsToSelector:@selector(textView:heightChange:)]) {
                [self.delegate textView:self heightChange:self.contentSize.height-oriSize.height];
            }
        }
        
    }
}

@end
