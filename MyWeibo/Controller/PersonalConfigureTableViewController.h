//
//  PersonalConfigureTableViewController.h
//  MyWeibo
//
//  Created by 马遥 on 15/8/4.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigureTableViewCell.h"
#import "CommentButton.h"
#import "UsersDetailTableViewCell.h"

//typedef NS_ENUM(NSInteger, CheckedButtonType) {
//    CheckedButtonTypeMicroblog = 0,
//    CheckedButtonTypeAttention,
//    CheckedButtonTypeFans
//};

@interface PersonalConfigureTableViewController : UITableViewController

//@property (weak, nonatomic) IBOutlet UIImageView *personalAvatar;
//@property (weak, nonatomic) IBOutlet UILabel *personalName;
//@property (weak, nonatomic) IBOutlet UILabel *personalDesc;
@property (weak, nonatomic) IBOutlet CommentButton *microblogButton;
@property (weak, nonatomic) IBOutlet CommentButton *attentionButton;
@property (weak, nonatomic) IBOutlet CommentButton *fansButton;
- (IBAction)microblog:(id)sender;
- (IBAction)attention:(id)sender;
- (IBAction)fans:(id)sender;
@end
