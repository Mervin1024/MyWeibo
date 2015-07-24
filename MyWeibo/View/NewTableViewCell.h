

#import <UIKit/UIKit.h>
#import "NewsModel.h"


//#define CELL_IMAGE_HIGHT 100.0f
#define CELL_BLANKVIEW_MARGIN 3.0f
#define CELL_CONTENT_WIDTH (self.frame.size.width)
#define CELL_CONTENT_MARGIN 13.0f
#define CELL_TEXT_WIDTH (self.frame.size.width-2*13)
#define CELL_AVATAR_HIGHT 30.0f
#define FONT_SIZE 15.0f

typedef enum {
    NewsStyleOfDetail,
    NewsStyleOfList
}NewsStyle;

@interface NewTableViewCell : UITableViewCell{
}


@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *weibo;
@property (strong, nonatomic) UIImageView *blankView;
- (void) setAvatarAsRound;

- (CGFloat)imageWidthAtBlankViewWithImagesCount:(long)count style:(NewsStyle)newsStyle;
+ (CGFloat) imageWidthWithCellContentWidth:(CGFloat)width ImagesCount:(long)count style:(NewsStyle)style;
+ (CGFloat) heighForRowWithCellContentWidth:(CGFloat)width Style:(NewsStyle)newsStyle model:(NewsModel *)newsModel;
@end
