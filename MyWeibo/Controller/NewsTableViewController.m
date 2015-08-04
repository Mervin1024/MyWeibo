//
//  NewsTableViewController.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "NewsTableViewController.h"
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

@interface NewsTableViewController ()<NewsDetailViewControllerDelegate,UIAlertViewDelegate,CommentCellDelegate,NewTableViewCellMethodDelegate>{
    NSMutableArray *tableData;
    BOOL haveData;              // 是否有数据,默认YES
    NSInteger sizeOfRefresh;    // 每次更新数据条目
    DBManager *dbManager;
    NewsModel *newsDidSelect;   // 拓展按钮选中的item
    BOOL isReload;             // 是否更新数据
    float to;
    float from;
    
    NewTableViewCellMethod *newTableViewCellMethod;
}

@end

@implementation NewsTableViewController
@synthesize count,scanningButton,dynamicStateButton;
@synthesize aRefreshController;

#pragma mark - view 视图初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValue];
    [self initView];
    [self setRefreshControl];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishPublish:) name:@"AddNewsNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.tabBarController.tabBar.hidden == YES) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 加载数据
    if (isReload == YES) {
        [SVProgressHUD showWithStatus:@"正在加载。。"];
        [self performSelector:@selector(setTableData) withObject:nil afterDelay:0.5];
        isReload = NO;
    }
    
}

// 添加navigationItemBarButton
- (void)initView{
    dynamicStateButton.title = nil;
    UIImage *dynamicStateImage = [UIImage imageNamed:@"noDynamicState"];
    dynamicStateButton.image = [UIImage imageWithCGImage:dynamicStateImage.CGImage scale:(dynamicStateImage.scale*3) orientation:dynamicStateImage.imageOrientation];
    
    scanningButton.title = nil;
    UIImage *scanningImage = [UIImage imageNamed:@"scanning"];
    scanningButton.image = [UIImage imageWithCGImage:scanningImage.CGImage scale:(scanningImage.scale*3) orientation:scanningImage.imageOrientation];
}

#pragma mark - 读取数据库
- (void) initValue{
    dbManager = [MyWeiboData sharedManager].dbManager;
    tableData = [NSMutableArray array];
    sizeOfRefresh = 10;
    self.count = 0;
    isReload = YES;
    from = 0;
    to = 0;
    haveData = YES;
}

- (void) initDB{
    [NewsModel creatTableFromSql];
    // 添加虚拟数据
    [InitialNews insertUserModel];
    [InitialNews insertNewsModel];
    [InitialNews savePersonalInformation];
}

- (void) setTableData{
    if ([NewsModel countOfNews] == 0) {
        [self initDB];
    }
    from = to;
    to = [NewsModel countOfNews];
    if ((to - from)<= sizeOfRefresh) {
    }else{
        tableData = [NSMutableArray array];
        from = to - sizeOfRefresh;
    }
    NSArray *reloadData = [NewsModel arrayBySelectedWhere:nil from:from to:to];
    [tableData addObjectsFromArray:reloadData];
    
    if (tableData.count == 0) {
        haveData = NO;
        [SVProgressHUD dismiss];
    }else{
        
        haveData = YES;
        NSString *str = @"已经是最新了";
        if (reloadData.count != 0) {
            str = [NSString stringWithFormat:@"%ld条新微博",reloadData.count];
        }
        [SVProgressHUD showSuccessWithStatus:str];
    }
//    [SVProgressHUD dismiss];
    [self.tableView reloadData];

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
        dispatch_async(dispatch_get_main_queue(), ^{
//                aRefreshController.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新成功"];
            [self setTableData];
            [self performSelector:@selector(didFinishRefreshing) withObject:nil afterDelay:0.5];
        });
    });
}

- (void) didFinishRefreshing{
    [aRefreshController endRefreshing];
    [self performSelector:@selector(changeRefreshingTitle) withObject:nil afterDelay:0.5];
}

- (void) changeRefreshingTitle{
    aRefreshController.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
}

#pragma mark - Table view data source 协议

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (haveData == NO) {
        return 1;
    }else{
        return tableData.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (haveData == NO) {
        return 1;
    }else{
        return 2;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (haveData == NO) {
        // 无数据时的cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoDataCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoDataCell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        self.tableView.userInteractionEnabled = NO;
        cell.userInteractionEnabled = NO;
        
        return cell;
    }else{
        self.tableView.userInteractionEnabled = YES;
        if (indexPath.row  == 0) {
            NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NewCell" owner:self options:nil] lastObject];
            }
            cell.delegate = self;
            
            // 数据逆向显示
            long index = tableData.count -1- indexPath.section;
            
            NewsModel *new = tableData[index];
            
            cell.avatar.image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:new.user.avatar]];
            cell.weibo.text = new.news_text;
            cell.desc.text = [new.user.desc stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)index]];
            if (new.user.name) {
                cell.name.text = new.user.name;
            }else{
                cell.name.text = new.user.user_ID;
            }
            // 动态加载 imageview
            [self tableViewCell:(NewTableViewCell *)cell setImages:new.imagesName withStyle:NewsStyleOfList];
            //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil]lastObject];
            }
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            return cell;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && haveData == YES) {
        return TABLE_CONTENT_MARGIN;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return TABLE_CONTENT_MARGIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row  == 0 && haveData == YES) {
        // 计算 cell 高度
        long index = tableData.count -1- indexPath.section;
        NewsModel *new = tableData[index];
        CGFloat width = TABLE_CELL_CONTENT_WIDTH-CELL_CONTENT_MARGIN*2;
        return [NewTableViewCell heighForRowWithCellContentWidth:width Style:NewsStyleOfList model:new];
    }else if (haveData == NO){
        return 200;
    }else{
        return 30.0f;
    }

}

#pragma mark - cell 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && haveData == YES) {
        long index = tableData.count -1- indexPath.section;
        NewsModel *news = tableData[index];
        
        [self performSegueWithIdentifier:@"ShowDetails" sender:news];
    }
    
}
#pragma mark - NewTableView 协议方法
- (NewsModel *)newsModelOfCell:(UITableViewCell *)cell fromTableView:(UITableView *)tableView{
    // 通过Cell求出index
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    long index = tableData.count - 1 - indexPath.section;
    NewsModel *news = tableData[index];
    return news;
}

- (CGRect)frameOfSuperView{
    CGRect frame = self.view.frame;
    frame.origin = self.tableView.contentOffset;
    return frame;
}

- (UserType)userTypeOfNewTableViewCell:(NewTableViewCell *)cell{
    NewsModel *news = [self newsModelOfCell:cell fromTableView:self.tableView];
    newTableViewCellMethod = [[NewTableViewCellMethod alloc]initWithNewsModel:news];
    newTableViewCellMethod.delegate = self;
    newsDidSelect = [self newsModelOfCell:cell fromTableView:self.tableView];
    return [newTableViewCellMethod userTypeOfNews];
}

- (void)newTableViewCell:(NewTableViewCell *)cell didSelectButton:(UIButton *)button{
    // 点击拓展按钮
    [newTableViewCellMethod didSelectButton:button atCell:cell fromTableView:self.tableView];
}

- (void)dismissFromNewTableViewCell:(NewTableViewCell *)cell{
    // 关闭菜单界面
    [newTableViewCellMethod dismissCell:cell fromTableView:self.tableView];
}

- (void)didSelectedItem:(NSString *)item fromTableViewCell:(NewTableViewCell *)cell{
    // 选择菜单界面
    [newTableViewCellMethod didSelectedItem:item fromCell:cell];
}
#pragma mark - NewTableViewCellMethod 协议方法

- (void)deleteNewFromTable{
    // 删除数据
    [self deleteNews:newsDidSelect];
}

- (NewsModel *)newsDidSelect{
    // 拓展按钮所在的数据
    return newsDidSelect;
}

#pragma mark - NewsDetailViewController 协议方法

- (void)deleteNews:(NewsModel *)newsModel{
    [tableData removeObject:newsModel];
    [newsModel deleteNewFromTable];
    [self.tableView reloadData];
}

#pragma mark - CommentCell 协议方法
- (void)commentCell:(CommentCell *)cell Comment:(id)sender{
    
    NewsModel *news = [self newsModelOfCell:cell fromTableView:self.tableView];
    CommentCellMethod *commentMethod = [[CommentCellMethod alloc]initWithNewsModel:news];
    [commentMethod Comment];
}

- (void)commentCell:(CommentCell *)cell forward:(id)sender{
    CommentCellMethod *commentMethod = [[CommentCellMethod alloc]initWithNewsModel:nil];
    [commentMethod forward];
}

- (void)commentCell:(CommentCell *)cell Praise:(id)sender{
    NewsModel *news = [self newsModelOfCell:cell fromTableView:self.tableView];
    CommentCellMethod *commentMethod = [[CommentCellMethod alloc]initWithNewsModel:news];
    [commentMethod Praise];
}

#pragma mark - 动态加载 imageview
- (void)tableViewCell:(NewTableViewCell *)cell setImages:(NSArray *)images withStyle:(NewsStyle)newsStyle
{
    CGFloat imageWidth = [cell imageWidthAtBlankViewWithCellContentWidth:TABLE_CELL_CONTENT_WIDTH-CELL_CONTENT_MARGIN*2 Images:images style:newsStyle];
    if (imageWidth != 0) {
        
        for (int i = 0; i < images.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            if (images.count == 4) {
                imageView.frame = CGRectMake((i%2)*(imageWidth+CELL_BLANKVIEW_MARGIN)+CELL_BLANKVIEW_MARGIN, (i/2)*(imageWidth+CELL_BLANKVIEW_MARGIN)+CELL_BLANKVIEW_MARGIN, imageWidth, imageWidth);
            }else{
                imageView.frame = CGRectMake((i%3)*(imageWidth+CELL_BLANKVIEW_MARGIN)+CELL_BLANKVIEW_MARGIN, (i/3)*(imageWidth+CELL_BLANKVIEW_MARGIN)+CELL_BLANKVIEW_MARGIN, imageWidth, imageWidth);
            }
            imageView.image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:images[i]]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [cell.blankView addSubview:imageView];
        }
    }
}

#pragma mark - AddNewsNotification 方法
- (void)didFinishPublish:(NSNotification *)notification{
    // 实现发布动态
    NSDictionary *dic = [notification userInfo];
    if (dic != nil) {
        NewsModel *newsModel = [dic objectForKey:@"news"];
        [newsModel insertItemToTable];
        [self setTableData];
        [self.tableView reloadData];
    }
}

#pragma mark - segue 跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowDetails"]) {
        NewsDetailViewController *controller = segue.destinationViewController;
        controller.hidesBottomBarWhenPushed = YES;
        controller.newsModel = sender;
        controller.delegate = self;
    }
}
#pragma mark - navigationItemBarButton
- (IBAction)dynamicStateButton:(id)sender {
    
}

- (IBAction)scanningButton:(id)sender {
}
@end
