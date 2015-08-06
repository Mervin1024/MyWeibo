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
#import "DBManager.h"
#import "MyWeiboData.h"
#import "NewsModel.h"
#import "InitialNews.h"
#import "DocumentAccess.h"
#import "UIImage+ImageFrame.h"
#import "UILabel+StringFrame.h"
#import "CommentCell.h"
#import "PersonalModel.h"
#import "SVProgressHUD.h"
#import "AddNewsViewController.h"
#import "CommentCellMethod.h"
#import "NewTableViewCellMethod.h"
#import "NSArray+Assemble.h"

#define TABLE_CONTENT_MARGIN 10.0f
#define TABLE_CELL_CONTENT_WIDTH (self.view.frame.size.width)


@interface NewsTableViewController : UITableViewController<NewTableViewCellDelegate>

@property (assign, nonatomic)NSInteger count;
@property (strong, nonatomic)UIRefreshControl *aRefreshController;
- (IBAction)dynamicStateButton:(id)sender;
- (IBAction)scanningButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *dynamicStateButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *scanningButton;
@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) PersonalModel *personalModel;
@end
