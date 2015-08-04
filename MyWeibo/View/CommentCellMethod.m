//
//  CommentCellMethod.m
//  MyWeibo
//
//  Created by 马遥 on 15/8/3.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "CommentCellMethod.h"

@implementation CommentCellMethod

- (void)forward{
    [SVProgressHUD showErrorWithStatus:@"不能联网你想转给谁看?\n←_←"];
}

- (void)Praise{
    NSString *str = self.news.user.desc;
    if ([self.news.user_id isEqualToString:[PersonalModel personalIDfromUserDefaults]]) {
        str = @"我自己也";
    }
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@棒棒哒\n(￣3￣)",str]];
}

- (void)Comment{
    NSString *str = self.news.user.desc;
    if ([self.news.user_id isEqualToString:[PersonalModel personalIDfromUserDefaults]]) {
        str = @"自己";
    }
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"亲,暂时还不能评论%@的微博",str]];
}

@end
