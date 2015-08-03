//
//  NewsTableViewController.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTableViewCell.h"
#import "NewsDetailViewController.h"
#define TABLE_CONTENT_MARGIN 10.0f
#define TABLE_CELL_CONTENT_WIDTH (self.view.frame.size.width)


@interface NewsTableViewController : UITableViewController<NewTableViewCellDelegate>

@property (assign, nonatomic)NSInteger count;
@property (strong, nonatomic)UIRefreshControl *aRefreshController;
- (IBAction)dynamicStateButton:(id)sender;
- (IBAction)scanningButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *dynamicStateButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *scanningButton;
@end
