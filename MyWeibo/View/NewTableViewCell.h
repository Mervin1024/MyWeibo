

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "DropDownView.h"
#import "MarkView.h"
#import "PersonalModel.h"

#define CELL_BLANKVIEW_MARGIN 3.0f
#define CELL_CONTENT_MARGIN 13.0f
#define CELL_AVATAR_HIGHT 30.0f
#define FONT_SIZE 15.0f

typedef enum {
    NewsStyleOfDetail,
    NewsStyleOfList
}NewsStyle;
@class NewTableViewCell;
@protocol NewTableViewCellDelegate <NSObject>
- (CGRect)frameOfSuperView;
- (UserType)userTypeOfNewTableViewCell:(NewTableViewCell *)cell;
- (void)didSelectedItem:(NSString *)item fromTableViewCell:(NewTableViewCell *)cell;
@optional
- (void)newTableViewCell:(NewTableViewCell *)cell didSelectButton:(UIButton *)button;
- (void)dismissFromNewTableViewCell:(NewTableViewCell *)cell;
@end

@interface NewTableViewCell : UITableViewCell<MarkViewDelegate,DropDownViewDelegate>{
//    NSArray *dropList;
}


@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *weibo;
@property (strong, nonatomic) UIImageView *blankView;
@property (weak, nonatomic) id<NewTableViewCellDelegate> delegate;
@property (strong, nonatomic) MarkView *myMarkView;
@property (strong, nonatomic) DropDownView *dropDown;
@property (assign, nonatomic) UserType userType;
- (IBAction)dropDown:(id)sender;
- (void) setAvatarAsRound;

- (CGFloat)imageWidthAtBlankViewWithCellContentWidth:(CGFloat)width Images:(NSArray *)images style:(NewsStyle)newsStyle;
+ (CGFloat) imageWidthWithCellContentWidth:(CGFloat)width ImagesCount:(long)count style:(NewsStyle)style;
+ (CGFloat) heighForRowWithCellContentWidth:(CGFloat)width Style:(NewsStyle)newsStyle model:(NewsModel *)newsModel;
@end
