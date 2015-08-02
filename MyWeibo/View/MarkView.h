//
//  MarkView.h
//  MyWeibo
//
//  Created by 马遥 on 15/8/2.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MarkView;
@protocol MarkViewDelegate <NSObject>
@optional
- (void)markView:(MarkView *)markView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)markView:(MarkView *)markView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)markView:(MarkView *)markView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)markView:(MarkView *)markView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
@end
@interface MarkView : UIView
@property (weak, nonatomic) id<MarkViewDelegate> delegate;
@end
