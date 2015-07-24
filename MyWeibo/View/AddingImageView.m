//
//  AddingImageView.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/24.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "AddingImageView.h"

@interface AddingImageView (){
    UIButton *deleteButton;
}

@end

@implementation AddingImageView
- (AddingImageView *)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        CGFloat buttonwidth = self.frame.size.width/6;
        deleteButton = [[UIButton alloc]init];
        deleteButton.frame = CGRectMake(buttonwidth*5, 0, buttonwidth, buttonwidth);
        [deleteButton addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
        [self addSubview:deleteButton];
    }
    return self;
}

- (void)deleteImageView:(id)sender{
    [self.m_delegate AddingImageView:self didSelectDeleteButton:sender];
}

@end
