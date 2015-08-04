//
//  NewTableViewCellMethod.m
//  MyWeibo
//
//  Created by 马遥 on 15/8/4.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "NewTableViewCellMethod.h"

@implementation NewTableViewCellMethod

- (UserType)userTypeOfNews{
    if ([self.news.user_id isEqualToString:[PersonalModel personalIDfromUserDefaults]]) {
        return UserTypePersonal;
    }
    return UserTypeFans;
}
- (void)dismissCell:(NewTableViewCell *)cell fromTableView:(UITableView *)tableView{
    [UIView animateWithDuration:0.3 animations:^{
        cell.myMarkView.alpha = 0;
    }];
    tableView.scrollEnabled = YES;
}
- (void)didSelectButton:(UIButton *)button atCell:(UITableViewCell *)cell fromTableView:(UITableView *)tableView{
    tableView.scrollEnabled = NO;
}

- (void)didSelectedItem:(NSString *)item fromCell:(NewTableViewCell *)cell{
    if (cell.userType == UserTypePersonal) {
        if ([item isEqualToString:@"删除"]) {
            [self deleteNewsFromNewTableViewCell:cell withUserType:UserTypePersonal];
            //            [SVProgressHUD showSuccessWithStatus:@"这条是我表弟刚才写的\n←_←"];
            
        }else if ([item isEqualToString:@"收藏"]){
            [SVProgressHUD showSuccessWithStatus:@"我说的真有道理\n（￣▽￣）"];
            
        }else if ([item isEqualToString:@"置顶"]){
            [SVProgressHUD showSuccessWithStatus:@"给我去最上面\n(╯°口°)╯"];
            
        }else if ([item isEqualToString:@"推广"]){
            [SVProgressHUD showSuccessWithStatus:@"(一条五毛,括号删掉)\n(^・ω・^ )"];
            
        }
        
    }else if (cell.userType == UserTypeFans){
        if ([item isEqualToString:@"屏蔽"]) {
            [self deleteNewsFromNewTableViewCell:cell withUserType:UserTypeFans];
            
        }else if ([item isEqualToString:@"收藏"]){
            [SVProgressHUD showSuccessWithStatus:@"这条微博我承包了\n(｀・ω・´)"];
            
        }else if ([item isEqualToString:@"帮上头条"]){
            [SVProgressHUD showSuccessWithStatus:@"我只能帮你到这儿了\n(￣3￣)"];
            
        }else if ([item isEqualToString:@"取消关注"]){
            [self cancelAttention];
            //            [SVProgressHUD showSuccessWithStatus:@"别让我再看见你\n(￣ε(#￣) Σ"];
            
        }else if ([item isEqualToString:@"举报"]){
            [SVProgressHUD showSuccessWithStatus:@"警察叔叔就是这个人\nΣ(ﾟдﾟ;)"];
        }
    }
}

- (void)deleteNewsFromNewTableViewCell:(NewTableViewCell *)cell withUserType:(UserType)userType{
    NSString *message;
    NSString *cancel;
    NSString *done;
    if (userType == UserTypeFans) {
        message = @"你确定不想看见这条微博吗?";
        cancel = @"确定";
        done = @"肯定";
    }else if (userType == UserTypePersonal){
        message = @"你真的要否认你刚才说的话吗?";
        cancel = @"不是这样的";
        done = @"我开玩笑的";
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:done, nil];
    [alertView show];
}

- (void)cancelAttention{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"真的不想再看见这个人?" delegate:self cancelButtonTitle:@"不是的!" otherButtonTitles:@"嗯,是的", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"] || [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"肯定"]) {
        if ([self.delegate newsDidSelect] == nil) {
        }else{
            [SVProgressHUD showSuccessWithStatus:@"我不听我不听我不听\nヽ(｀ Д ´ )ﾉ"];
            [self.delegate deleteNewFromTable];
        }
    }else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"不是这样的"] || [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"我开玩笑的"]){
        [SVProgressHUD showErrorWithStatus:@"那就不删除了\n(=・ω・=)"];
    }else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"不是的!"]){
        [SVProgressHUD showErrorWithStatus:@"那就再给你一次机会\n（￣へ￣）"];
    }else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"嗯,是的"]){
        [SVProgressHUD showErrorWithStatus:@"然而并没有这个功能\n_(:3」∠)_"];
    }
}



@end
