//
//  MarkView.m
//  MyWeibo
//
//  Created by 马遥 on 15/8/2.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "MarkView.h"

@implementation MarkView

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(markView:touchesBegan:withEvent:)]){
        [self.delegate markView:self touchesBegan:touches withEvent:event];
    }
//    NSLog(@"touchesBegan");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(markView:touchesCancelled:withEvent:)]){
        [self.delegate markView:self touchesCancelled:touches withEvent:event];
    }
//    NSLog(@"touchesCancelled");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(markView:touchesEnded:withEvent:)]){
        [self.delegate markView:self touchesEnded:touches withEvent:event];
    }
//    NSLog(@"touchesEnded");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(markView:touchesMoved:withEvent:)]){
        [self.delegate markView:self touchesMoved:touches withEvent:event];
    }
//    NSLog(@"touchesMoved");
}

@end
