//
//  ImagesModel.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagesModel : NSObject
- (ImagesModel *)initWithImage:(NSString *)imageName newsID:(NSInteger)newsId;
+ (int) countOfImagesWithNewsID:(NSInteger)newsId;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) dictionaryOfPropertiesAndTypes;
+ (NSArray *) arrayAllBySelectedWhere:(NSDictionary *)condition;
- (NSDictionary *) dictionaryOfData;
- (BOOL) insertItemToTable;

//@property (strong, nonatomic) NSArray *images;
@property (assign, nonatomic) NSInteger image_id;
@property (copy, nonatomic) NSString *image_name;
@property (assign, nonatomic) NSInteger news_id;
@end
