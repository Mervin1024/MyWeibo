//
//  DropDownView.h
//  MyWeibo
//
//  Created by 马遥 on 15/8/2.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#define DROPDOWN_CELL_HEIGHT 44.0f

#import <UIKit/UIKit.h>
@class DropDownView;
@protocol DropDownViewDelegate <NSObject>

- (void)dropDownView:(DropDownView *)dropDownView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface DropDownView : UIView

- (id)initWithFrame:(CGRect)frame dropList:(NSArray *)array;
@property (weak, nonatomic) id<DropDownViewDelegate> delegate;
@property (strong, nonatomic) NSArray *dropList;
@end
