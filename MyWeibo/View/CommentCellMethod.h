//
//  CommentCellMethod.h
//  MyWeibo
//
//  Created by 马遥 on 15/8/3.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentCell.h"
#import "NewsModel.h"

@interface CommentCellMethod : NSObject

- (id)initWithNewsModel:(NewsModel *)news;

- (void)forward;
- (void)Praise;
- (void)Comment;

@property (strong, nonatomic) NewsModel *news;
@end
