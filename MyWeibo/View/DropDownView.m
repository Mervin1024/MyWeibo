//
//  DropDownView.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/31.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "DropDownView.h"

@implementation DropDownView
@synthesize tableList,myTableView,showList,myButton;

- (id) initWithButton:(UIButton *)button frame:(CGRect)frame list:(NSArray *)array{
    if (frame.size.height < 200) {
        frameHeight = 200;
    }else{
        frameHeight = frame.size.height;
    }
    tableHeight = frameHeight-30;
    frame.size.height = 30;
    if ((self = [super initWithFrame:frame])) {
        showList = NO;
        
        myButton = button;
//        [myButton targetForAction:@selector(buttonChecked:) withSender:nil];
        showList = array;
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, frame.size.width, 0)];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.backgroundColor = [UIColor grayColor];
        myTableView.separatorColor = [UIColor lightGrayColor];
        myTableView.hidden = YES;
        
        
        self.frame = (CGRect){frame.origin,frame.size.width,myButton.frame.size.height};
        myTableView.frame = (CGRect){frame.origin,frame.size.width,myButton.frame.size.height};
        
        [myButton.superview addSubview:self];
        [self addSubview:myTableView];
    }
    return self;
}

//- (void)buttonChecked:(id)sender{
//    NSLog(@"dropButton");
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dropCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dropCell"];
    }
    
    cell.textLabel.text = [tableList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    showList = NO;
    self.myTableView.hidden = YES;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [myButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
    NSLog(@"dropButton");
}



@end
