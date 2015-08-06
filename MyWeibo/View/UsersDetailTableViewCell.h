//
//  UsersDetailTableViewCell.h
//  MyWeibo
//
//  Created by 马遥 on 15/8/6.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDetailTextLabel;
@end
