//
//  NewsTableViewController.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewTableViewCell.h"
#import "DBManager.h"
#import "MyWeiboData.h"
#import "NewsModel.h"
#import "InitialNews.h"
#import "DocumentAccess.h"
#import "UIImage+ImageFrame.h"
#import "UILabel+StringFrame.h"
#import "NewsDetailViewController.h"
#import "CommentCell.h"

@interface NewsTableViewController (){
    NSMutableArray *tableData;
    NSInteger sizeOfRefresh;
    DBManager *dbManager;
    NewsModel *newsModel;
}

@end

@implementation NewsTableViewController
@synthesize count;
@synthesize aRefreshController;

#pragma mark - view 视图初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValue];
    [self initDB];
    [self setTableData];
    [self setRefreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"contentSize:%@",NSStringFromCGSize(self.tableView.contentSize));
}
#pragma mark - 读取数据库
- (void) initValue{
    dbManager = [MyWeiboData sharedManager].dbManager;
    tableData = [NSMutableArray array];
    sizeOfRefresh = 10;
    self.count = 0;
}

- (void) initDB{
    [NewsModel creatTableFromSql];
    // 添加虚拟数据
    [InitialNews insertUserModel];
    [InitialNews insertNewsModel];
}

- (void) setTableData{
    self.count = tableData.count;

    [tableData addObjectsFromArray:[NewsModel arrayBySelectedWhere:nil from:self.count to:self.count+sizeOfRefresh]];

}
#pragma mark - 添加下拉刷新控件 UIRefreshControl
- (void) setRefreshControl{
    aRefreshController = [[UIRefreshControl alloc]init];
    [self changeRefreshingTitle];
    [aRefreshController addTarget:self action:@selector(refreshControlWillRefreshing) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:aRefreshController];
}

- (void) refreshControlWillRefreshing{
    if (aRefreshController.refreshing) {
        aRefreshController.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中..."];
        [self performSelector:@selector(refreshControlDidRefreshing) withObject:nil afterDelay:0.5];
    }
}

- (void) refreshControlDidRefreshing{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setTableData];
        if (tableData.count > self.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                aRefreshController.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新成功"];
                [self.tableView reloadData];
                [self performSelector:@selector(didFinishRefreshing) withObject:nil afterDelay:0.5];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                aRefreshController.attributedTitle = [[NSAttributedString alloc]initWithString:@"已经是最新了"];
                [self performSelector:@selector(didFinishRefreshing) withObject:nil afterDelay:0.5];
            });
        }
    });
}

- (void) didFinishRefreshing{
    [aRefreshController endRefreshing];
    [self performSelector:@selector(changeRefreshingTitle) withObject:nil afterDelay:1];
}

- (void) changeRefreshingTitle{
    aRefreshController.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
}

#pragma mark - Table view data source 协议

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row  == 0) {
        NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NewCell" owner:self options:nil] lastObject];
        }
        // 数据逆向显示
        long index = tableData.count -1- indexPath.section;
        
        NewsModel *new = tableData[index];
        
        cell.avatar.image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:new.user.avatar]];
        cell.weibo.text = new.news_text;
        cell.description.text = [new.user.desc stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)index]];
        if (new.user.name) {
            cell.name.text = new.user.name;
        }else{
            cell.name.text = new.user.user_ID;
        }
        // 动态加载 imageview
        NSMutableArray *imageViews = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            CGFloat floatX = CELL_CONTENT_MARGIN * (i+1) + CELL_IMAGE_HIGHT * i;
            CGFloat floatY = CELL_CONTENT_MARGIN * 3 + CELL_AVATAR_HIGHT+[cell.weibo boundingRectWithSize:CGSizeMake(CELL_TEXT_WIDTH, 0)].height;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(floatX, floatY, CELL_IMAGE_HIGHT, CELL_IMAGE_HIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = self;
            [imageViews addObject:imageView];
            [cell.contentView addSubview:imageView];
        }
        cell.weiboImages = [NSArray arrayWithArray:imageViews];
        [cell setImages:new.images withStyle:NewsStyleOfList];
        return cell;
    }else{
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLE_CONTENT_MARGIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row  == 0) {
        // 计算 cell 高度
        long index = tableData.count -1- indexPath.section;
        NewsModel *new = tableData[index];
        
        return [NewTableViewCell heighForRowWithStyle:NewsStyleOfList model:new];
    }else{
        return 30.0f;
    }

}
#pragma mark - cell 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        long index = tableData.count -1- indexPath.section;
        NewsModel *news = tableData[index];
        
        [self performSegueWithIdentifier:@"ShowDetails" sender:news];
    }
    
}
#pragma mark - segue 跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowDetails"]) {
        NewsDetailViewController *controller = segue.destinationViewController;
        controller.hidesBottomBarWhenPushed = YES;
        controller.newsModel = sender;
    }
}

@end
