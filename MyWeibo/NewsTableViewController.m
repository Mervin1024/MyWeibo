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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValue];
    [self initDB];
    [self setTableData];
    [self setRefreshControl];
}

- (void) initValue{
    dbManager = [MyWeiboData sharedManager].dbManager;
    tableData = [NSMutableArray array];
    sizeOfRefresh = 10;
    self.count = 0;
}

- (void) initDB{
    [NewsModel creatTableFromSql];
    [InitialNews insertUserModel];
    [InitialNews insertNewsModel];
}

- (void) setTableData{
    self.count = tableData.count;
//    NSLog(@"count1:%ld,count2:%ld",(long)self.count,self.count+sizeOfRefresh);
    [tableData addObjectsFromArray:[NewsModel arrayBySelectedWhere:nil from:self.count to:self.count+sizeOfRefresh]];
    
//    NSLog(@"count3:%ld",tableData.count);
}

- (void) setRefreshControl{
//    self.refreshControl = [[UIRefreshControl alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
////    NSLog(@"section:%ld",tableData.count);
//    return tableData.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    return tableData.count;
    return tableData.count*3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row %3 == 1) {
        NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NewCell" owner:self options:nil] lastObject];
        }
        long index = tableData.count -1- indexPath.row/3;
//         NSLog(@"indexPath.section:%ld  index:%ld",indexPath.section,index);
        NewsModel *new = tableData[index];
        
        cell.avatar.image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:new.user.avatar]];
        cell.weibo.text = new.news_text;
        cell.description.text = [new.user.desc stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)index]];
        if (new.user.name) {
            cell.name.text = new.user.name;
        }else{
            cell.name.text = new.user.user_ID;
        }
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
    }else if (indexPath.row %3 == 2){
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"grey"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"grey"];
        }
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0;
//    }else{
        return 0;
//    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row %3 == 1) {
        long index = tableData.count -1- indexPath.row/3;
        NewsModel *new = tableData[index];
        
        return [NewTableViewCell heighForRowWithStyle:NewsStyleOfList model:new];
    }else if (indexPath.row %3 == 2){
        return 30.0f;
    }else{
        return CELL_CONTENT_MARGIN;
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @" ";
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row %3== 1) {
        long index = tableData.count -1- indexPath.row/3;
        NewsModel *news = tableData[index];
        [self performSegueWithIdentifier:@"ShowDetails" sender:news];
    }
//    }else{
//        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowDetails"]) {
        NewsDetailViewController *controller = segue.destinationViewController;
        controller.newsModel = sender;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
