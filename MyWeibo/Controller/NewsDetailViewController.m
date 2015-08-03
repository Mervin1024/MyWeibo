//
//  NewsDetailViewController.m
//  MyWeibo
//
//  Created by 马遥 on 15/7/14.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewTableViewCell.h"
#import "DocumentAccess.h"
#import "UILabel+StringFrame.h"
#import "ImageScrollView.h"
#import "NSArray+Assemble.h"
#import "CommentCell.h"
#import "SVProgressHUD.h"
#import "CommentCellMethod.h"

@interface NewsDetailViewController ()<ImageScrollViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,CommentCellDelegate>{
    CGRect tableViewContentRect;
    UIView *blankView; //背景层
    UIView *markView; // 渐变层
    UIScrollView *myScrollView;
    NSInteger index; // 所点击图片的index
    ImageScrollView *lastImageScrollView;
}

@end

@implementation NewsDetailViewController
@synthesize newsModel;

#pragma mark - view 视图初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.toolbarHidden == YES) {
        [self.navigationController setToolbarHidden:NO animated:NO];
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController.toolbarHidden == NO) {
        [self.navigationController setToolbarHidden:YES animated:NO];
    }
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - 设置点击放大图层
- (void)setView{                         // 图片点击放大图层
    
    tableViewContentRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.navigationController.toolbar.frame.size.height-[[UIApplication sharedApplication]statusBarFrame].size.height);
    // 背景层
    blankView = [[UIView alloc]initWithFrame:tableViewContentRect];
    blankView.backgroundColor = [UIColor clearColor];
    blankView.alpha = 0;
    [self.view addSubview:blankView];
    // 渐变层
    markView = [[UIView alloc]initWithFrame:blankView.frame];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0;
    [blankView addSubview:markView];
    // scrollView层
    myScrollView = [[UIScrollView alloc]initWithFrame:tableViewContentRect];
    myScrollView.backgroundColor = [UIColor clearColor];
    [blankView addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = tableViewContentRect.size.height;
    contentSize.width = tableViewContentRect.size.width*newsModel.imagesName.count;
    myScrollView.contentSize = contentSize;
//
    
}

#pragma mark - Table view data source 协议
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLE_CONTENT_MARGIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [NewTableViewCell heighForRowWithCellContentWidth:(TABLE_CELL_CONTENT_WIDTH-CELL_CONTENT_MARGIN*2) Style:NewsStyleOfDetail model:newsModel];
    }else if (indexPath.row == 1){
        return TABLE_CONTENT_MARGIN;
    }else{
        return 35.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return TABLE_CONTENT_MARGIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NewCell" owner:self options:nil]lastObject];
        }
        cell.delegate = self;
        cell.avatar.image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:newsModel.user.avatar]];
        cell.weibo.text = newsModel.news_text;
        cell.desc.text = newsModel.user.desc;
        if (newsModel.user.name) {
            cell.name.text = newsModel.user.name;
        }else{
            cell.name.text = newsModel.user.user_ID;
        }
        [self tableViewCell:cell setImages:newsModel.imagesName withStyle:NewsStyleOfDetail];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"grey"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil]lastObject];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
#pragma mark - NewTableViewCell 协议方法
- (CGRect)frameOfSuperView{
    CGRect frame = self.view.frame;
    frame.origin = self.tableView.contentOffset;
    return frame;
}

- (UserType)userTypeOfNewTableViewCell:(NewTableViewCell *)cell{
    if ([newsModel.user_id isEqualToString:[PersonalModel personalIDfromUserDefaults]]) {
        return UserTypePersonal;
    }
    return UserTypeFans;
}

- (void)newTableViewCell:(NewTableViewCell *)cell didSelectButton:(UIButton *)button{
    self.tableView.scrollEnabled = NO;
}

- (void)dismissFromNewTableViewCell:(NewTableViewCell *)cell{
    [UIView animateWithDuration:0.3 animations:^{
        cell.myMarkView.alpha = 0;
    }];
    self.tableView.scrollEnabled = YES;
}

- (void)didSelectedItem:(NSString *)item FromTableViewCell:(NewTableViewCell *)cell{
    if (cell.userType == UserTypePersonal) {
        if ([item isEqualToString:@"删除"]) {
            [self deleteNewsFromNewTableViewCell:cell withUserType:UserTypePersonal];
            //            [SVProgressHUD showSuccessWithStatus:@"这条是我表弟刚才写的\n←_←"];
            
        }else if ([item isEqualToString:@"收藏"]){
            [SVProgressHUD showSuccessWithStatus:@"我说的真有道理\n（￣▽￣）"];
            
        }else if ([item isEqualToString:@"置顶"]){
            [SVProgressHUD showSuccessWithStatus:@"给我去最上面\n(╯°口°)╯"];
            
        }else if ([item isEqualToString:@"推广"]){
            [SVProgressHUD showSuccessWithStatus:@"(一条五毛,括号删掉)\n(^・ω・^ )"];
            
        }
        
    }else if (cell.userType == UserTypeFans){
        if ([item isEqualToString:@"屏蔽"]) {
            [self deleteNewsFromNewTableViewCell:cell withUserType:UserTypeFans];
            
        }else if ([item isEqualToString:@"收藏"]){
            [SVProgressHUD showSuccessWithStatus:@"这条微博我承包了\n(｀・ω・´)"];
            
        }else if ([item isEqualToString:@"帮上头条"]){
            [SVProgressHUD showSuccessWithStatus:@"我只能帮你到这儿了\n(￣3￣)"];
            
        }else if ([item isEqualToString:@"取消关注"]){
            [self cancelAttention];
            //            [SVProgressHUD showSuccessWithStatus:@"别让我再看见你\n(￣ε(#￣) Σ"];
            
        }else if ([item isEqualToString:@"举报"]){
            [SVProgressHUD showSuccessWithStatus:@"警察叔叔就是这个人\nΣ(ﾟдﾟ;)"];
        }
    }
}

- (void)cancelAttention{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"真的不想再看见这个人?" delegate:self cancelButtonTitle:@"不是的!" otherButtonTitles:@"嗯,是的", nil];
    [alertView show];
}

- (void)deleteNewsFromNewTableViewCell:(NewTableViewCell *)cell withUserType:(UserType)userType{
    NSString *message;
    NSString *cancel;
    NSString *done;
    if (userType == UserTypeFans) {
        message = @"你确定不想看见这条微博吗?";
        cancel = @"确定";
        done = @"肯定";
    }else if (userType == UserTypePersonal){
        message = @"你真的要否认你刚才说的话吗?";
        cancel = @"不是这样的";
        done = @"我开玩笑的";
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:done, nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"] || [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"肯定"]) {
        if (newsModel == nil) {
        }else{
            [SVProgressHUD showSuccessWithStatus:@"我不听我不听我不听\nヽ(｀ Д ´ )ﾉ"];
            [self.delegate deleteNews:newsModel];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"不是这样的"] || [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"我开玩笑的"]){
        [SVProgressHUD showErrorWithStatus:@"那就不删除了\n(=・ω・=)"];
    }else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"不是的!"]){
        [SVProgressHUD showErrorWithStatus:@"那就再给你一次机会\n（￣へ￣）"];
    }else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"嗯,是的"]){
        [SVProgressHUD showErrorWithStatus:@"然而并没有这个功能\n_(:3」∠)_"];
    }
    
}
#pragma mark - CommentCell 协议方法

- (void)commentCell:(CommentCell *)cell Comment:(id)sender{
    CommentCellMethod *commentMethod = [[CommentCellMethod alloc]initWithNewsModel:newsModel];
    [commentMethod Comment];
}

- (void)commentCell:(CommentCell *)cell forward:(id)sender{
    CommentCellMethod *commentMethod = [[CommentCellMethod alloc]initWithNewsModel:newsModel];
    [commentMethod forward];
}

- (void)commentCell:(CommentCell *)cell Praise:(id)sender{
    CommentCellMethod *commentMethod = [[CommentCellMethod alloc]initWithNewsModel:newsModel];
    [commentMethod Praise];
}

#pragma mark - 动态加载 imageview
- (void)tableViewCell:(NewTableViewCell *)cell setImages:(NSArray *)images withStyle:(NewsStyle)newsStyle
{
    CGFloat imageWidth = [cell imageWidthAtBlankViewWithCellContentWidth:TABLE_CELL_CONTENT_WIDTH-CELL_CONTENT_MARGIN*2 Images:images style:newsStyle];
    if (imageWidth != 0) {
        
        for (int i = 0; i < images.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            if (images.count == 1) {
                UIImage *image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:images[i]]];
                CGFloat imageHeight = image.size.height/image.size.width*imageWidth;
                imageView.frame = CGRectMake(0+CELL_BLANKVIEW_MARGIN, 0+CELL_BLANKVIEW_MARGIN, imageWidth, imageHeight);
            }else if (images.count == 4) {
                imageView.frame = CGRectMake((i%2)*(imageWidth+CELL_BLANKVIEW_MARGIN)+CELL_BLANKVIEW_MARGIN, (i/2)*(imageWidth+CELL_BLANKVIEW_MARGIN)+CELL_BLANKVIEW_MARGIN, imageWidth, imageWidth);
            }else{
                imageView.frame = CGRectMake((i%3)*(imageWidth+CELL_BLANKVIEW_MARGIN)+CELL_BLANKVIEW_MARGIN, (i/3)*(imageWidth+CELL_BLANKVIEW_MARGIN)+CELL_BLANKVIEW_MARGIN, imageWidth, imageWidth);
            }
            imageView.image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:images[i]]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [cell.blankView addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedWithObject:)];
            imageView.tag = i+100;
            [imageView addGestureRecognizer:tap];
        }
    }
}

#pragma mark - 点击图片放大事件 GestureRecognizer
- (void) tappedWithObject:(UIGestureRecognizer *)sender{
    [self.view bringSubviewToFront:blankView];
    blankView.alpha = 1;
    CGRect frame = blankView.frame;
    frame.origin.y = self.tableView.contentOffset.y+self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    blankView.frame = frame;
    self.tableView.scrollEnabled = NO;
    UIImageView *imageView = (id)sender.view;
    index = imageView.tag-100;
    // 转化后的rect
    
    CGRect convertRect = [[imageView superview] convertRect:imageView.frame toView:self.view];
    convertRect = (CGRect){convertRect.origin.x,convertRect.origin.y-(self.tableView.contentOffset.y+self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height),convertRect.size};
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = index*tableViewContentRect.size.width;
    myScrollView.contentOffset = contentOffset;
    
    // 添加
    [self addSubImageView:imageView];
    
    lastImageScrollView = [[ImageScrollView alloc]initWithFrame:(CGRect){contentOffset, myScrollView.bounds.size}];
    [lastImageScrollView setContentWithFrame:convertRect];
    [lastImageScrollView setImage:imageView.image];
    [myScrollView addSubview:lastImageScrollView];
    lastImageScrollView.i_delegate = self;
    [self performSelector:@selector(setOriginFrame:) withObject:lastImageScrollView afterDelay:0.1];
}

- (void) setOriginFrame:(ImageScrollView *)sender{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1;
    }];
}

- (void) addSubImageView:(UIImageView *)imageView{
    [myScrollView.subviews excetueEach:^(UIView *tmpView){
        [tmpView removeFromSuperview];
    }];
    for (int i = 0; i < newsModel.imagesName.count; i++) {
        if (i == index) {
            continue;
        }
        
        UIImageView *tmpView = (UIImageView *)[[imageView superview] viewWithTag:i+100];
        
        // 转化后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
        convertRect = (CGRect){convertRect.origin.x,convertRect.origin.y-(self.tableView.contentOffset.y+self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height),convertRect.size};
        lastImageScrollView = [[ImageScrollView alloc]initWithFrame:CGRectMake(i*myScrollView.bounds.size.width, 0, myScrollView.bounds.size.width, myScrollView.bounds.size.height)];
        [lastImageScrollView setContentWithFrame:convertRect];
        [lastImageScrollView setImage:tmpView.image];
        [myScrollView addSubview:lastImageScrollView];
        lastImageScrollView.i_delegate = self;
        [lastImageScrollView setAnimationRect];

    }
}
#pragma mark - Image Scroll View Delegate 协议
- (void) tapImageViewTappedWithObject:(id)sender{

    ImageScrollView *tmpImgView = sender;
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
    }completion:^(BOOL finished){
        blankView.alpha = 0;
        self.tableView.scrollEnabled = YES;
    }];
}
#pragma mark - scroll view delegate 协议
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageW = scrollView.frame.size.width;
    index = floor((scrollView.contentOffset.x-pageW/2)/pageW)+1;
}


- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
