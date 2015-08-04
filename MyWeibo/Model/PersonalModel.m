//
//  PersonalModel.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/23.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "PersonalModel.h"
#import "MyWeiboData.h"
#import "NSArray+Assemble.h"

@interface PersonalModel (){
    NSUserDefaults *userDefaults;
}
@end

@implementation PersonalModel
@synthesize password,images;
- (PersonalModel *)initWithUserID:(NSString *)userId password:(NSString *)passwords name:(NSString *)names avatar:(NSString *)avatars description:(NSString *)descr{
    if ((self = [super initWithUserID:userId name:names avatar:avatars description:descr])) {
        password = passwords;
        images = [self arrayAllImagesBySelected];
    }
    
    return self;
}

- (PersonalModel *)initWithUserDefaults{
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pName;
    if ([userDefaults objectForKey:personalName]) {
        pName = [userDefaults objectForKey:personalName];
    }
    if ((self = [self initWithUserID:[userDefaults objectForKey:personalID] password:[userDefaults objectForKey:personalPassword] name:pName avatar:[userDefaults objectForKey:personalAvatar] description:[userDefaults objectForKey:personalDesc]])) {
        images = [self arrayAllImagesBySelected];
        
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

- (NSArray *)arrayAllImagesBySelected{
    NSArray *news = [self arrayUserAllNewsBySelected];
    __block NSMutableArray *allImages = [NSMutableArray array];
    [news excetueEach:^(NewsModel *new){
        [allImages addObjectsFromArray:[new arrayAllImagesNameBySelected]];
    }];
    return allImages;
}

@end
