

#import "NewTableViewCell.h"

@implementation NewTableViewCell

@synthesize avatar;
@synthesize name;
@synthesize description;
@synthesize weibo;
@synthesize weiboImage;

- (void) setAvatarAsRound
{
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.bounds.size.width/2;
}
@end