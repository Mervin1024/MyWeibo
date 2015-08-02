//
//  NewsTableViewController.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTableViewCell.h"
#define TABLE_CONTENT_MARGIN 10.0f
#define TABLE_CELL_CONTENT_WIDTH (self.view.frame.size.width)


@interface NewsTableViewController : UITableViewController<NewTableViewCellDelegate,DropDownViewDelegate>

@property (assign, nonatomic)NSInteger count;
@property (strong, nonatomic)UIRefreshControl *aRefreshController;
@end
