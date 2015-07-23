//
//  NewsTableViewController.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TABLE_CONTENT_MARGIN 10.0f

@interface NewsTableViewController : UITableViewController

@property (assign, nonatomic)NSInteger count;
@property (strong, nonatomic)UIRefreshControl *aRefreshController;
@end
