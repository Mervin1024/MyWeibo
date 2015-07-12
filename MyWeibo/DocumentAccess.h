//
//  DocumentAccess.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentAccess : NSObject
+ (float) proportionOfHeigthToWidth:(CGSize)size;
+ (void) saveImage:(UIImage *)image withImageName:(NSString *)imageName;
+ (NSString *) stringOfFilePathForName:(NSString *)name;
//+ (NSString *) stringOfInsertSQLWithTableName:(NSString *)tableName columns:(NSDictionary *)columns;

@end
