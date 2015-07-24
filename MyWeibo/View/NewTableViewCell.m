

#import "NewTableViewCell.h"
#import "DocumentAccess.h"
#import "MyWeiboData.h"
#import "UIImage+ImageFrame.h"
#import "UILabel+StringFrame.h"
#import "NewsTableViewController.h"

@implementation NewTableViewCell{
}

@synthesize avatar;
@synthesize name;
@synthesize description;
@synthesize weibo;
@synthesize blankView;

- (void) layoutSubviews{
    [super layoutSubviews];

}
#pragma mark - cell 重用
- (void) prepareForReuse{
    [super prepareForReuse];
    [blankView removeFromSuperview];
    
}
#pragma mark - avatar imageview 圆角
- (void) setAvatarAsRound
{
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.bounds.size.width/2;
}
#pragma mark - 添加微博图片区域图层
- (CGFloat)imageWidthAtBlankViewWithImagesCount:(long)count style:(NewsStyle)newsStyle{
    CGFloat imageWidth = 0.0f;
    if (count > 0) {
        imageWidth = [NewTableViewCell imageWidthWithCellContentWidth:CELL_TEXT_WIDTH ImagesCount:count style:newsStyle];
        blankView = [[UIImageView alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN*3+CELL_AVATAR_HIGHT+[self.weibo boundingRectWithSize:CGSizeMake(CELL_TEXT_WIDTH, 0)].height, CELL_CONTENT_WIDTH, (CELL_BLANKVIEW_MARGIN+(count-1)/3+1)*(imageWidth+CELL_BLANKVIEW_MARGIN))];
        blankView.userInteractionEnabled = YES;
        [self addSubview:blankView];
    }
    return imageWidth;
}

#pragma mark - 计算 image 高度
+ (CGFloat) imageWidthWithCellContentWidth:(CGFloat)width ImagesCount:(long)count style:(NewsStyle)style{
    long row = (count-1)/3+1;
    long column = (count-1)%3+1;
    CGFloat imageWidth = 0.0;
    CGFloat imageBound = 0.0;
    if (style == NewsStyleOfList) {
        imageBound = width/2;
        if (count > 0 && count < 10) {
            if (row == 1 && column == 1) {
                imageWidth = imageBound;
            }else if (row == 3){
                imageWidth = imageBound/3;
            }else{
                imageWidth = imageBound/2;
            }
        }
    }else if (style == NewsStyleOfDetail){
        imageBound = width;
        if (count > 0 && count < 10) {
            if (row == 1 && column == 1) {
                imageWidth = imageBound;
            }else if (row == 1 && column == 2){
                imageWidth = imageBound/2;
            }else if (row == 2 && column == 1){
                imageWidth = imageBound/2;
            }else{
                imageWidth = imageBound/3;
            }
        }
        
    }
    return imageWidth;
}
#pragma mark - 计算 cell 高度
+ (CGFloat) heighForRowWithCellContentWidth:(CGFloat)width Style:(NewsStyle)newsStyle model:(NewsModel *)newsModel{
    CGFloat blankViewHeigh = 0.0f;
    if (newsModel.imagesName.count != 0) {
        CGFloat imageWidth = [self imageWidthWithCellContentWidth:width ImagesCount:newsModel.imagesName.count style:newsStyle];
        blankViewHeigh = CELL_BLANKVIEW_MARGIN+((newsModel.imagesName.count-1)/3+1) * (imageWidth+CELL_BLANKVIEW_MARGIN);
    }
    
    
    UILabel *label = [UILabel new];
    label.text = newsModel.news_text;
    label.font = [UIFont systemFontOfSize:FONT_SIZE];
    CGFloat textHeigh = [label boundingRectWithSize:CGSizeMake(width-CELL_CONTENT_MARGIN*2, 0)].height;
    CGFloat cellHeight = CELL_CONTENT_MARGIN * 4 + CELL_AVATAR_HIGHT + textHeigh + blankViewHeigh;
    return cellHeight;
}

@end