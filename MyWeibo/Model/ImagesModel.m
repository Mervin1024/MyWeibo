//
//  ImagesModel.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "ImagesModel.h"
#import "DBManager.h"
#import "MyWeiboData.h"

@implementation ImagesModel{
    DBManager *dbManager;
}
@synthesize image_id;
@synthesize image_name;
@synthesize news_id;

#pragma mark - init 方法
- (ImagesModel *)init{

    if ((self = [super init])) {
        dbManager = [MyWeiboData sharedManager].dbManager;
    }
    return self;
}

- (ImagesModel *)initWithImage:(NSString *)imageName newsID:(NSInteger)newsId{
    
    if ((self = [super init])) {
        dbManager = [MyWeiboData sharedManager].dbManager;
        image_name = imageName;
        news_id = newsId;
    }
    return self;
}
#pragma mark - 数据库查询
+ (int) countOfImagesWithNewsID:(NSInteger)newsId{
    return [[MyWeiboData sharedManager].dbManager countOfItemsNumberInTable:imagesTable where:@{newsID:[NSString stringWithFormat:@"%ld",(long)newsId]}];
}

+ (NSArray *) arrayOfProperties{
    return @[imageID,imageName,newsID];
}

+ (NSDictionary *) dictionaryOfPropertiesAndTypes{
    NSArray *types = @[primaryKey,textType,textType];
    return [NSDictionary dictionaryWithObjects:types forKeys:[ImagesModel arrayOfProperties]];
}

+ (NSArray *) arrayAllBySelectedWhere:(NSDictionary *)condition{
    return [[MyWeiboData sharedManager].dbManager arrayBySelect:[ImagesModel arrayOfProperties] fromTable:imagesTable where:condition orderBy:nil from:0 to:0];
}
#pragma mark - 字典形式返回对象属性
- (NSDictionary *) dictionaryOfData{
    if (image_id > 0) {
        return [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%ld",image_id],image_name,[NSString stringWithFormat:@"%ld",news_id]] forKeys:@[imageID,imageName,newsID]];
    }
    return [NSDictionary dictionaryWithObjects:@[image_name,[NSString stringWithFormat:@"%ld",news_id]] forKeys:@[imageName,newsID]];
}
#pragma mark - 单条目插入数据库
- (BOOL) insertItemToTable{
    if ([dbManager insertItemsToTableName:imagesTable columns:[self dictionaryOfData]]) {
        return YES;
    }
    return NO;
}

@end
