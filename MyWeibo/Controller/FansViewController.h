//
//  FansViewController.h
//  MyWeibo
//
//  Created by 马遥 on 15/8/6.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalModel.h"

@interface FansViewController : UITableViewController
@property (strong, nonatomic) PersonalModel *personalModel;
- (IBAction)backButton:(id)sender;

@end
