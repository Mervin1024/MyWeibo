//
//  CellMethod.m
//  MyWeibo
//
//  Created by 马遥 on 15/8/4.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "CellMethod.h"

@implementation CellMethod

- (id)initWithNewsModel:(NewsModel *)news{
    if ((self = [super init])) {
        self.news = news;
    }
    return self;
}

@end
