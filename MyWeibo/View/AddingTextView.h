//
//  AddingTextView.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/25.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddingTextView;

@protocol AddingTextViewDelegate <NSObject>

@optional
- (void)textView:(AddingTextView *)textView heightChange:(CGFloat)height;

@end

@interface AddingTextView : UITextView
@property (weak, nonatomic) id<UITextViewDelegate,AddingTextViewDelegate> delegate;
@end
