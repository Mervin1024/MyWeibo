//
//  DocumentAccess.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "DocumentAccess.h"

@implementation DocumentAccess

+ (float) proportionOfHeigthToWidth:(CGSize)size{
    return size.height/size.width;
}

+ (NSString *) stringOfFilePathForName:(NSString *)name{
    NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name];
    return filePath;
}

+ (void) saveImage:(UIImage *)image withImageName:(NSString *)imageName{
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *imageFilePath = [DocumentAccess stringOfFilePathForName:imageName];
//    NSLog(@"imageFilePath:%@",imageFilePath);
    [imageData writeToFile:imageFilePath atomically:YES];
}

//+ (NSString *) stringOfInsertSQLWithTableName:(NSString *)tableName columns:(NSDictionary *)columns{
//    NSString *insertSql = @"";
//    return insertSql;
//}

@end
