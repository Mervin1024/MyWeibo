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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setView{                         // 图片点击放大图层
    
    tableViewContentRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height-[[UIApplication sharedApplication]statusBarFrame].size.height);
    // 背景层
    blankView = [[UIView alloc]initWithFrame:tableViewContentRect];
    blankView.backgroundColor = [UIColor clearColor];
    blankView.alpha = 1;
    [self.view addSubview:blankView];
    // 渐变层
    markView = [[UIView alloc]initWithFrame:blankView.frame];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 1;
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
//    NSLog(@"%@",NSStringFromCGRect([[UIApplication sharedApplication]statusBarFrame]));
    
}

#pragma mark - Table view data source


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

- (void) tappedWithObject:(UIGestureRecognizer *)sender{
    [self.view bringSubviewToFront:blankView];
    blankView.alpha = 1;
    UIImageView *imageView = (id)sender.view;
    index = imageView.tag-100;
    // 转化后的rect
    CGRect convertRext = [[imageView superview] convertRect:imageView.frame toView:self.view];
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = index*tableViewContentRect.size.width;
    myScrollView.contentOffset = contentOffset;
    
    // 添加
    [self addSubImageView:imageView];
    
    lastImageScrollView = [[ImageScrollView alloc]initWithFrame:(CGRect){contentOffset, myScrollView.bounds.size}];
    [lastImageScrollView setContentWithFrame:convertRext];
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
    for (UIView *tmpView in myScrollView.subviews) {
        [tmpView removeFromSuperview];
    }
    for (int i = 0; i < newsModel.images.count; i++) {
        if (i == index) {
            continue;
        }
        
        UIImageView *tmpView = (UIImageView *)[[imageView superview] viewWithTag:i+100];
        
        // 转化后的rect
        CGRect converRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
        lastImageScrollView = [[ImageScrollView alloc]initWithFrame:CGRectMake(i*myScrollView.bounds.size.width, 0, myScrollView.bounds.size.width, myScrollView.bounds.size.height)];
        [lastImageScrollView setContentWithFrame:converRect];
        [lastImageScrollView setImage:tmpView.image];
        [myScrollView addSubview:lastImageScrollView];
        lastImageScrollView.i_delegate = self;
        [lastImageScrollView setAnimationRect];

    }

}

- (void) tapImageViewTappedWithObject:(id)sender{

    ImageScrollView *tmpImgView = sender;
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
    }completion:^(BOOL finished){
        blankView.alpha = 0;
    }];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageW = scrollView.frame.size.width;
    index = floor((scrollView.contentOffset.x-pageW/2)/pageW)+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return CELL_CONTENT_MARGIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [NewTableViewCell heighForRowWithStyle:NewsStyleOfDetail model:newsModel];
    }else if (indexPath.row == 1){
        return 13.0f;
    }else{
        return 44.0f;
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


@end
