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

@interface NewsTableViewController (){
    NSMutableArray *tableData;
    NSArray *images;
    DBManager *dbManager;
    NewsModel *newsModel;
}

@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValue];
    [self initDB];
    [self initTableData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) initValue{
    dbManager = [MyWeiboData sharedManager].dbManager;
    tableData = [NSMutableArray array];
}

- (void) initDB{
    [NewsModel creatTableFromSql];
    [InitialNews insertUserModel];
    [InitialNews insertNewsModel];
}

- (void) initTableData{
    [tableData addObjectsFromArray:[NewsModel arrayBySelectedWhere:nil from:0 to:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return tableData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewCell" owner:self options:nil] lastObject];
        [cell setAvatarAsRound];
    }
    NewsModel *new = tableData[indexPath.row];
//    UIImage *avatar = [[UIImage alloc]initWithContentsOfFile:[DocumentAccess stringOfFilePathForName:new.user.avatar]];
//    cell.avatar.image = [UIImage imageWithCGImage:[avatar CGImage] scale:(avatar.scale *0.5) orientation:(avatar.imageOrientation)];
    cell.avatar.image = [[UIImage alloc]initWithContentsOfFile:[DocumentAccess stringOfFilePathForName:new.user.avatar]];
    cell.weibo.text = new.news_text;
//    cell.description.text = new.user.desc;
    cell.description.text = [new.user.desc stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//    NSLog(@"name:%@",new.user.name);
    if (new.user.name) {
        cell.name.text = new.user.name;
    }else{
        cell.name.text = new.user.user_ID;
    }
    NSLog(@"%ld.cell.images:%lu",(long)indexPath.row,(unsigned long)new.images.count);
    [cell setImages:new.images];
//    [cell.weibo.layer setBorderWidth:2.0f];
//    NSLog(@"text hight %f",[cell.weibo boundingRectWithSize:CGSizeMake(CELL_TEXT_WIDTH, 0)].height);
//    NSLog(@"cell size %@",NSStringFromCGSize(cell.contentView.bounds.size));
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NewsModel *new = tableData[indexPath.row];
//    NSString *text = new.news_text;
//    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), CELL_CONTENT_MARGIN);
//}

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
