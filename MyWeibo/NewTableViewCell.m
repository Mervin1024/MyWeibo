

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
//    NSLog(@"sefl.weibo.size:%@",NSStringFromCGSize(self.weibo.bounds.size));
//    NSLog(@"sefl.content.size:%@",NSStringFromCGSize(self.contentView.bounds.size));
//    UIImageView *imageView = self.weiboImages[0];
//    NSLog(@"sefl.image.size:%@",NSStringFromCGSize(imageView.bounds.size));
//    NSLog(@"sefl.avatar.size:%@",NSStringFromCGSize(self.avatar.bounds.size));
}

- (void) setAvatarAsRound
{
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.bounds.size.width/2;
}

- (void) setImages:(NSArray *)images{
    if (images.count == 0) {
        for (int i = 0; i < 3; i++) {
            UIImageView *imageView = [weiboImages objectAtIndex:i];
            imageView.image = nil;
        }
    }else{
        for (int i = 0; i < 3; i++) {
            if (i < images.count) {
                UIImageView *imageView = [weiboImages objectAtIndex:i];
                //            imageView.image = [[UIImage alloc]initWithContentsOfFile:[DocumentAccess stringOfFilePathForName:images[i]]];
                imageView.image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:images[i]]];
                
            }else{
                UIImageView *imageView = [weiboImages objectAtIndex:i];
                imageView.image = nil;
            }
        }
    }
}

+ (CGFloat) heighForRowWithModel:(NewsModel *)newsModel{
    CGFloat imageHeight = 0.0f;
    if (newsModel.images.count > 0) {
        for (int i = 0; i < newsModel.images.count; i++) {
            UIImage *image = [UIImage imageWithContentsOfFile:[DocumentAccess stringOfFilePathForName:newsModel.images[i]]];
            imageHeight = imageHeight + [image sizeOfViewImage:CELL_IMAGE_WIDTH].height;
        }
    }
    UILabel *label = [UILabel new];
    label.text = newsModel.news_text;
    label.font = [UIFont systemFontOfSize:FONT_SIZE];
    CGFloat textHeigh = [label boundingRectWithSize:CGSizeMake(CELL_TEXT_WIDTH, 0)].height;
    // 雾
    return textHeigh;
}

@end