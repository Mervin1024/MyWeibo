//
//  CellMethod.h
//  MyWeibo
//
//  Created by 马遥 on 15/8/4.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsModel.h"
#import "PersonalModel.h"
#import "SVProgressHUD.h"

@interface CellMethod : NSObject

- (id)initWithNewsModel:(NewsModel *)news;


@property (strong, nonatomic) NewsModel *news;
@end
