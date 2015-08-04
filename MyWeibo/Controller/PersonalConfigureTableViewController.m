//
//  PersonalConfigureTableViewController.m
//  MyWeibo
//
//  Created by 马遥 on 15/8/4.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "PersonalConfigureTableViewController.h"
#import "PersonalModel.h"

@interface PersonalConfigureTableViewController (){
    PersonalModel *personalModel;
}

@end

@implementation PersonalConfigureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    personalModel = [[PersonalModel alloc]initWithUserDefaults];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 13;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfigureCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ConfigureCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    long section = indexPath.section;
    long row = indexPath.row;
    NSString *text = nil;
    NSString *detailText = nil;
    UIImage *image = nil;
    // 设置textlabel,imageView
    switch (section) {
        case 0:
            switch (row) {
                case 0:
                    
                    break;
                    
                case 1:
                    cell.accessoryType = UITableViewCellAccessoryNone;
                default:
                    break;
            }
            break;
        case 1:
            switch (row) {
                case 0:
                    text = @"新的好友";
                    break;
                case 1:
                    text = @"微博等级";
                    detailText = @"Lv13";
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (row) {
                case 0:
                    text = @"我的相册";
                    detailText = [NSString stringWithFormat:@"(%ld)",personalModel.images.count];
                    break;
                case 1:
                    text = @"我的点评";
                    break;
                case 2:
                    text = @"我的赞";
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (row) {
                case 0:
                    text = @"微博支付";
                    break;
                case 1:
                    text = @"微博运动";
                    break;
                case 2:
                    text = @"微博会员";
                    break;
                default:
                    break;
            }
            break;
        case 4:
            switch (row) {
                case 0:
                    text = @"草稿箱";
                    break;
                    
                default:
                    break;
            }
            break;
        case 5:
            switch (row) {
                case 0:
                    text = @"更多";
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = detailText;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.imageView.image = image;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
