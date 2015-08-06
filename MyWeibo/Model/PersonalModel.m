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
@synthesize password,images,level,praise,news,attentions,fans;
- (PersonalModel *)initWithUserID:(NSString *)userId password:(NSString *)passwords name:(NSString *)names avatar:(NSString *)avatars description:(NSString *)descr level:(NSInteger)lv praise:(NSArray *)prs attentions:(NSArray *)attention fans:(NSArray *)fan{
    if ((self = [super initWithUserID:userId name:names avatar:avatars description:descr])) {
        password = passwords;
        news = [self arrayAllNewsOfUserBySelected];
        images = [self arrayAllImagesBySelected];
        level = lv;
        praise = prs;
        attentions = attention;
        fans = fan;
    }
    
    return self;
}

- (PersonalModel *)initWithUserDefaults{
    userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:personalID] == nil) {
        return nil;
    }else{
        NSString *pName;
        if ([userDefaults objectForKey:personalName]) {
            pName = [userDefaults objectForKey:personalName];
        }
        if ((self = [self initWithUserID:[userDefaults objectForKey:personalID] password:[userDefaults objectForKey:personalPassword] name:pName avatar:[userDefaults objectForKey:personalAvatar] description:[userDefaults objectForKey:personalDesc] level:[[userDefaults objectForKey:personalLevel] intValue] praise:[userDefaults objectForKey:personalPraise] attentions:[userDefaults objectForKey:personalAttentions] fans:[userDefaults objectForKey:personalFans]])) {
            //        images = [self arrayAllImagesBySelected];
            
        }
        return self;
    }
    
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
    [userDefaults setObject:@(self.level) forKey:personalLevel];
    [userDefaults setObject:self.praise forKey:personalPraise];
    [userDefaults setObject:self.attentions forKey:personalAttentions];
    [userDefaults setObject:self.fans forKey:personalFans];
    return YES;
}

+ (NSString *)personalIDfromUserDefaults{
    NSString *personalId = [[NSUserDefaults standardUserDefaults] objectForKey:personalID];
    return personalId;
}

- (NSArray *)arrayAllImagesBySelected{
//    NSLog(@"arrayAllImage");
//    NSArray *news = [self arrayUserAllNewsBySelected];
//    NSLog(@"news.count:%ld",news.count);
    __block NSMutableArray *allImages = [NSMutableArray array];
    [news excetueEach:^(NewsModel *new){
        [allImages addObjectsFromArray:[new arrayAllImagesNameBySelected]];
    }];
//    NSLog(@"allImages:%ld",allImages.count);
    return allImages;
}

@end
