//
//  CommentCell.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/14.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "CommentCell.h"
//#import "SVProgressHUD.h"

@interface CommentCell(){
    UIView *markView;
}

@end

@implementation CommentCell
@synthesize forward,comment,praise;
- (void)awakeFromNib {
    // Initialization code
    markView = [[UIView alloc]init];
    markView.alpha = 0;
    markView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.35];
    [self addSubview:markView];
//    [self sendSubviewToBack:markView];
    
    forward.delegate = self;
    comment.delegate = self;
    praise.delegate = self;
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
//    [SVProgressHUD dismiss];
    [self.delegate commentCell:self forward:sender];
}

- (IBAction)Praise:(id)sender {
//    [SVProgressHUD dismiss];
    [self.delegate commentCell:self Praise:sender];
}

- (IBAction)Comment:(id)sender {
//    [SVProgressHUD dismiss];
    [self.delegate commentCell:self Comment:sender];
}

- (void)setAnimation:(CommentButton *)sender{
    if (markView.alpha == 1) {
        
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            markView.alpha = 1;
        }];
    }
    
//    sender.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.35];
    
}

- (void)stopAnimation:(CommentButton *)sender{
    if (markView.alpha == 0) {
        
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            markView.alpha = 0;
            //        sender.backgroundColor = [UIColor clearColor];
            //        sender.alpha = 1;
        }];
    }
    
}

- (void)commentButton:(CommentButton *)button touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    markView.frame = button.frame;
    [self setAnimation:button];
}

- (void)commentButton:(CommentButton *)button touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self stopAnimation:button];
}
@end
