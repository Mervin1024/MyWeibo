

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "DropDownView.h"


#define CELL_BLANKVIEW_MARGIN 3.0f
#define CELL_CONTENT_MARGIN 13.0f
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
- (IBAction)dropDown:(id)sender;
- (void) setAvatarAsRound;

- (CGFloat)imageWidthAtBlankViewWithCellContentWidth:(CGFloat)width Images:(NSArray *)images style:(NewsStyle)newsStyle;
+ (CGFloat) imageWidthWithCellContentWidth:(CGFloat)width ImagesCount:(long)count style:(NewsStyle)style;
+ (CGFloat) heighForRowWithCellContentWidth:(CGFloat)width Style:(NewsStyle)newsStyle model:(NewsModel *)newsModel;
@end
