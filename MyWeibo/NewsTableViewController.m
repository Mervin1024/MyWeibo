

#import "NewsTableViewController.h"
#import "NewTableViewCell.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface NewsTableViewController () {
    NSMutableArray *tableData;
    NSString *_id;
    NSString *table_name;
    NSString *_avatar;
    NSString *_name;
    NSString *_description;
    NSString *_weibo;
}

@end

@implementation NewsTableViewController
@synthesize count;
@synthesize sizeOfRefresh;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}
// 界面初始化
- (void)viewDidLoad {
    self.sizeOfRefresh = 10;
    tableData = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
    [self addRefreshViewControl];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];

    self.count = self.sizeOfRefresh;
    self.tableView.rowHeight = 226;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    [self initDB];
    [self insearItemsToTableData];

    
}

// 添加UIRefreshControl下拉刷新控件到UITableViewController的view中
-(void)addRefreshViewControl
{
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
}


-(void)RefreshViewControlEventValueChanged
{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中"];
        
        [self performSelector:@selector(handleData) withObject:nil afterDelay:1];
    }
}

- (void) handleData
{
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
//    
//    self.count += sizeOfRefresh;
//    [self insearItemsToTableData];
//    [self.tableView reloadData];
//    [self.refreshControl endRefreshing];
//    //
    NSLog(@"refreshed");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self insearItemsToTableData];
        NSLog(@"self.count = %ld",(long)self.count);
        if (tableData.count > self.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新成功"];
                self.count = tableData.count;
//                self.count += sizeOfRefresh;
                [self.tableView reloadData];
                [self performSelector:@selector(endRefreshingAinamation) withObject:nil afterDelay:0.5];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"没有更新的新鲜事了"];
                [self performSelector:@selector(endRefreshingAinamation) withObject:nil afterDelay:0.5];
            });
        }
    });

}

- (void) endRefreshingAinamation
{
    [self.refreshControl endRefreshing];
    [self performSelector:@selector(changeRefreshingTitle) withObject:nil afterDelay:1];
}

- (void) changeRefreshingTitle
{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
}// UIRefreshControl


//连接数据库并插入数据
- (BOOL) initDB {
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                , NSUserDomainMask
                                                                , YES);
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"my_wei_bo20.sql"];
    FMDatabase *db = [FMDatabase databaseWithPath:databaseFilePath];
    NSString *_id = @"_id";
    NSString *table_name = @"news";
    NSString *avatar = @"avatar";
    NSString *name = @"name";
    NSString *description = @"description";
    NSString *weibo = @"weibo";
    // SQL创建表
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",table_name,_id,avatar, name, description, weibo];
        BOOL res = [db executeUpdate:sqlCreateTable];
        NSLog(@"create table");
        if (!res) {
            return NO;
            NSLog(@"error when creating db table");
        } else {
            
            NSLog(@"success to creating db table");
        }
        
        NSUInteger count = [db intForQuery:[NSString stringWithFormat:@"select count(*) from %@", table_name]];
        
        
        // 插入数据
        if (count < 20) {
            for (int i = 0; i < 5; i++) {
                
                NSString *insertSql = [NSString stringWithFormat:
                                       @"INSERT INTO '%@' ('%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@')",
                                       table_name, avatar, name, description, weibo, @"lufei", @"蒙奇·D·路飞", @"草帽海贼团船长", @"从不会隐藏自己的想法，一旦遇到性情较敏感的对象就会感到头疼，会直言讨厌，也非常排斥气量狭小的对象。在轻视自己的国民的生命的迷倒众生的汉库克面前，愤怒地说”你真的很讨厌。“"];// 插入数据1
                
                NSString *insertSql2 = [NSString stringWithFormat:
                                       @"INSERT INTO '%@' ('%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@')",
                                        table_name, avatar, name, description, weibo, @"lufei1", @"Monkey·D·Luffy", @"《海贼王》的主人公", @"曾经和MR.2，贝拉米，汉库克等人为敌，但现都能放下过去成为朋友，并把他们像对待伙伴一样重视。也为了大局，和曾经为敌的沙·克洛克达尔，巴基，MR.3等人并肩作战。至始至终地帮助志愿成为海军的克比，并鼓励他成为他梦想的海军大将，只因为”我们是朋友嘛。[9] “面对一直在攻击他们致使山治昏迷的雪兔拉邦，见到小拉邦拼命保护亲人后，路飞毫不犹豫出手相助。"];// 插入数据2
                BOOL res = [db executeUpdate:insertSql];
                BOOL res2 = [db executeUpdate:insertSql2];//执行插入语句1，2
                
                if (!res || !res2) {
                    return NO;
                    NSLog(@"error when insert db table");
                } else {
                    
                    NSLog(@"success to insert db table");
                }
            }
        }
        
        [db close];
        
        
    } else {
        NSLog(@"OPEN DB FAILD");
    }
    return YES;
}
// 从数据库查找
- (void) insearItemsToTableData
{
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                , NSUserDomainMask
                                                                , YES);
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"my_wei_bo20.sql"];
    FMDatabase *db = [FMDatabase databaseWithPath:databaseFilePath];
    _id = @"_id";
    table_name = @"news";
    _avatar = @"avatar";
    _name = @"name";
    _description = @"description";
    _weibo = @"weibo";
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",table_name];
//        NSString * sql1 = [NSString stringWithFormat:
//                          @"SELECT * FROM %s","qwe"];
        
        FMResultSet * rs = [db executeQuery:sql];
        
//        FMResultSet * rs1 = [db executeQuery:sql1];
        
//        NSLog(@"RS1: %d", rs1 == false);
        
        for (int first =0; rs && first <= self.count; first ++) {
//            NSLog(@"Count in seart: %d", first);
            if (first > self.count - self.sizeOfRefresh && first <= self.count) {
                NSString * avatar = [rs stringForColumn:_avatar];
                NSString * name = [rs stringForColumn:_name];
                NSString * description = [rs stringForColumn:_description];
                NSString * weibo = [rs stringForColumn:_weibo];
                NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:avatar, _avatar, name, _name, description, _description, weibo, _weibo, nil];
                
                [tableData addObject:d];
            }
            if (![rs next]) {
                break;
            }
            
        }
        NSLog(@"Table Data Length: %lu", (unsigned long)[tableData count]);
        [db close];
    }

}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source 

// 设置tableview中每一个cell的属性
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    
    NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil] lastObject];
    }
    

    long r = (long)indexPath.row;
    long index = self.count - 1 - r;
    
    NSString *row_num = [NSString stringWithFormat:@"%ld", index];
    NSDictionary *d = (NSDictionary *) [tableData objectAtIndex:index];
    cell.avatar.image = [UIImage imageNamed:[d objectForKey:_avatar]];
    cell.name.text =[[d objectForKey:_name] stringByAppendingString:row_num];
    cell.description.text = [d objectForKey:_description];
    cell.weibo.text = [d objectForKey:_weibo];

    

    
    return cell;
} // UITableViewCell


// 单机cell事件
//- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NewTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.weibo.text = [cell.weibo.text stringByAppendingString:@"X"];
//}

@end
