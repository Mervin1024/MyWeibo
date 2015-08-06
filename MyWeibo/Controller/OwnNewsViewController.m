//
//  OwnNewsViewController.m
//  MyWeibo
//
//  Created by 马遥 on 15/8/6.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "OwnNewsViewController.h"

@interface OwnNewsViewController ()

@end

@implementation OwnNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)dataByArrayFromDB{
//    __block NSMutableArray *reloadData = [NSMutableArray array];
    NSMutableArray *reloadData = [NSMutableArray array];
//    [personalModel.attentions excetueEach:^(NSString *userId){
//        [reloadData addObjectsFromArray:[[UserModel selectedByUserID:userId] arrayUserAllNewsBySelected]];
//    }];
    [reloadData addObjectsFromArray:[self.personalModel arrayAllNewsOfUserBySelected]];
    NSArray *sortedArray = [reloadData sortedArrayUsingComparator:^(NewsModel *new1,NewsModel *new2){
        NSString *date1 = new1.publicTime;
        NSString *date2 = new2.publicTime;
        return [date1 compare:date2];
    }];
    return sortedArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
