

#import "NewTableViewCell.h"
#import "DocumentAccess.h"
#import "MyWeiboData.h"
#import "UIImage+ImageFrame.h"
#import "UILabel+StringFrame.h"

@implementation NewTableViewCell

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

- (void)setImages:(NSArray *) images
{
    for (int i = 0; i < weiboImages.count; i++) {
        if (i < [images count]) {
            UIImageView * imageView = [weiboImages objectAtIndex:i];
            imageView.image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:images[i]]];
        } else {
            UIImageView * imageView = [weiboImages objectAtIndex:i];
            imageView.image = nil;
        }
        
    }
}

- (void) setImages:(NSArray *) images withLabelSize:(CGSize)size{
    for (int i = 0; i < images.count; i++) {
        CGFloat floatX = CELL_CONTENT_MARGIN * (i+1) + CELL_IMAGE_HIGHT * i;
        CGFloat floatY = CELL_CONTENT_MARGIN * 3 + CELL_AVATAR_HIGHT+size.height;
        UIImage *image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:images[i]]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(floatX, floatY, CELL_IMAGE_HIGHT, CELL_IMAGE_HIGHT)];
        imageView.image = image;
        [imageView setTag:3];
        [self.contentView addSubview:imageView];
    }
    
}

+ (CGFloat) heighForRowWithModel:(NewsModel *)newsModel{
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
}

@end