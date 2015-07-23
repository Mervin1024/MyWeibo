//
//  NewsModel.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "NewsModel.h"
#import "MyWeiboData.h"
#import "DBManager.h"
#import "ImagesModel.h"

@implementation NewsModel{
    DBManager *dbManager;
}
@synthesize news_id;
@synthesize user_id;
@synthesize images;
@synthesize news_text;
@synthesize user;

#pragma mark - init 方法
- (NewsModel *)init{
    self = [super init];
    if (self) {
        dbManager = [MyWeiboData sharedManager].dbManager;
    }
    return self;
}

- (NewsModel *)initWithNewsID:(NSInteger)newsId userID:(NSString *)userId text:(NSString *)text images:(NSArray *)image{
    self = [super init];
    if (self) {
        dbManager = [MyWeiboData sharedManager].dbManager;
        user_id = userId;
        images = image;
        news_text = text;
        if (newsId > 0) {
            news_id = newsId;
        }
        user = [UserModel selectedByUserID:user_id];
    }
    return self;
}

- (NewsModel *)initWithDictionary:(NSDictionary *)data{
    self = [super init];
    if (self) {
        if ([data allKeys].count == 3) {
            news_id = [[data objectForKey:newsID] intValue];
        }
        dbManager = [MyWeiboData sharedManager].dbManager;
        user_id = [data objectForKey:userID];
        news_text = [data objectForKey:newsText];
        images = [self arrayAllImagesBySelected];
        user = [UserModel selectedByUserID:user_id];
    }
    return self;
}
#pragma mark - 数据库查询
+ (int) countOfNews{
    return [[MyWeiboData sharedManager].dbManager countOfItemsNumberInTable:newsTable where:nil];
}

- (int) countOfImages{
    return [ImagesModel countOfImagesWithNewsID:news_id];
}

+ (NSArray *) arrayOfProperties{
    return @[newsID,userID,newsText];
}

+ (NSDictionary *) dictionaryOfPropertiesAndTypes{
    NSArray *types = @[primaryKey,textType,textType];
    return [NSDictionary dictionaryWithObjects:types forKeys:[NewsModel arrayOfProperties]];
}

- (NSArray *) arrayAllImagesBySelected{
    NSArray *data = [ImagesModel arrayAllBySelectedWhere:@{newsID:[NSString stringWithFormat:@"%ld",news_id]}];
    NSMutableArray *imageNames = [NSMutableArray array];
    for (NSDictionary *image in data) {
        [imageNames addObject:[image objectForKey:imageName]];
    }
    return imageNames;
}

+ (NSArray *) arrayBySelectedWhere:(NSDictionary *)condition from:(long)from to:(long)to{
    NSArray *news = [[MyWeiboData sharedManager].dbManager arrayBySelect:[NewsModel arrayOfProperties] fromTable:newsTable where:condition orderBy:nil from:from to:to];
    NSMutableArray *data = [NSMutableArray array];
    for (NSDictionary *new in news) {
        [data addObject:[[NewsModel alloc]initWithDictionary:new]];
    }
    return data;
}
#pragma mark - 字典形式返回对象属性
- (NSDictionary *) dictionaryOfData{
    if (news_id) {
        return [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%ld",(long)news_id],user_id,news_text] forKeys:[NewsModel arrayOfProperties]];
    }
    return [NSDictionary dictionaryWithObjects:@[user_id,news_text] forKeys:@[userID,newsText]];
}
#pragma mark - 从数据库删除条目
- (void) deleteNewFromTable{
    [dbManager deleteFromTableName:newsTable where:@{newsID:[NSString stringWithFormat:@"%ld",(long)news_id]}];
    [self deleteImagesFromTable];
}

- (void) deleteImagesFromTable{
    [dbManager deleteFromTableName:imagesTable where:@{newsID:[NSString stringWithFormat:@"%ld",(long)news_id]}];
}
#pragma mark - 单条目插入数据库
- (void) insertItemToTable{
    [dbManager insertItemsToTableName:newsTable columns:[self dictionaryOfData]];
    if (self.news_id) {
    }else{
        int count = [NewsModel countOfNews];
        NSArray *news = [dbManager arrayBySelect:[NewsModel arrayOfProperties] fromTable:newsTable where:nil orderBy:nil from:count-1 to:count];
//        NSLog(@"news.count:%lu",(unsigned long)news.count);
        self.news_id = [[news[0] objectForKey:newsID] intValue];
    }
    
    for (int i = 0; i < images.count; i++) {
        ImagesModel *image = [[ImagesModel alloc]initWithImage:images[i] newsID:news_id];
        [image insertItemToTable];
    }
}
#pragma mark - 数据库建表
+ (void) creatTableFromSql{
    [[MyWeiboData sharedManager].dbManager createTableName:newsTable columns:[NewsModel dictionaryOfPropertiesAndTypes]];
    [[MyWeiboData sharedManager].dbManager createTableName:userTable columns:[UserModel dictionaryOfPropertiesAndTypes]];
    [[MyWeiboData sharedManager].dbManager createTableName:imagesTable columns:[ImagesModel dictionaryOfPropertiesAndTypes]];
}
@end
