//
//  MyWeiboData.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface MyWeiboData : NSObject
+ (MyWeiboData *)sharedManager;

@property (strong, nonatomic) DBManager *dbManager;

extern NSString *const primaryKey;
extern NSString *const textType;

extern NSString *const newsTable;
extern NSString *const newsID;
extern NSString *const newsText;

extern NSString *const imagesTable;
extern NSString *const imageID;
extern NSString *const imageName;

extern NSString *const userTable;
extern NSString *const userPrimaryKey;
extern NSString *const userID;
extern NSString *const avatarName;
extern NSString *const userName;
extern NSString *const userDesc;

extern NSString *const personalName;
extern NSString *const personalAvatar;
extern NSString *const personalDesc;
extern NSString *const personalID;
extern NSString *const personalPassword;
@end
