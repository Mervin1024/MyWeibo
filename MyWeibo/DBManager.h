

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DBManager : NSObject

- (NSString *) dbPath:(NSString *)name;
- (void) connectDBName: (NSString *)name;
- (BOOL) createTableName:(NSString *)name columns:(NSDictionary *)colums;
- (BOOL) insearItemsTableName:(NSString *)name columns:(NSDictionary *)columns;
- (NSArray *) queryItemsInTableName:(NSString *) name from:(long) from to:(long) to columns: (NSArray *) columns;
- (NSUInteger) queyCountOfTableName:(NSString *)name;

@property (nonatomic) FMDatabase *db;
@end
