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


@interface AddNewsViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIScrollViewDelegate>{
    UILabel *label;
    UIButton *addImageButton;
    UIActionSheet *actionSheet;
    UIScrollView *scrollView;
    NSMutableArray *images;             // UIImage
    NSMutableArray *imagesName;         // NSString
    NSMutableArray *imageViews;         // UIImageView
//    NSInteger rowOfTextContent; // textView.text --- row
    CGFloat addImageButtonHight;   // addImageButton
//    float textContentHightChange;   // textView.text --- heightChange
    
}

@end

@implementation AddNewsViewController
@synthesize addNewsType;

CGFloat const buttonMargin = 7.0f;
CGFloat const viewMargin = 16.0f;
CGFloat const aRowOfText = 18.0f;

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    images = [NSMutableArray array];
    imageViews = [NSMutableArray array];
    imagesName = [NSMutableArray array];
//    rowOfTextContent = 1;
    addImageButtonHight = 0.0f;
//    textContentHightChange = 0.0f;
    [self setView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setImageAndButton];
    // 选择添加方式
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
            addImageButton.hidden = YES;
            break;
        default:
            [self.textView becomeFirstResponder];
            break;
    }
    // 注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    // 注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}
#pragma mark - textView
- (void)setView{
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.showsHorizontalScrollIndicator = NO;
    
    // textView
    self.textView = [[AddingTextView alloc]initWithFrame:CGRectMake(viewMargin, viewMargin, self.view.frame.size.width-viewMargin*2, 0)];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.delegate = self;
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, self.textView.frame.size.height);
    [self.view addSubview:scrollView];
    [scrollView addSubview:self.textView];
    
    // label 提示标签
    label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:15];
    label.enabled = NO;
    label.text = @"分享新鲜事...";
    label.textColor = [UIColor lightGrayColor];
    label.frame = CGRectMake(buttonMargin, buttonMargin, self.view.bounds.size.width-viewMargin*2, [label boundingRectWithSize:CGSizeMake(self.view.bounds.size.width-viewMargin*2, 0)].height);
    label.numberOfLines = 1;
    [self.textView addSubview:label];
    if ([self.textView.text length] != 0) {
        label.hidden = YES;
    }
}
#pragma mark - ImageView and Button
- (void)setImageAndButton{
    
    // 有 image 更新
    if (images.count > imageViews.count) {
        // 更新 button 位置
        CGRect buttom = addImageButton.frame;
        buttom.origin.x = (images.count % 3) * (addImageButtonHight+buttonMargin) + self.textView.frame.origin.x;
        buttom.origin.y = images.count / 3 * (addImageButtonHight + buttonMargin) + self.textView.frame.origin.y+self.textView.frame.size.height+buttonMargin;
        addImageButton.frame = buttom;
        
       // 添加新 imageView
        AddingImageView *imageView = [[AddingImageView alloc]initWithFrame:CGRectMake((imageViews.count % 3) * (addImageButtonHight + buttonMargin) + self.textView.frame.origin.x, imageViews.count / 3 * (addImageButtonHight + buttonMargin) + self.textView.frame.origin.y+self.textView.frame.size.height+buttonMargin, addImageButtonHight, addImageButtonHight)];
        imageView.image = [images lastObject];
        imageView.m_delegate = self;
        imageView.tag = imageViews.count+10;
        [scrollView addSubview:imageView];
        [imageViews addObject:imageView];
    }else{
        // 更新 imageView 位置
        CGRect buttom = addImageButton.frame;
        buttom.origin.y = images.count / 3 * (addImageButtonHight + buttonMargin) + self.textView.frame.origin.y+self.textView.frame.size.height+buttonMargin;
        addImageButton.frame = buttom;
        
        for (int i = 0; i < imageViews.count; i++) {
            UIImageView *imageView = imageViews[i];
            CGRect frame = imageView.frame;
            frame.origin.y = i / 3 * (addImageButtonHight + buttonMargin) + self.textView.frame.origin.y+self.textView.frame.size.height+buttonMargin;
            imageView.frame = frame;
        }
        
    }
    
    CGFloat contentHeight = addImageButton.frame.origin.y+addImageButton.frame.size.height+buttonMargin;
    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, contentHeight)];
    
    // 初始化 button
    if (images.count == 0 && addImageButton == nil) {
        addImageButtonHight = (self.view.bounds.size.width-viewMargin*2-buttonMargin*4)/3.0;
        addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addImageButton.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y+viewMargin+buttonMargin+[UILabel hightOfLabelWithFontSize:15 linesNumber:1], addImageButtonHight, addImageButtonHight);
        addImageButton.backgroundColor = [UIColor clearColor];
        [addImageButton setBackgroundImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        addImageButton.adjustsImageWhenHighlighted = NO;
        [addImageButton addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:addImageButton];
    }
    // 限制添加图片数量
    if (imageViews.count == 9) {
        addImageButton.hidden = YES;
    }
    
}
#pragma mark - addImageButton 事件
- (void)addImage:(id)sender{
    // 按钮点击事件
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
#pragma mark - UIImagePickerController 协议方法
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
#pragma mark - textView 协议方法
- (void)textViewDidChange:(UITextView *)textView{
    // done 按钮启用
    if ([textView.text length] == 0) {
        label.hidden = NO;
        self.publishBarButton.enabled = NO;
        [self setImageAndButton];
    }else{
        label.hidden = YES;
        self.publishBarButton.enabled = YES;
    }
//    NSLog(@"%lu",(unsigned long)textView.text.length);
    if ([textView.text length] >= 200) {
        [SVProgressHUD showErrorWithStatus:@"请将字符控制在200以内"];
        self.publishBarButton.enabled = NO;
    }else{
        self.publishBarButton.enabled = YES;
    }
}
#pragma mark - AddingImageView 协议方法
- (void)AddingImageView:(AddingImageView *)imageView didSelectDeleteButton:(id)sender{
    // 点击按钮删除 imageView
    __block CGRect butFrame;
    [imageViews excetueEach:^(AddingImageView *image){
        CGRect imgFrame;
        if (image.tag < imageView.tag) {
            
        }else if (image.tag == imageView.tag){
            imgFrame = imageView.frame;
            [imageView removeFromSuperview];
            [images removeObject:image.image];
            [imagesName removeObjectAtIndex:image.tag-10];
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
    addImageButton.frame = butFrame;
    if (imageViews.count < 9) {
        addImageButton.hidden = NO;
    }
}
#pragma mark - AddingTextView 协议方法
- (void)textView:(AddingTextView *)textView heightChange:(CGFloat)height{

    [self setImageAndButton];
}

#pragma mark - 键盘通知事件
- (void)keyboardDidShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
//    CGSize contentSize = scrollView.contentSize;
//    contentSize.height += keyboardSize.height;
//    scrollView.contentSize = contentSize;
    CGRect frame = scrollView.frame;
    frame.size.height -= keyboardSize.height;
    scrollView.frame = frame;
}

- (void)keyboardDidHide:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
//    CGSize contentSize = scrollView.contentSize;
//    contentSize.height -= keyboardSize.height;
//    scrollView.contentSize = contentSize;
    CGRect frame = scrollView.frame;
    frame.size.height += keyboardSize.height;
    scrollView.frame = frame;
}
#pragma mark - BarButton 点击事件
- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)publish:(id)sender {
    [SVProgressHUD showWithStatus:@"正在发送^_^"];
    [self performSelector:@selector(publishNews) withObject:nil afterDelay:1];
}

- (void)publishNews{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *now = [date stringFromDate:[NSDate date]];
    
    NewsModel *news = [[NewsModel alloc]initWithNewsID:0 userID:[PersonalModel personalIDfromUserDefaults] text:self.textView.text imagesName:imagesName publicTime:now];
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
