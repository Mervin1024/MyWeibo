//
//  DocumentAccess.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentAccess : NSObject

+ (void) saveImage:(UIImage *)image withImageName:(NSString *)imageName;
+ (NSString *) stringOfFilePathForName:(NSString *)name;
+ (void) deleteImageWithImageName:(NSString *)imageName;
@end
