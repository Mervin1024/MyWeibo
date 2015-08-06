//
//  ConfigureDetailViewController.h
//  MyWeibo
//
//  Created by 马遥 on 15/8/6.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalConfigureTableViewController.h"
#import "PersonalModel.h"
#import "UserModel.h"
#import "NewsTableViewController.h"
#import "UsersDetailTableViewCell.h"

@interface AttentionsViewController : UITableViewController
@property (strong, nonatomic) PersonalModel *personalModel;
- (IBAction)backButton:(id)sender;

@end
