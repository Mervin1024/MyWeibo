

#import <UIKit/UIKit.h>

@interface NewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *weibo;


@property (strong,nonatomic) IBOutletCollection(UIImageView) NSArray *weiboImages;

- (void) setAvatarAsRound;
- (void) setImages:(NSArray *) images;
@end
