

#import "NewTableViewCell.h"
#import "DocumentAccess.h"
#import "MyWeiboData.h"
#import "UIImage+ImageFrame.h"
#import "UILabel+StringFrame.h"

@implementation NewTableViewCell{
    
}

@synthesize avatar;
@synthesize name;
@synthesize description;
@synthesize weibo;
@synthesize weiboImages;

- (void) layoutSubviews{
    [super layoutSubviews];

}

- (void) prepareForReuse{
    [super prepareForReuse];
    for (UIImageView *view in weiboImages) {
        view.image = nil;
    }
    
}

- (void) setAvatarAsRound
{
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.bounds.size.width/2;
}

- (void)setImages:(NSArray *)images withStyle:(NewsStyle)newsStyle
{
    for (int i = 0; i < weiboImages.count; i++) {
        if (i < [images count]) {
            UIImageView *imageView = [weiboImages objectAtIndex:i];
            imageView.image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:images[i]]];
            
        } else {
            UIImageView * imageView = [weiboImages objectAtIndex:i];
            imageView.image = nil;
        }
        
    }
}

+ (CGFloat) heighForRowWithStyle:(NewsStyle)newsStyle model:(NewsModel *)newsModel{
    if (newsStyle == NewsStyleOfList) {
        CGFloat imageHeight = 0.0f;
        if (newsModel.images.count > 0) {
            imageHeight += CELL_IMAGE_HIGHT + CELL_CONTENT_MARGIN;
        }
        UILabel *label = [UILabel new];
        label.text = newsModel.news_text;
        label.font = [UIFont systemFontOfSize:FONT_SIZE];
        CGFloat textHeigh = [label boundingRectWithSize:CGSizeMake(CELL_TEXT_WIDTH, 0)].height;
        
        CGFloat cellHeight = CELL_CONTENT_MARGIN * 3 + CELL_AVATAR_HIGHT + textHeigh + imageHeight;
        return cellHeight;
    }else if (newsStyle == NewsStyleOfDetail){
        CGFloat imageHeight = 0.0f;
        for (int i = 0; i < newsModel.images.count; i++) {
            UIImage *image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:newsModel.images[i]]];
            CGFloat imageH = image.size.height/image.size.width*CELL_TEXT_WIDTH/2;
            imageHeight += CELL_CONTENT_MARGIN+imageH;
        }
        UILabel *label = [UILabel new];
        label.text = newsModel.news_text;
        label.font = [UIFont systemFontOfSize:FONT_SIZE];
        CGFloat textHeigh = [label boundingRectWithSize:CGSizeMake(CELL_TEXT_WIDTH, 0)].height;
        CGFloat cellHeight = CELL_CONTENT_MARGIN * 3 + CELL_AVATAR_HIGHT + textHeigh + imageHeight;
        return cellHeight;
    }else{
        return 44.0f;
    }
}

@end