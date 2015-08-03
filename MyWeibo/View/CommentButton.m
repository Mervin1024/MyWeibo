//
//  TouchesOfButton.m
//  MyWeibo
//
//  Created by 马遥 on 15/8/4.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "CommentButton.h"

@implementation CommentButton


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(commentButton:touchesBegan:withEvent:)]) {
        [self.delegate commentButton:self touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
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
