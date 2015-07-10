

#import "DBManager.h"
#import "FMDatabaseAdditions.h"
#import "NSArray+Assemble.h"
#import "NSString+Format.h"

@implementation DBManager

#pragma mark - Supporting Utils

- (NSString *) dbPath:(NSString *)name
{
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                , NSUserDomainMask
                                                                , YES);
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_start2.sql", name]];
    
    return databaseFilePath;
}

- (NSString *) makeSqlString:(NSDictionary *) colums
{
    NSArray *keys = [colums allKeys];
    NSLog(@"Columns: %@", keys);
    
    NSString *mapString;
    NSMutableArray *pairs = [NSMutableArray array];
    
    for (int i = 0; i < keys.count; i++) {
        NSString * type = [colums objectForKey:keys[i]];
        NSLog(@"Value: %@", type);
        NSString *assemble = [keys[i] stringSwapWithBoundary:@"'"];
        assemble = [assemble stringByAppendingFormat:@" %@", type];
        NSLog(@"Ass: %@", assemble);
        [pairs addObject:assemble];
    }
    
    NSLog(@"Pairs count: %lu", (unsigned long)pairs.count);
    mapString = [pairs joinWithBoundary:@","];
    NSLog(@"Pairs: %@", pairs);
    return mapString;
}

#pragma mark - Connect DB

- (void) connectDBName:(NSString *)name
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath:name]];
    
    NSLog(@"connect DB");
    self.db = db;
}

#pragma mark - Create Table

- (BOOL) createTableName:(NSString *)name columns:(NSDictionary *)colums
{
    if ([self.db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT, %@)",name,[self makeSqlString: colums]];
        
        BOOL res = [self.db executeUpdate:sqlCreateTable];
        NSLog(@"create table");
        if (!res) {
            NSLog(@"error when creating db table");
            [self.db close];
            return NO;
        } else {
            NSLog(@"success to creating db table");
            [self.db close];
        }
    }
    return YES;
}

#pragma mark - Query

- (NSUInteger) queyCountOfTableName:(NSString *)name
{
    if ([self.db open]) {
        NSUInteger newsTotalCount = [self.db intForQuery:[NSString stringWithFormat:@"select count(*) from %@", name]];
        NSLog(@"Count of news: %lu", (unsigned long)newsTotalCount);
        return newsTotalCount;
    }
    
    return 0;
}


- (NSArray *) queryItemsInTableName:(NSString *) name from:(long) from to:(long) to columns: (NSArray *) columns
{
    NSLog(@"%@", columns);
    NSMutableArray *data = [NSMutableArray array];
    
    if ([self.db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",name];
        FMResultSet * rs = [self.db executeQuery:sql];
        
        for (int first = 0; [rs next] && first < to; first ++) {
            NSLog(@"Count in seart: %d", first);
            if (first >= from && first < to) {
                NSMutableDictionary *item = [NSMutableDictionary dictionary];
                for (int i = 0; i < columns.count; i++) {
                    NSString *value = [rs stringForColumn:columns[i]];
                    NSLog(@"%@: %@", columns[i], [rs stringForColumn:@"avatar"]);
                    if (value != nil) {
                        NSLog(@"Count: %d", i);
                        [item setValue:value forKey:columns[i]];
                    }
                }
                
                [data addObject:item];
            }
            [rs next];
        }
        
        [self.db close];
    }
    
    return data;
}

#pragma mark - Insert

- (BOOL) insearItemsTableName:(NSString *)name columns:(NSDictionary *)columns
{
    if ([self.db open]) {
        
        NSArray *keys = [columns allKeys];
        NSArray *values = [columns allValues];
        NSString *insertSql = [NSString stringWithFormat:
                               @"INSERT INTO %@ (%@) VALUES (%@)",
                               name, [keys joinToStringWithBoundary:@","], [values joinToStringWithBoundary:@","]];
        
        BOOL res = [self.db executeUpdate:insertSql];
        
        if (!res) {
            NSLog(@"error when insert db table");
            [self.db close];
            return NO;
        } else {
            NSLog(@"success to insert db table");
            [self.db close];
        }
    }
    return YES;
}


@end


