//
//  NewsDetailViewController.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/14.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "NewsTableViewController.h"

@interface NewsDetailViewController : UITableViewController<NewTableViewCellDelegate>
@property (strong, nonatomic) NewsModel *newsModel;
@end
