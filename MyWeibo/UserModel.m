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
    UserModel *users = [[UserModel alloc]init];
    if (users) {
        users.user_ID = userId;
        NSDictionary *user = [users dictionaryBySelected];
        if ([user count] == 4) {
            users.name = [user objectForKey:userName];
        }
        users.avatar = [user objectForKey:avatarName];
        users.desc = [user objectForKey:userDesc];
    }
    return users;
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

- (NSDictionary *) dictionaryBySelected{
    NSArray *data = [[MyWeiboData sharedManager].dbManager arrayBySelect:[UserModel arrayOfProperties] fromTable:userTable where:@{userID:user_ID} orderBy:nil from:0 to:0];
    return data[0];
}

- (void) insertItemToTable{
    [dbManager insertItemsToTableName:userTable columns:[self dictionaryOfDate]];
}

- (void) updateItemFromTable{
    [dbManager updateItemsTableName:userTable set:@{avatarName:avatar} where:@{userID:user_ID}];
    [dbManager updateItemsTableName:userTable set:@{userName:name} where:@{userID:user_ID}];
}

@end
