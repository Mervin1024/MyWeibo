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

@interface NewsTableViewController ()<NewsDetailViewControllerDelegate,UIAlertViewDelegate>{
    NSMutableArray *tableData;
    NSInteger sizeOfRefresh;
    DBManager *dbManager;
    NewsModel *newsWillDelete;
    NSInteger mark;
    float to;
    float from;
}

@end

@implementation NewsTableViewController
@synthesize count;
@synthesize aRefreshController;

#pragma mark - view 视图初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValue];
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
    if (mark == 0) {
        [SVProgressHUD showWithStatus:@"正在加载。。"];
        [self performSelector:@selector(setTableData) withObject:nil afterDelay:0.5];
        mark = 1;
    }
    
}
#pragma mark - 读取数据库
- (void) initValue{
    dbManager = [MyWeiboData sharedManager].dbManager;
    tableData = [NSMutableArray array];
    sizeOfRefresh = 10;
    self.count = 0;
    mark = 0;
    from = 0;
    to = 0;
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
    
    [tableData addObjectsFromArray:[NewsModel arrayBySelectedWhere:nil from:from to:to]];
    [SVProgressHUD dismiss];
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
        if ([NewsModel countOfNews] > to) {
            dispatch_async(dispatch_get_main_queue(), ^{
                aRefreshController.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新成功"];
                [self setTableData];
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
    [self performSelector:@selector(changeRefreshingTitle) withObject:nil afterDelay:0.5];
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
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return TABLE_CONTENT_MARGIN;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return TABLE_CONTENT_MARGIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row  == 0) {
        // 计算 cell 高度
        long index = tableData.count -1- indexPath.section;
        NewsModel *new = tableData[index];
        CGFloat width = TABLE_CELL_CONTENT_WIDTH-CELL_CONTENT_MARGIN*2;
        return [NewTableViewCell heighForRowWithCellContentWidth:width Style:NewsStyleOfList model:new];
    }else{
        return 30.0f;
    }

}
#pragma mark - NewTableView 协议方法
- (CGRect)frameOfSuperView{
    CGRect frame = self.view.frame;
    frame.origin = self.tableView.contentOffset;
    return frame;
}

- (UserType)userTypeOfNewTableViewCell:(NewTableViewCell *)cell{
    NewsModel *news = [self newsModelOfCell:cell fromTableView:self.tableView];
    if ([news.user_id isEqualToString:[PersonalModel personalIDfromUserDefaults]]) {
        return UserTypePersonal;
    }
    return UserTypeFans;
}

- (void)newTableViewCell:(NewTableViewCell *)cell didSelectButton:(UIButton *)button{
    self.tableView.scrollEnabled = NO;
}

- (void)dismissFromNewTableViewCell:(NewTableViewCell *)cell{
    [cell.dropDown removeFromSuperview];
    [cell.myMarkView removeFromSuperview];
    self.tableView.scrollEnabled = YES;
}

- (void)didSelectedItem:(NSString *)item FromTableViewCell:(NewTableViewCell *)cell{
    if (cell.userType == UserTypePersonal) {
        if ([item isEqualToString:@"删除"]) {
            [self deleteNewsFromNewTableViewCell:cell withUserType:UserTypePersonal];
//            [SVProgressHUD showSuccessWithStatus:@"这条是我表弟刚才写的\n←_←"];

        }else if ([item isEqualToString:@"收藏"]){
            [SVProgressHUD showSuccessWithStatus:@"我说的真有道理\n（￣▽￣）"];

        }else if ([item isEqualToString:@"置顶"]){
            [SVProgressHUD showSuccessWithStatus:@"给我去最上面\n(╯°口°)╯"];
            
        }else if ([item isEqualToString:@"推广"]){
            [SVProgressHUD showSuccessWithStatus:@"(一条五毛,括号删掉)\n(^・ω・^ )"];
            
        }

    }else if (cell.userType == UserTypeFans){
        if ([item isEqualToString:@"屏蔽"]) {
            [self deleteNewsFromNewTableViewCell:cell withUserType:UserTypeFans];
            
        }else if ([item isEqualToString:@"收藏"]){
            [SVProgressHUD showSuccessWithStatus:@"这条微博我承包了\n(｀・ω・´)"];
            
        }else if ([item isEqualToString:@"帮上头条"]){
            [SVProgressHUD showSuccessWithStatus:@"我只能帮你到这儿了\n(￣3￣)"];
            
        }else if ([item isEqualToString:@"取消关注"]){
            [self cancelAttention];
//            [SVProgressHUD showSuccessWithStatus:@"别让我再看见你\n(￣ε(#￣) Σ"];
            
        }else if ([item isEqualToString:@"举报"]){
            [SVProgressHUD showSuccessWithStatus:@"警察叔叔就是这个人\nΣ(ﾟдﾟ;)"];
        }
    }
}

- (void)deleteNewsFromNewTableViewCell:(NewTableViewCell *)cell withUserType:(UserType)userType{
    NSString *message;
    NSString *cancel;
    NSString *done;
    if (userType == UserTypeFans) {
        message = @"你确定不想看见这条微博吗?";
        cancel = @"确定";
        done = @"肯定";
    }else if (userType == UserTypePersonal){
        message = @"你真的要否认你刚才说的话吗?";
        cancel = @"不是这样的";
        done = @"我开玩笑的";
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:done, nil];
    [alertView show];
    
    newsWillDelete = [self newsModelOfCell:cell fromTableView:self.tableView];
    
}

- (void)cancelAttention{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"真的不想再看见这个人?" delegate:self cancelButtonTitle:@"不是的!" otherButtonTitles:@"嗯,是的", nil];
    [alertView show];
}

- (NewsModel *)newsModelOfCell:(NewTableViewCell *)cell fromTableView:(UITableView *)tableView{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    long index = tableData.count - 1 - indexPath.section;
    NewsModel *news = tableData[index];
    return news;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"] || [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"肯定"]) {
        if (newsWillDelete == nil) {
        }else{
            [SVProgressHUD showSuccessWithStatus:@"我不听我不听我不听\nヽ(｀ Д ´ )ﾉ"];
            [tableData removeObject:newsWillDelete];
            [newsWillDelete deleteNewFromTable];
            [self.tableView reloadData];
        }
    }else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"不是这样的"] || [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"我开玩笑的"]){
        [SVProgressHUD showErrorWithStatus:@"我还不想删除\n(=・ω・=)"];
    }else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"不是的!"]){
        [SVProgressHUD showErrorWithStatus:@"那就再给你一次机会\n（￣へ￣）"];
    }else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"嗯,是的"]){
        [SVProgressHUD showErrorWithStatus:@"然而并没有这个功能\n_(:3」∠)_"];
    }
}
#pragma mark - NewsDetailViewController 协议方法

- (void)deleteNews:(NewsModel *)newsModel{
    [tableData removeObject:newsModel];
    [newsModel deleteNewFromTable];
    [self.tableView reloadData];
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
    NSDictionary *dic = [notification userInfo];
    if (dic != nil) {
        NewsModel *newsModel = [dic objectForKey:@"news"];
        [newsModel insertItemToTable];
        [self setTableData];
        [self.tableView reloadData];
    }
}

#pragma mark - cell 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        long index = tableData.count -1- indexPath.section;
        NewsModel *news = tableData[index];
        
        [self performSegueWithIdentifier:@"ShowDetails" sender:news];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

@end
