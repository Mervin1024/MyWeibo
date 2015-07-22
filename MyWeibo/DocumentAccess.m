//
//  DocumentAccess.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "DocumentAccess.h"

@implementation DocumentAccess



+ (NSString *) stringOfFilePathForName:(NSString *)name{
    NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name];
    return filePath;
    // Documents 文件夹路径
}

+ (void) saveImage:(UIImage *)image withImageName:(NSString *)imageName{
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *imageFilePath = [DocumentAccess stringOfFilePathForName:imageName];
    [imageData writeToFile:imageFilePath atomically:YES];
    // 将图片存至Documents
}

@end
