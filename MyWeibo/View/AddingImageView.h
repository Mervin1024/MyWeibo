//
//  AddingImageView.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/24.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddingImageView;
@protocol AddingImageViewDelegate <NSObject>

- (void)AddingImageView:(AddingImageView *)imageView didSelectDeleteButton:(id)sender;

@end

@interface AddingImageView : UIImageView

- (AddingImageView *)initWithFrame:(CGRect)frame;

@property (weak, nonatomic) id<AddingImageViewDelegate> m_delegate;
@end
