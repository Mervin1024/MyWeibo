//
//  TouchesOfButton.m
//  MyWeibo
//
//  Created by 马遥 on 15/8/4.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "CommentButton.h"

@implementation CommentButton

//- (id)init{
//    if ((self = [super init])) {
//        NSLog(@"1");
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])) {
//        self.titleLabel.numberOfLines = 2;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.titleLabel.numberOfLines = 0;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
//    markView = [[UIView alloc]initWithFrame:buttonFrame];
//    markView.alpha = 0;
//    markView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.35];
//    [self addSubview:markView];
//    
//    if (markView.alpha == 1) {
//        
//    }else{
//        [UIView animateWithDuration:0.1 animations:^{
//            markView.alpha = 1;
//        }];
//    }
    
    if ([self.delegate respondsToSelector:@selector(commentButton:touchesBegan:withEvent:)]) {
        [self.delegate commentButton:self touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
//    if (markView.alpha == 0) {
//        
//    }else{
//        [UIView animateWithDuration:0.4 animations:^{
//            markView.alpha = 0;
//        }];
//    }
    if ([self.delegate respondsToSelector:@selector(commentButton:touchesEnded:withEvent:)]) {
        [self.delegate commentButton:self touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(commentButton:touchesCancelled:withEvent:)]) {
        [self.delegate commentButton:self touchesCancelled:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(commentButton:touchesMoved:withEvent:)]) {
        [self.delegate commentButton:self touchesMoved:touches withEvent:event];
    }
}

@end
