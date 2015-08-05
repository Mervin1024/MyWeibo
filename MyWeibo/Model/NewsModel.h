//
//  NewsModel.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@class UserModel;
@interface NewsModel : NSObject
+ (BOOL) creatTableFromSql;
- (NewsModel *)initWithNewsID:(NSInteger)newsId userID:(NSString *)userId text:(NSString *)text imagesName:(NSArray *)image publicTime:(NSString *)time;
- (NewsModel *)initWithDictionary:(NSDictionary *)data;
+ (int) countOfNews;
- (int) countOfImagesName;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) dictionaryOfPropertiesAndTypes;
- (BOOL) deleteNewFromTable;
- (NSArray *) arrayAllImagesNameBySelected;
+ (NSArray *) arrayBySelectedWhere:(NSDictionary *)condition from:(long)from to:(long)to;
- (BOOL) insertItemToTable;
- (NSDictionary *) dictionaryOfData;

@property (assign, nonatomic) NSInteger news_id;
@property (copy, nonatomic, readonly) NSString *user_id;
@property (strong, nonatomic, readonly) NSArray *imagesName;
@property (copy, nonatomic, readonly) NSString *news_text;
@property (copy, nonatomic, readonly) NSString *publicTime;
@property (strong, nonatomic, readonly) UserModel *user;
@end
