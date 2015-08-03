//
//  CommentCell.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/14.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentCell;
@protocol CommentCellDelegate <NSObject>

- (void)commentCell:(CommentCell *)cell forward:(id)sender;
- (void)commentCell:(CommentCell *)cell Praise:(id)sender;
- (void)commentCell:(CommentCell *)cell Comment:(id)sender;
@end

@interface CommentCell : UITableViewCell

- (IBAction)Forward:(id)sender;
- (IBAction)Praise:(id)sender;
- (IBAction)Comment:(id)sender;
@property (weak, nonatomic) id<CommentCellDelegate> delegate;
@end
