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
    // 文件路径
}

+ (void) saveImage:(UIImage *)image withImageName:(NSString *)imageName{
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *imageFilePath = [self stringOfFilePathForName:imageName];
    BOOL result = [imageData writeToFile:imageFilePath atomically:YES];
    if (result) {
        NSLog(@"成功储存%@",imageName);
    }else{
        NSLog(@"储存失败");
    }
    // 将图片存至Documents
}

+ (void) deleteImageWithImageName:(NSString *)imageName{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    NSString *imageData = [self stringOfFilePathForName:imageName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:imageData];
    if (!blHave) {
        NSLog(@"未找到%@",imageName);
        return ;
    }else {
//        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:imageData error:nil];
        if (blDele) {
            NSLog(@"删除%@成功",imageName);
        }else {
            NSLog(@"删除%@失败",imageName);
        }
    }
    // 删除图片
}

@end
