//
//  PersonalModel.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/23.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "UserModel.h"
typedef enum {
    UserTypeFans,
    UserTypePersonal
}UserType;

@interface PersonalModel : UserModel

- (PersonalModel *)initWithUserDefaults;
- (PersonalModel *)initWithUserID:(NSString *)userId password:(NSString *)passwords name:(NSString *)names avatar:(NSString *)avatars description:(NSString *)descr;
- (BOOL)savePersonalInformation;
+ (NSString *)personalIDfromUserDefaults;

@property (copy, nonatomic, readonly) NSString *password;
@property (strong, nonatomic, readonly) NSArray *images;
@end
