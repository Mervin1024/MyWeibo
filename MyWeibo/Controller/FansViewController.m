//
//  FansViewController.m
//  MyWeibo
//
//  Created by 马遥 on 15/8/6.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "FansViewController.h"
#import "UsersDetailTableViewCell.h"
#import "DocumentAccess.h"
#import "NewsTableViewController.h"

@interface FansViewController ()

@end

@implementation FansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.personalModel.fans.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"1");
    UsersDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UsersDetailTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UsersDetailTableViewCell" owner:self options:nil] lastObject];
    }
    long row = indexPath.row;
    //    NSLog(@"%ld",row);
    UserModel *user = self.personalModel.fans[row];
    //    NSLog(@"%@",user.user_ID);
    if (user.name == nil) {
        cell.userTextLabel.text = user.user_ID;
    }
    cell.userTextLabel.text = user.name;
    cell.userDetailTextLabel.text = user.desc;
    cell.userImageView.image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:user.avatar]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return TABLE_CONTENT_MARGIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return TABLE_CONTENT_MARGIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
