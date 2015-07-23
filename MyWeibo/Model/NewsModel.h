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
+ (BOOL) creatTableFromSql;
- (NewsModel *)initWithNewsID:(NSInteger)newsId userID:(NSString *)userId text:(NSString *)text imagesName:(NSArray *)image;
- (NewsModel *)initWithDictionary:(NSDictionary *)data;
+ (int) countOfNews;
- (int) countOfImagesName;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) dictionaryOfPropertiesAndTypes;
- (BOOL) deleteNewFromTable;
+ (NSArray *) arrayBySelectedWhere:(NSDictionary *)condition from:(long)from to:(long)to;
- (BOOL) insertItemToTable;
- (NSDictionary *) dictionaryOfData;

@property (assign, nonatomic) NSInteger news_id;
@property (copy, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSArray *imagesName;
@property (copy, nonatomic) NSString *news_text;
@property (strong, nonatomic) UserModel *user;
@end
