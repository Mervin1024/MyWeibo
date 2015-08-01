//
//  DropDownView.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/31.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownView : UIView<UITableViewDelegate,UITableViewDataSource>{
//    BOOL showList;
    CGFloat tableHeight;
    CGFloat frameHeight;
}

- (id) initWithButton:(UIButton *)button frame:(CGRect)frame list:(NSArray *)array;

@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) NSArray *tableList;
@property (assign, nonatomic) BOOL showList;
@property (strong, nonatomic) UIButton *myButton;
@end
