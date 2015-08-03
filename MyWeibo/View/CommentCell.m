//
//  CommentCell.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/14.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    NSLog(@"%@",NSStringFromCGSize(self.contentView.bounds.size));
}

- (IBAction)Forward:(id)sender {
    [self.delegate commentCell:self forward:sender];
}

- (IBAction)Praise:(id)sender {
    [self.delegate commentCell:self Praise:sender];
}

- (IBAction)Comment:(id)sender {
    [self.delegate commentCell:self Comment:sender];
}
@end
