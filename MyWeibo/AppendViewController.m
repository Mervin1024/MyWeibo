//
//  AddNewsViewController.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/21.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "AppendViewController.h"
#import "AddNewsViewController.h"

@interface AppendViewController (){
    AddNewsViewController *addNewsViewController;
}

@end

@implementation AppendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)text:(id)sender {
    [self performSegueWithIdentifier:@"AddText" sender:nil];
}

- (IBAction)image:(id)sender {
    [self performSegueWithIdentifier:@"AddImage" sender:nil];
}

- (IBAction)photo:(id)sender {
    [self performSegueWithIdentifier:@"AddPhoto" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AddText"]) {
        addNewsViewController = segue.destinationViewController;
        addNewsViewController.addNewsType = AddNewsTypeOfText;
        addNewsViewController.delegate = self;
    }else if ([segue.identifier isEqualToString:@"AddImage"]){
        addNewsViewController = segue.destinationViewController;
        addNewsViewController.addNewsType = AddNEwsTypeOfImage;
        addNewsViewController.delegate = self;
    }else if ([segue.identifier isEqualToString:@"AddPhoto"]){
        addNewsViewController = segue.destinationViewController;
        addNewsViewController.addNewsType = AddNewsTypeOfPhoto;
        addNewsViewController.delegate = self;
    }
}

//- (void)AddNewsViewControllerDidCancel:(AddNewsViewController *)controller{
//    [self.tabBarController setSelectedIndex:0];
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}

- (void)AddNewsViewController:(AddNewsViewController *)controller DidFinishPublish:(NewsModel *)news{
    NSLog(@"发表");
}

@end
