//
//  ConfigureTableViewCell.m
//  MyWeibo
//
//  Created by 马遥 on 15/8/5.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "ConfigureTableViewCell.h"

@implementation ConfigureTableViewCell
@synthesize configureDetailTextLabel,configureTextLabel,configureImageView;

- (void)awakeFromNib {
    // Initialization code
//    CGFloat width = 60;
//    if (configureTextLabel.text.length == 3) {
//        width = 45;
//    }else if (configureTextLabel.text.length == 2){
//        width = 30;
//    }
//    CGRect frame = configureTextLabel.frame;
//    frame.size.width = width;
//    configureTextLabel.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
