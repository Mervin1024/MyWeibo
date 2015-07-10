



#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface NewsTableViewController : UITableViewController

@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger sizeOfRefresh;
@property (nonatomic) DBManager *dbManager;
@property (nonatomic) NSArray *columns;

@end
