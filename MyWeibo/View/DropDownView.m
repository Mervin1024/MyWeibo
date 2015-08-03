//
//  DropDownView.m
//  MyWeibo
//
//  Created by 马遥 on 15/8/2.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "DropDownView.h"

@interface DropDownView()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *myTableView;
    
}
@end

@implementation DropDownView
@synthesize dropList,userType;
- (id)initWithFrame:(CGRect)frame dropList:(NSArray *)array userType:(UserType)type{
    frame.size.height = array.count * DROPDOWN_CELL_HEIGHT;
    if ((self = [super initWithFrame:frame])) {
        dropList = array;
        myTableView = [[UITableView alloc]initWithFrame:(CGRect){0,0,frame.size} style:UITableViewStylePlain];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.scrollEnabled = NO;
//        myTableView.layer.masksToBounds = YES;
//        myTableView.layer.cornerRadius = myTableView.frame.size.height/2;
        [self addSubview:myTableView];
        userType = type;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dropList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = dropList[indexPath.row];
    if (userType == UserTypePersonal && [cell.textLabel.text isEqualToString:@"删除"]) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DROPDOWN_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate dropDownView:self didSelectRowAtIndexPath:indexPath];
}
@end
