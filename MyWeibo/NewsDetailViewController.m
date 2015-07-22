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

@interface NewsDetailViewController ()<ImageScrollViewDelegate,UIScrollViewDelegate>{
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
    contentSize.width = tableViewContentRect.size.width*newsModel.images.count;
    myScrollView.contentSize = contentSize;
//
    
    
}

#pragma mark - Table view data source 协议
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLE_CONTENT_MARGIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [NewTableViewCell heighForRowWithStyle:NewsStyleOfDetail model:newsModel];
    }else if (indexPath.row == 1){
        return TABLE_CONTENT_MARGIN;
    }else{
        return 44.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return TABLE_CONTENT_MARGIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NewTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"NewCell" owner:self options:nil]lastObject];
        cell.avatar.image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:newsModel.user.avatar]];
        cell.weibo.text = newsModel.news_text;
        cell.description.text = newsModel.user.desc;
        if (newsModel.user.name) {
            cell.name.text = newsModel.user.name;
        }else{
            cell.name.text = newsModel.user.user_ID;
        }
        NSMutableArray *imageViews = [NSMutableArray array];
        CGFloat floatY = CELL_CONTENT_MARGIN * 3 + CELL_AVATAR_HIGHT+[cell.weibo boundingRectWithSize:CGSizeMake(CELL_TEXT_WIDTH, 0)].height;
        CGFloat floatX = CELL_CONTENT_MARGIN;
        CGFloat imageH = 0;
        for (int i = 0; i < 3; i++) {
            if (i < newsModel.images.count) {
                UIImage *image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:newsModel.images[i]]];
                imageH = image.size.height/image.size.width*CELL_TEXT_WIDTH/2;
            }
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(floatX, floatY, CELL_TEXT_WIDTH/2, imageH)];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedWithObject:)];
            imageView.tag = i+100;
            [imageView addGestureRecognizer:tap];
            [imageViews addObject:imageView];
            [cell.contentView addSubview:imageView];
            floatY +=imageH+CELL_CONTENT_MARGIN;
        }
        cell.weiboImages = [NSArray arrayWithArray:imageViews];
        [cell setImages:newsModel.images withStyle:NewsStyleOfDetail];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"grey"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
#pragma mark - 点击图片放大事件 GestureRecognizer
- (void) tappedWithObject:(UIGestureRecognizer *)sender{
    [self.view bringSubviewToFront:blankView];
    blankView.alpha = 1;
    CGRect frame = blankView.frame;
    frame.origin.y = self.tableView.contentOffset.y+self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    blankView.frame = frame;
//    NSLog(@"%@",NSStringFromCGPoint(self.tableView.contentOffset));
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
    for (int i = 0; i < newsModel.images.count; i++) {
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


@end
