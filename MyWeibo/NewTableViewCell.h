

#import <UIKit/UIKit.h>
#import "NewsModel.h"

#define CELL_CONTENT_WIDTH 375.0f
#define CELL_CONTENT_MARGIN 13.0f
#define CELL_TEXT_WIDTH 349.0f
#define FONT_SIZE 17.0f
#define CELL_IMAGE_WIDTH 105.0f

@interface NewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *weibo;


@property (strong,nonatomic) IBOutletCollection(UIImageView) NSArray *weiboImages;

- (void) setAvatarAsRound;
- (void) setImages:(NSArray *) images;
+ (CGFloat) heighForRowWithModel:(NewsModel *)newsModel;
@end
