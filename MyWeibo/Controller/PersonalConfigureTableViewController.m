//
//  PersonalConfigureTableViewController.m
//  MyWeibo
//
//  Created by 马遥 on 15/8/4.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "PersonalConfigureTableViewController.h"
#import "PersonalModel.h"
#import "DocumentAccess.h"
#import "ConfigureDetailViewController.h"

@interface PersonalConfigureTableViewController (){
    PersonalModel *personalModel;
}

@end

@implementation PersonalConfigureTableViewController
@synthesize personalAvatar,personalName,personalDesc;
@synthesize attentionButton,microblogButton,fansButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    personalModel = [[PersonalModel alloc]initWithUserDefaults];
    [self setValue];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setValue{
    personalAvatar.image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:personalModel.avatar]];
    NSString *str = personalModel.user_ID;
    if (personalModel.name == nil) {
        
    }else{
        str = personalModel.name;
    }
    personalName.text = str;
    personalDesc.text = [NSString stringWithFormat:@"简介:%@",personalModel.desc];
//    if (personalModel.news.count != 0) {
    [microblogButton setTitle:[NSString stringWithFormat:@"%ld\n微博",personalModel.news.count] forState:UIControlStateNormal];
    
//    }
//    if (personalModel.attentions.count != 0) {
    [attentionButton setTitle:[NSString stringWithFormat:@"%ld\n关注",personalModel.attentions.count] forState:UIControlStateNormal];
//    }
//    if (personalModel.fans.count != 0) {
    [fansButton setTitle:[NSString stringWithFormat:@"%ld\n粉丝",personalModel.fans.count] forState:UIControlStateNormal];
//    }
    
    [self.tableView reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 77;
        }else if (indexPath.row == 1){
            return 55;
        }
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    long section = indexPath.section;
    long row = indexPath.row;
    ConfigureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfigureTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConfigureTableViewCell" owner:self options:nil] lastObject];
    }
    if (section == 1 && row == 1) {
        cell.configureTextLabel.text = @"微博等级";
        cell.configureDetailTextLabel.text = [NSString stringWithFormat:@"Lv%ld",(long)personalModel.level];
        return cell;
    }else if (section == 2 && row == 0){
        cell.configureTextLabel.text = @"我的相册";
        NSString *str = @"";
        if (personalModel.images.count != 0) {
            str = [NSString stringWithFormat:@"(%ld)",personalModel.images.count];
        }
        cell.configureDetailTextLabel.text = str;
        return cell;
    }else if (section == 2 && row == 2){
        cell.configureTextLabel.text = @"我的赞";
        NSString *str = @"";
        if (personalModel.praise.count != 0) {
            str = [NSString stringWithFormat:@"(%ld)",personalModel.praise.count];
        }
        cell.configureDetailTextLabel.text = str;
        return cell;
    }
    else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)microblog:(id)sender {
//    [self performSegueWithIdentifier:@"Microblog" sender:nil];
}

- (IBAction)attention:(id)sender {
//    [self performSegueWithIdentifier:@"Attention" sender:nil];
}

- (IBAction)fans:(id)sender {
//    [self performSegueWithIdentifier:@"Fans" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Microblog"]) {
        ConfigureDetailViewController *controller = segue.destinationViewController;
        controller.checkedButtonType = CheckedButtonTypeMicroblog;
        controller.personalModel = personalModel;
    }else if ([segue.identifier isEqualToString:@"Attention"]){
        ConfigureDetailViewController *controller = segue.destinationViewController;
        controller.checkedButtonType = CheckedButtonTypeAttention;
        controller.personalModel = personalModel;
    }else if ([segue.identifier isEqualToString:@"Fans"]){
        ConfigureDetailViewController *controller = segue.destinationViewController;
        controller.checkedButtonType = CheckedButtonTypeFans;
        controller.personalModel = personalModel;
    }
}
@end
