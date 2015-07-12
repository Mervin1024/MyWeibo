//
//  UserModel.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
- (UserModel *)initWithUserID:(NSString *)userId name:(NSString *)names avatar:(NSString *)avatars description:(NSString *)descs;
+ (UserModel *)selectedByUserID:(NSString *)userId;
+ (int) countOfUsers;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) dictionaryOfPropertiesAndTypes;
- (NSDictionary *) dictionaryOfDate;
- (NSDictionary *) dictionaryBySelected;
- (void) insertItemToTable;
- (void) updateItemFromTable;

@property (copy, nonatomic) NSString *user_ID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *desc;
@end
