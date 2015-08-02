

//#import <QuartzCore/QuartzCore.h>
#import "NewTableViewCell.h"
#import "DocumentAccess.h"
#import "MyWeiboData.h"
#import "UIImage+ImageFrame.h"
#import "UILabel+StringFrame.h"
#import "NewsTableViewController.h"
#import "MarkView.h"
#import "SVProgressHUD.h"

@implementation NewTableViewCell{
    MarkView *myMarkView;
    DropDownView *dropDown;
    NSArray *dropList;
    UserType userType;
}

@synthesize avatar;
@synthesize name;
@synthesize description;
@synthesize weibo;
@synthesize blankView,myMarkView,dropDown;

- (void) layoutSubviews{
    [super layoutSubviews];

}
#pragma mark - cell 重用
- (void) prepareForReuse{
    [super prepareForReuse];
    [blankView removeFromSuperview];
    
}

- (IBAction)dropDown:(id)sender {
    [self.delegate newTableViewCell:self didSelectButton:sender];
    userType = [self.delegate userTypeOfNewTableViewCell:self];
    CGRect frame = [self.delegate frameOfSuperView];
    myMarkView = [[MarkView alloc]initWithFrame:frame];
    myMarkView.backgroundColor = [UIColor blackColor];
    myMarkView.alpha = 0.5;
    myMarkView.delegate = self;
    [self.superview addSubview:myMarkView];
    if (userType == UserTypePersonal) {
        dropList = @[@"收藏",@"置顶",@"推广",@"删除"];
    }else{
        dropList = @[@"收藏",@"帮上头条",@"取消关注",@"屏蔽",@"举报"];
    }
    CGRect dropDownFrame;
    dropDownFrame.size.width = 300;
    dropDownFrame.size.height = dropList.count*DROPDOWN_CELL_HEIGHT;
    dropDownFrame.origin.x = frame.size.width/2-dropDownFrame.size.width/2;
    dropDownFrame.origin.y = frame.size.height/2-dropDownFrame.size.height/2+frame.origin.y;
    dropDown = [[DropDownView alloc]initWithFrame:dropDownFrame dropList:dropList userType:userType];
    dropDown.backgroundColor = [UIColor whiteColor];
    [self.superview addSubview:dropDown];
    dropDown.delegate = self;
    
}

- (void)markView:(MarkView *)markView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.delegate dismissFromNewTableViewCell:self];
}

- (void)dropDownView:(DropDownView *)dropDownView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (userType == UserTypeFans) {
        if ([dropDownView.dropList[indexPath.row] isEqualToString:@"屏蔽"]) {
            [self.delegate deleteNewsFromNewTableViewCell:self withUserType:UserTypeFans];
            [SVProgressHUD showSuccessWithStatus:@"我不听我不听我不听\nヽ(｀ Д ´ )ﾉ"];
            
        }else if ([dropDownView.dropList[indexPath.row] isEqualToString:@"收藏"]){
            [SVProgressHUD showSuccessWithStatus:@"这条微博我承包了\n(｀・ω・´)"];
            
        }else if ([dropDownView.dropList[indexPath.row] isEqualToString:@"帮上头条"]){
            [SVProgressHUD showSuccessWithStatus:@"我只能帮你到这儿了\n(￣3￣)"];
            
        }else if ([dropDownView.dropList[indexPath.row] isEqualToString:@"取消关注"]){
            [SVProgressHUD showSuccessWithStatus:@"别让我再看见你\n(￣ε(#￣) Σ"];
            
        }else if ([dropDownView.dropList[indexPath.row] isEqualToString:@"举报"]){
            [SVProgressHUD showSuccessWithStatus:@"警察叔叔就是这个人\nΣ(ﾟдﾟ;)"];
            
        }
    }else if (userType == UserTypePersonal){
        if ([dropDownView.dropList[indexPath.row] isEqualToString:@"删除"]) {
            [self.delegate deleteNewsFromNewTableViewCell:self withUserType:UserTypePersonal];
            [SVProgressHUD showSuccessWithStatus:@"这条是我表弟刚才写的\n←_←"];
            
        }else if ([dropDownView.dropList[indexPath.row] isEqualToString:@"收藏"]){
            [SVProgressHUD showSuccessWithStatus:@"我说的真有道理\n╮(￣▽￣)╭"];
            
        }else if ([dropDownView.dropList[indexPath.row] isEqualToString:@"置顶"]){
            [SVProgressHUD showSuccessWithStatus:@"给我去最上面\n(╯°口°)╯"];
            
        }else if ([dropDownView.dropList[indexPath.row] isEqualToString:@"推广"]){
            [SVProgressHUD showSuccessWithStatus:@"(一条五毛,括号删掉)\n(^・ω・^ )"];
            
        }

    }
        [self.delegate dismissFromNewTableViewCell:self];
}

//- (void)dismiss:(id)sender{
//    [SVProgressHUD dismiss];
//}

#pragma mark - avatar imageview 圆角
- (void) setAvatarAsRound
{
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.bounds.size.width/2;
}
#pragma mark - 添加微博图片区域图层
- (CGFloat)imageWidthAtBlankViewWithCellContentWidth:(CGFloat)width Images:(NSArray *)images style:(NewsStyle)newsStyle{
    CGFloat imageWidth = 0.0f;
    if (images.count > 0) {
        imageWidth = [NewTableViewCell imageWidthWithCellContentWidth:width ImagesCount:images.count style:newsStyle];
        CGFloat imageHeight = imageWidth;
        if (images.count == 1 && newsStyle == NewsStyleOfDetail) {
            UIImage *image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:images[0]]];
            imageHeight = image.size.height/image.size.width*imageWidth;
        }
        CGFloat blankViewHight = CELL_BLANKVIEW_MARGIN+((images.count-1)/3+1)*(imageHeight+CELL_BLANKVIEW_MARGIN);
        blankView = [[UIImageView alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN*3+CELL_AVATAR_HIGHT+[self.weibo boundingRectWithSize:CGSizeMake(width, 0)].height, width, blankViewHight)];
        blankView.userInteractionEnabled = YES;
        blankView.backgroundColor = UIColor.whiteColor;
//        blankView.layer.borderColor = UIColor.grayColor.CGColor;
//        blankView.layer.borderWidth = 5;
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
        imageBound = (width-CELL_BLANKVIEW_MARGIN*3)/2;
        if (count > 0 && count < 10) {
            if (row == 1 && column == 1) {
                imageWidth = imageBound;
            }else{
                imageWidth = (imageBound-CELL_BLANKVIEW_MARGIN)/2;
            }
        }
    }else if (style == NewsStyleOfDetail){
        imageBound = width-CELL_BLANKVIEW_MARGIN*2;
        if (count > 0 && count < 10) {
            if (row == 1 && column == 1) {
                imageWidth = imageBound;
            }else if (row == 1 && column == 2){
                imageWidth = (imageBound-CELL_BLANKVIEW_MARGIN)/2;
            }else if (row == 2 && column == 1){
                imageWidth = (imageBound-CELL_BLANKVIEW_MARGIN)/2;
            }else{
                imageWidth = (imageBound-CELL_BLANKVIEW_MARGIN*2)/3;
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
        CGFloat imageHeight = imageWidth;
        if (newsModel.imagesName.count == 1 && newsStyle == NewsStyleOfDetail) {
            UIImage *image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:newsModel.imagesName[0]]];
            imageHeight = image.size.height/image.size.width*imageWidth;
        }
        blankViewHeigh = CELL_BLANKVIEW_MARGIN+((newsModel.imagesName.count-1)/3+1) * (imageHeight+CELL_BLANKVIEW_MARGIN);
    }
    
    
    UILabel *label = [UILabel new];
    label.text = newsModel.news_text;
    label.font = [UIFont systemFontOfSize:FONT_SIZE];
    CGFloat textHeigh = [label boundingRectWithSize:CGSizeMake(width-CELL_CONTENT_MARGIN*2, 0)].height;
    CGFloat cellHeight = CELL_CONTENT_MARGIN * 4 + CELL_AVATAR_HIGHT + textHeigh + blankViewHeigh;
    return cellHeight;
}

@end