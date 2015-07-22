//
//  MyWeiboData.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "MyWeiboData.h"

@implementation MyWeiboData

NSString *const primaryKey = @"INTEGER PRIMARY KEY NOT NULL";
NSString *const textType = @"TEXT";

NSString *const newsTable = @"NewsTable";
NSString *const newsID = @"news_id";
NSString *const newsText = @"newsText";

NSString *const imagesTable = @"ImageTable";
NSString *const imageID = @"images_id";
NSString *const imageName = @"image_name";

NSString *const userTable = @"UserTable";
NSString *const userPrimaryKey = @"TEXT PRIMARY KEY NOT NULL";
NSString *const userID = @"user_id";
NSString *const avatarName = @"avatar";
NSString *const userName = @"user_name";
NSString *const userDesc = @"description";

- (MyWeiboData *)init{
    self = [super init];
    if (self) {
        self.dbManager = [[DBManager alloc]init];
    }
    return self;
}
// 获取单例
+ (MyWeiboData *) sharedManager{
    static MyWeiboData *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}


@end
