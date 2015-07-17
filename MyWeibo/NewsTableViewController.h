//
//  NewsTableViewController.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewController : UITableViewController
@property (assign, nonatomic)NSInteger count;
@property (strong, nonatomic)UIRefreshControl *aRefreshController;
@end
