//
//  PersonalModel.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/23.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "PersonalModel.h"
#import "MyWeiboData.h"

@interface PersonalModel (){
    NSUserDefaults *userDefaults;
}
@end

@implementation PersonalModel

- (PersonalModel *)initWithUserID:(NSString *)userId password:(NSString *)passwords name:(NSString *)names avatar:(NSString *)avatars description:(NSString *)descr{
    
    if ((self = [super initWithUserID:userId name:names avatar:avatars description:descr])) {
        self.password = passwords;
    }
    return self;
}

- (PersonalModel *)initWithUserDefaults{
    if ((self = [super init])) {
        userDefaults = [NSUserDefaults standardUserDefaults];
        self.desc = [userDefaults objectForKey:personalDesc];
        self.user_ID = [userDefaults objectForKey:personalID];
        self.avatar = [userDefaults objectForKey:personalAvatar];
        self.password = [userDefaults objectForKey:personalPassword];
        NSString *pName;
        if ((pName = [userDefaults objectForKey:personalName])) {
            self.name = pName;
        }
    }
    return self;
}

- (BOOL)savePersonalInformation{
    userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.name) {
        [userDefaults setObject:self.name forKey:personalName];
    }
    [userDefaults setObject:self.desc forKey:personalDesc];
    [userDefaults setObject:self.avatar forKey:personalAvatar];
    [userDefaults setObject:self.user_ID forKey:personalID];
    [userDefaults setObject:self.password forKey:personalPassword];
    return YES;
}

+ (NSString *)personalIDfromUserDefaults{
    NSString *personalId = [[NSUserDefaults standardUserDefaults] objectForKey:personalID];
    return personalId;
}

@end
