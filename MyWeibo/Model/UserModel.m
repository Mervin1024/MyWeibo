//
//  UserModel.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "UserModel.h"
#import "MyWeiboData.h"
#import "DBManager.h"
#import "NSArray+Assemble.h"

@implementation UserModel{
    DBManager *dbManager;
}
@synthesize user_ID;
@synthesize name;
@synthesize avatar;
@synthesize desc;

- (UserModel *)init{
    self = [super init];
    if (self) {
        dbManager = [MyWeiboData sharedManager].dbManager;
    }
    return self;
}

- (UserModel *)initWithUserID:(NSString *)userId name:(NSString *)names avatar:(NSString *)avatars description:(NSString *)descs{
    self = [super init];
    if (self) {
        dbManager = [MyWeiboData sharedManager].dbManager;
        user_ID = userId;
        name = names;
        avatar = avatars;
        desc = descs;
    }
    return self;
}

+ (UserModel *)selectedByUserID:(NSString *)userId{
    NSString *name = nil;
    NSDictionary *user = [self dictionaryBySelectedWithUserID:userId];
    if ([user count] == 4) {
        name = [user objectForKey:userName];
    }
    NSString *avatar = [user objectForKey:avatarName];
    NSString *desc = [user objectForKey:userDesc];
    return [[UserModel alloc]initWithUserID:userId name:name avatar:avatar description:desc];
}

+ (int) countOfUsers{
    return [[MyWeiboData sharedManager].dbManager countOfItemsNumberInTable:userTable where:nil];
}

+ (NSArray *) arrayOfProperties{
    return @[userID,userName,avatarName,userDesc];
}

+ (NSDictionary *) dictionaryOfPropertiesAndTypes{
    NSArray *types = @[userPrimaryKey,textType,textType,textType];
    return [NSDictionary dictionaryWithObjects:types forKeys:[UserModel arrayOfProperties]];
}

- (NSDictionary *) dictionaryOfDate{
    if (name) {
        return [NSDictionary dictionaryWithObjects:@[user_ID,name,avatar,desc] forKeys:@[userID,userName,avatarName,userDesc]];

    }
    return [NSDictionary dictionaryWithObjects:@[user_ID,avatar,desc] forKeys:@[userID,avatarName,userDesc]];
}

+ (NSDictionary *) dictionaryBySelectedWithUserID:(NSString *)userId{
    NSArray *data = [[MyWeiboData sharedManager].dbManager arrayBySelect:[UserModel arrayOfProperties] fromTable:userTable where:@{userID:userId} orderBy:nil from:0 to:0];
    return data[0];
}

- (BOOL) insertItemToTable{
    if ([dbManager insertItemsToTableName:userTable columns:[self dictionaryOfDate]]) {
        return YES;
    }
    return NO;
}

- (BOOL) updateItemFromTable{
    if ([dbManager updateItemsTableName:userTable set:@{avatarName:avatar} where:@{userID:user_ID}] && [dbManager updateItemsTableName:userTable set:@{userName:name} where:@{userID:user_ID}] && [dbManager updateItemsTableName:userTable set:@{userDesc:desc} where:@{userID:user_ID}]) {
        return YES;
    }
    return NO;
    
}

- (NSArray *)arrayUserAllNewsBySelected{
    NSArray *allNews = [NewsModel arrayBySelectedWhere:nil from:0 to:0];
    NSArray *news = [allNews arrayBySelect:^(NewsModel *new){
        return [new.user.user_ID isEqualToString:user_ID];
    }];
    return news;
}

@end
