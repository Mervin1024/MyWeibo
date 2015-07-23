//
//  InitialNews.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/13.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NewsModel;
@class ImagesModel;
@class UserModel;

@interface InitialNews : NSObject
+ (NewsModel *) randomNewsModel;
+ (void) insertNewsModel;
+ (void) insertUserModel;
@end


/*
 
    虚拟数据
 
*/