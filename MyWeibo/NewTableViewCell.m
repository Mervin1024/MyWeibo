

#import "NewTableViewCell.h"
#import "DocumentAccess.h"

@implementation NewTableViewCell

@synthesize avatar;
@synthesize name;
@synthesize description;
@synthesize weibo;
@synthesize weiboImages;

- (void) setAvatarAsRound
{
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.bounds.size.width/2;
}

- (void) setImages:(NSArray *)images{
    for (int i = 0; i < 3; i++) {
        if (i < images.count) {
            UIImageView *imageView = [weiboImages objectAtIndex:i];
            imageView.image = [[UIImage alloc]initWithContentsOfFile:[DocumentAccess stringOfFilePathForName:images[i]]];
            
        }else{
            UIImageView *imageView = [weiboImages objectAtIndex:i];
            imageView.image = nil;
        }
    }
}
@end