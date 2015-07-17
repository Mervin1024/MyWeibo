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
#import "imageScrollView.h"

@interface NewsDetailViewController ()<ImageScrollViewDelegate,UIScrollViewDelegate>{
    UIView *blankView;
    UIView *markView;
    UIScrollView *myScrollView;
    
    imageScrollView *lastImageScrollView;
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

- (void)setView{
    blankView = [[UIView alloc]initWithFrame:self.view.frame];
    blankView.backgroundColor = [UIColor clearColor];
    blankView.alpha = 0;
    [self.view addSubview:blankView];
    
    markView = [[UIView alloc]initWithFrame:blankView.frame];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0;
    [blankView addSubview:markView];
    
    myScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [blankView addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = self.view.bounds.size.height;
    contentSize.width = self.view.bounds.size.width*3;
    myScrollView.contentSize = contentSize;
    
    
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
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
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
//        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tapped:(UIGestureRecognizer *)gestureRecognizer{
//    NSLog(@"there");
    if ([self respondsToSelector:@selector(tappedWithObject:)]) {
        [self tappedWithObject:gestureRecognizer.view];
    }
}

- (void) tappedWithObject:(id)sender{
    UIImageView *image = sender;
    NSLog(@"%@",NSStringFromCGRect(image.frame));
    
}

- (void) tapImageViewTappedWithObject:(id)sender{
    
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
