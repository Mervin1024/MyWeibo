//
//  TouchesOfButton.h
//  MyWeibo
//
//  Created by 马遥 on 15/8/4.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentButton;
@protocol CommentButtonDelegate <NSObject>
@optional
- (void)commentButton:(CommentButton *)button touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)commentButton:(CommentButton *)button touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)commentButton:(CommentButton *)button touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)commentButton:(CommentButton *)button touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end


@interface CommentButton : UIButton{
    UIView *markView;
}
@property (weak, nonatomic) id<CommentButtonDelegate> delegate;
@end
