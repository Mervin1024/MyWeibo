//
//  NewTableViewCellMethod.h
//  MyWeibo
//
//  Created by 马遥 on 15/8/4.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "CellMethod.h"
#import "NewTableViewCell.h"
@class NewTableViewCellMethod;
@protocol NewTableViewCellMethodDelegate <NSObject>

//- (void)deleteNewsFromNewTableViewCell:(NewTableViewCell *)cell withUserType:(UserType)userType;
//- (void)cancelAttention;
- (void)deleteNewFromTable;
- (NewsModel *)newsDidSelect;
@end
@interface NewTableViewCellMethod : CellMethod<UIAlertViewDelegate>

- (UserType)userTypeOfNews;
- (void)dismissCell:(NewTableViewCell *)cell fromTableView:(UITableView *)tableView;
- (void)didSelectedItem:(NSString *)item fromCell:(NewTableViewCell *)cell;
- (void)didSelectButton:(UIButton *)button atCell:(UITableViewCell *)cell fromTableView:(UITableView *)tableView;
//- (UIAlertView *)alertViewWithdeleteItemUserType:(UserType)userType fromCell:(NewTableViewCell *)cell;
//- (UIAlertView *)alertViewWithCancelAttention;

@property (weak, nonatomic) id<NewTableViewCellMethodDelegate> delegate;
@end
