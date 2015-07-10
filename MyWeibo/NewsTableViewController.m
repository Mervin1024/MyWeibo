

#import "NewsTableViewController.h"
#import "NewTableViewCell.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "NewsModel.h"

@interface NewsTableViewController () {
    NSMutableArray *tableData;
    NSDictionary *_newsAttributesAndTypes;
    NSDictionary *_newsAttributesAndNames;
    NSString *_dbName;
    NSString *_tableName;
    NSString *_avatar;
    NSString *_name;
    NSString *_description;
    NSString *_weibo;
    NSString *_weiboImage;
}

@end

@implementation NewsTableViewController
@synthesize count;
@synthesize sizeOfRefresh;
@synthesize dbManager;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"Rand: %d", arc4random());
    [self initValues];
    [self initDB];
    [self insearItemsToTableData];
    [self addRefreshViewControl];
    [self setUpForTableView];
    [super viewDidLoad];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Init Values

- (void) initValues
{
    _dbName = @"my_weibo_db";
    _tableName = @"news";
    
    tableData = [[NSMutableArray alloc] init];
    self.dbManager = [[DBManager alloc] init];
    self.sizeOfRefresh = 10;
    self.count = self.sizeOfRefresh;
    
    _newsAttributesAndTypes = [NewsModel directoryForAtrributesAndTpyes];
    _newsAttributesAndNames = [NewsModel directoryForAtrributesAndNames];
    self.columns = [_newsAttributesAndTypes allKeys];
    
    _avatar = [_newsAttributesAndNames objectForKeyedSubscript:@"avatar"];
    _name = [_newsAttributesAndNames objectForKeyedSubscript:@"name"];
    _description = [_newsAttributesAndNames objectForKeyedSubscript:@"desc"];
    _weibo = [_newsAttributesAndNames objectForKeyedSubscript:@"weibo"];
    _weiboImage = [_newsAttributesAndNames objectForKey:@"weibo_image"];
    
}

#pragma mark - Set Up For Table View

- (void) setUpForTableView
{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - News Database operation

- (void) initDB {
    [self.dbManager connectDBName:_dbName];
    [self.dbManager createTableName:_tableName columns: [NewsModel directoryForAtrributesAndTpyes]];
    
    if ([self.dbManager queyCountOfTableName:_tableName] <= 20) {
        for (int i = 0; i < 20; i++) {
            NewsModel *news = [NewsModel newsWithRandomValues];
            [self.dbManager insearItemsTableName:_tableName columns: [news dictionaryWithNewsPairs]];
        }
    }
}

- (void) insearItemsToTableData
{
    long to = self.count + self.sizeOfRefresh;
    NSArray *adding = [self.dbManager queryItemsInTableName:_tableName from: self.count to: to columns:self.columns];
    
    [tableData addObjectsFromArray:adding];
    
}

#pragma mark - Refresh Controller

-(void)addRefreshViewControl
{
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
}


-(void)RefreshViewControlEventValueChanged
{
    
    if (self.refreshControl.refreshing) {
        NSLog(@"refreshing");
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中"];
        
        [self performSelector:@selector(handleData) withObject:nil afterDelay:0.5];
        
    }
}

- (void) handleData
{
    NSLog(@"refreshed");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self insearItemsToTableData];
        NSLog(@"tableDate:%lu",(unsigned long)tableData.count);
        NSLog(@"self:%ld",(long)self.count);
        if (tableData.count > self.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新成功"];
                self.count = tableData.count;
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
}

#pragma mark - Table view settings

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
        [cell setAvatarAsRound];
    }
    
    long r = (long)indexPath.row;
    long index = self.count - 1 - r;
    
    NSDictionary *d = (NSDictionary *) [tableData objectAtIndex:index];
    cell.avatar.image = [UIImage imageNamed:[d objectForKey:_avatar]];
    cell.name.text = [[d objectForKey:_name] stringByAppendingFormat:@"_%ld", index];
    cell.description.text = [d objectForKey:_description];
    cell.weibo.text = [d objectForKey:_weibo];
    //    NSLog(@"Weibo Image: %@", [d objectForKey:_weiboImage]);
    cell.weiboImage.image = [UIImage imageNamed:[d objectForKey:_weiboImage]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = (NewTableViewCell *)[tableView cellForRowAtIndexPath: indexPath];
    cell.description.text = [cell.description.text stringByAppendingString:@"X"];
}

@end
