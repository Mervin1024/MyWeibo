//
//  InitialNews.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/13.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "InitialNews.h"
#import "NewsModel.h"
#import "ImagesModel.h"
#import "UserModel.h"
#import "Random.h"
#import "DocumentAccess.h"

@implementation InitialNews

+ (NewsModel *) randomNewsModel{
    NSArray *userIDs = @[@"Mervin",@"Bob",@"Nancy"];
    NSArray *texts = @[@"青春不回头，脚步莫停留。我们奋斗的是飞翔的翅膀，我们迈出的是慷慨的步伐，我们追求的是卓越的人生。",
                       @"老酒，绵香醇厚。老歌，情意悠悠。一段岁月，天长地久。一句祝福，伴你左右。一群朋友，知心牵手",
                       @"是否忙碌？是否疲惫。",
                       @"如果时光能够倒流，只盼与你不曾争吵，依然欢声笑语，那情依旧。而今一切都不回头，回顾过去，悔恨徒留。如今只望你能天天快乐，不要因为我的过错而痛哭自责。我已走，勿念！",
                       @"只留图不说话"];
    NSArray *images = @[@"莲妈",@"博丽神社",@"林间小屋",@"灵梦",@"永琳居",@"party"];
    int random1 = [Random randZeroToNum:(int)userIDs.count];
//    NSLog(@"userIDs.count-1:%lu",userIDs.count-1);
//    NSLog(@"random1:%d",random1);
    int random2 = [Random randZeroToNum:(int)texts.count];
    int random3 = [Random randZeroToNum:4];
    NSArray *random4 = [Random randNum:random3 inZeroToNum:(int)images.count];
    NSMutableArray *image = [NSMutableArray array];
    for (int i = 0;i < random4.count ;i++) {
        int a = [random4[i] intValue];
        [image addObject:images[a]];
    }
    NewsModel *new = [[NewsModel alloc]initWithNewsID:0 userID:userIDs[random1] text:texts[random2] images:image];
    return new;
}

+ (void) insertNewsModel{
    if ([NewsModel countOfNews] < 20) {
        for (int i = 0; i < 20; i++) {
            NewsModel *new = [InitialNews randomNewsModel];
            [new insertItemToTable];
            for (int i = 0; i < new.images.count; i++) {
                [DocumentAccess saveImage:[UIImage imageNamed:new.images[i]] withImageName:new.images[i]];
            }
        }
    }
}

+ (void) insertUserModel{
    NSArray *userIDs = @[@"Mervin",@"Bob",@"Nancy"];
    NSArray *userNames = @[@"赵日天",@"鲍俊杰",@"嫖断屌"];
    NSArray *avatars = @[@"yin",@"yuan",@"cindy"];
    NSArray *descs = @[@"著名日天狂魔",@"痴汉",@"嫖大大"];
//    NSLog(@"UserCount:%d",[UserModel countOfUsers]);
    if ([UserModel countOfUsers] < 3) {
        for (int i = 0; i < userIDs.count; i++) {
            UserModel *user = [[UserModel alloc]initWithUserID:userIDs[i] name:userNames[i] avatar:avatars[i] description:descs[i]];
            [user insertItemToTable];
            [DocumentAccess saveImage:[UIImage imageNamed:avatars[i]] withImageName:avatars[i]];
        }
    }
}

@end