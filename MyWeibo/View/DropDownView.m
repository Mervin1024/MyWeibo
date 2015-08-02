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
    NSArray *dropList;
}
@end

@implementation DropDownView

- (id)initWithFrame:(CGRect)frame dropList:(NSArray *)array{
    if ((self = [super initWithFrame:frame])) {
        dropList = array;
        myTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        
        [self addSubview:myTableView];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",dropList[indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
