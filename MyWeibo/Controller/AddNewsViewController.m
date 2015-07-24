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
#import "NewsModel.h"
#import "MyWeiboData.h"
#import "PersonalModel.h"
#import "AddingImageView.h"

@interface AddNewsViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>{
    UILabel *label;
    UIButton *addImage;
    UIActionSheet *actionSheet;
    NSMutableArray *images;
    NSMutableArray *imagesName;
    NSMutableArray *imageViews;
    CGFloat buttonHight;
}

@end

@implementation AddNewsViewController
@synthesize addNewsType;
CGFloat const buttonMargin = 7.0f;
CGFloat const viewMargin = 16.0f;
- (void)viewDidLoad {
    [super viewDidLoad];
    images = [NSMutableArray array];
    imageViews = [NSMutableArray array];
    imagesName = [NSMutableArray array];
    [self setView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setImageAndButton];
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
            [self.textView becomeFirstResponder];
            addImage.hidden = YES;
            break;
        default:
            [self.textView becomeFirstResponder];
            break;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self setImageAndButton];
}

- (void)setView{
    
    label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:15];
    label.enabled = NO;
    label.text = @"分享新鲜事...";
    label.textColor = [UIColor lightGrayColor];
    label.frame = CGRectMake(buttonMargin, buttonMargin, self.view.bounds.size.width-viewMargin*2, [label hightOfLabelWithFontSize:15 linesNumber:1]);
    label.numberOfLines = 0;
    [self.textView addSubview:label];
    
    
    
}

- (void)setImageAndButton{
    if (images.count == 0 && addImage == nil) {
        buttonHight = (self.view.bounds.size.width-viewMargin*2-buttonMargin*4)/3.0;
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
        AddingImageView *imageView = [[AddingImageView alloc]initWithFrame:CGRectMake((imageViews.count % 3) * (buttonHight + buttonMargin) + buttonMargin, imageViews.count / 3 * (buttonHight + buttonMargin) + label.frame.origin.y+[label hightOfLabelWithFontSize:15 linesNumber:3] + buttonMargin, buttonHight, buttonHight)];
        imageView.image = [images lastObject];
        imageView.m_delegate = self;
        imageView.tag = imageViews.count+10;
        [self.textView addSubview:imageView];
        [imageViews addObject:imageView];
    }
    if (imageViews.count == 6) {
        addImage.hidden = YES;
    }
}

- (void)addImage:(id)sender{
    actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相机",@"从相册中添加", nil];
    [actionSheet showInView:self.view];
    [self.textView resignFirstResponder];
}

- (void)actionSheet:(UIActionSheet *)mactionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self takePhoto];
    }else if (buttonIndex == 1){
        [self localPhoto];
    }else if (buttonIndex == actionSheet.cancelButtonIndex){
        [self.textView becomeFirstResponder];
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
        
        [self.textView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:1.0];
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
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSString *imageName = [date stringFromDate];
        [images addObject:image];
        [imagesName addObject:imageName];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        label.hidden = NO;
        self.publishBarButton.enabled = NO;
    }else{
        label.hidden = YES;
        self.publishBarButton.enabled = YES;
    }
}

- (void)AddingImageView:(AddingImageView *)imageView didSelectDeleteButton:(id)sender{
    __block CGRect butFrame;
    [imageViews excetueEach:^(AddingImageView *image){
        CGRect imgFrame;
        if (image.tag < imageView.tag) {
            
        }else if (image.tag == imageView.tag){
            imgFrame = imageView.frame;
            [imageView removeFromSuperview];
            [images removeObject:image.image];
            butFrame = imgFrame;
        }else{
            image.tag -= 1;
            CGRect imageFrame = image.frame;
            image.frame = imgFrame;
            imgFrame = imageFrame;
            butFrame = imageFrame;
        }
    }];
    [imageViews removeObject:imageView];
    addImage.frame = butFrame;
    if (imageViews.count < 6) {
        addImage.hidden = NO;
    }
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)publish:(id)sender {
    [SVProgressHUD showWithStatus:@"正在发送^_^"];
    [self performSelector:@selector(publishNews) withObject:nil afterDelay:0.5];
}

- (void)publishNews{
    NewsModel *news = [[NewsModel alloc]initWithNewsID:0 userID:[PersonalModel personalIDfromUserDefaults] text:self.textView.text imagesName:imagesName];
    NSDictionary *dic = @{@"news":news};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddNewsNotification" object:self userInfo:dic];
    
    for (int i = 0; i < images.count && i < imagesName.count; i++) {
        [DocumentAccess saveImage:images[i] withImageName:imagesName[i]];
    }
    [SVProgressHUD dismiss];
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
