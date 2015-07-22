//
//  AddNewsViewController.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/22.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "AddNewsViewController.h"
#import "UILabel+StringFrame.h"
#import "SVProgressHUD.h"
#import "DocumentAccess.h"
#import "NSDate+Assemble.h"
#import "NSArray+Assemble.h"

@interface AddNewsViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UILabel *label;
    UIButton *addImage;
    UIActionSheet *actionSheet;
    NSMutableArray *images;
    NSMutableArray *imageViews;
    CGFloat buttonHight;
}

@end

@implementation AddNewsViewController
@synthesize addNewsType;
CGFloat const buttonMargin = 7.0f;
- (void)viewDidLoad {
    [super viewDidLoad];
    images = [NSMutableArray array];
    imageViews = [NSMutableArray array];
    [self setView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.view.frame.size.width > self.textView.frame.size.width) {
        [self setImageAndButton];
    }
    switch (addNewsType) {
        case AddNewsTypeOfPhoto:
            addNewsType = AddNewsTypeNone;
            [self takePhoto];
            break;
        case AddNEwsTypeOfImage:
            addNewsType = AddNewsTypeNone;
            [self localPhoto];
            break;
        case AddNewsTypeOfText:
            addNewsType = AddNewsTypeNone;
            addImage.hidden = YES;
            break;
        default:
            break;
    }
    [self.textView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setImageAndButton];
}

- (void)setView{
    
    label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:15];
    label.enabled = NO;
    label.text = @"分享新鲜事...";
    label.textColor = [UIColor lightGrayColor];
    label.frame = CGRectMake(buttonMargin, buttonMargin, self.textView.bounds.size.width, [label hightOfLabelWithFontSize:15 linesNumber:1]);
    label.numberOfLines = 0;
    [self.textView addSubview:label];
    
    
    
}

- (void)setImageAndButton{
    if (images.count == 0 && addImage == nil) {
        buttonHight = (self.textView.bounds.size.width-buttonMargin*4)/3.0;
        addImage = [UIButton buttonWithType:UIButtonTypeCustom];
        addImage.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y+[label hightOfLabelWithFontSize:15 linesNumber:3]+buttonMargin, buttonHight, buttonHight);
        addImage.backgroundColor = [UIColor clearColor];
        [addImage setBackgroundImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        addImage.adjustsImageWhenHighlighted = NO;
        [addImage addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.textView addSubview:addImage];
        
    }
    
    if (images.count > imageViews.count) {
        // button
        CGRect buttom = addImage.frame;
        buttom.origin.x = (images.count % 3) * (buttonHight + buttonMargin) + buttonMargin;
        buttom.origin.y = images.count / 3 * (buttonHight + buttonMargin) + label.frame.origin.y+[label hightOfLabelWithFontSize:15 linesNumber:3] + buttonMargin;
        addImage.frame = buttom;
        
        // imageView
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake((imageViews.count % 3) * (buttonHight + buttonMargin) + buttonMargin, imageViews.count / 3 * (buttonHight + buttonMargin) + label.frame.origin.y+[label hightOfLabelWithFontSize:15 linesNumber:3] + buttonMargin, buttonHight, buttonHight);
        imageView.image = [images lastObject];
        [self.textView addSubview:imageView];
        [imageViews addObject:imageView];
        
        if (imageViews.count == 6) {
            [addImage removeFromSuperview];
        }
    }
}

- (void)addImage:(id)sender{
    actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相机",@"从相册中添加", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self takePhoto];
    }else if (buttonIndex == 1){
        [self localPhoto];
    }
}

- (void)takePhoto{
    // 打开相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        [SVProgressHUD showErrorWithStatus:@"设备不支持相机" maskType:SVProgressHUDMaskTypeBlack];
    }
}

- (void)localPhoto{
    // 打开本地相册
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
//        [DocumentAccess saveImage:image withImageName:[date stringFromDate]];
        [images addObject:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        label.hidden = NO;
    }else{
        label.hidden = YES;
    }
}

- (IBAction)cancel:(id)sender {
//    [self.delegate AddNewsViewControllerDidCancel:self];
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)publish:(id)sender {
    [self.delegate AddNewsViewController:self DidFinishPublish:nil];
    
}
@end
