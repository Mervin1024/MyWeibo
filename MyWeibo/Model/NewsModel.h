//
//  NewsModel.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface NewsModel : NSObject
+ (void) creatTableFromSql;
- (NewsModel *)initWithNewsID:(NSInteger)newsId userID:(NSString *)userId text:(NSString *)text images:(NSArray *)image;
- (NewsModel *)initWithDictionary:(NSDictionary *)data;
+ (int) countOfNews;
- (int) countOfImages;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) dictionaryOfPropertiesAndTypes;
- (void) deleteNewFromTable;
+ (NSArray *) arrayBySelectedWhere:(NSDictionary *)condition from:(long)from to:(long)to;
- (void) insertItemToTable;
- (NSDictionary *) dictionaryOfData;

@property (assign, nonatomic) NSInteger news_id;
@property (copy, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSArray *images;
@property (copy, nonatomic) NSString *news_text;
@property (strong, nonatomic) UserModel *user;
@end
