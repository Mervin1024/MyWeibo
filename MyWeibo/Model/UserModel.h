//
//  UserModel.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsModel.h"

@interface UserModel : NSObject
- (UserModel *)initWithUserID:(NSString *)userId name:(NSString *)names avatar:(NSString *)avatars description:(NSString *)descs;
+ (UserModel *)selectedByUserID:(NSString *)userId;
+ (int) countOfUsers;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) dictionaryOfPropertiesAndTypes;
- (NSDictionary *) dictionaryOfDate;
//- (NSDictionary *) dictionaryBySelectedWithUserID:(NSString *)userId;
- (BOOL) insertItemToTable;
- (BOOL) updateItemFromTable;
- (NSArray *)arrayUserAllNewsBySelected;
@property (copy, nonatomic, readonly) NSString *user_ID;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *avatar;
@property (copy, nonatomic, readonly) NSString *desc;
@end
