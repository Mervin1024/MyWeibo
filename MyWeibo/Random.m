//


#import "Random.h"
#import "NSArray+Assemble.h"

@implementation Random

+ (BOOL) possibilityTenOfNum:(int)num
{
    if (arc4random() % 10 < num) {
        return YES;
    } else {
        return NO;
    }
}

+ (int) randZeroToNum:(int)num
{
    return arc4random() % num;
}

+ (NSString *) stringOfRandomWeibo:(int)length
{
    NSArray *weiboArray = [NSArray arrayWithObjects:
                           @"人生若只如初见，何事秋风悲画扇。",
                           @"曾经沧海难为水，除却巫山不是云。",
                           @"谁眼角朱红的泪痣成全了你的繁华一世、你金戈铁马的江山赠与谁一场石破惊天的空欢喜。",
                           @"下一世的情歌、把词交由你填、看看你仍旧是谁高高在上的王。",nil];

    NSMutableArray *weibos= [NSMutableArray array];
    int rand = [Random randZeroToNum:(int)weiboArray.count];
    for (int i = rand; weibos.count <= length; i = i + [Random randZeroToNum:2]) {
        i = i % weiboArray.count;
        [weibos addObject:weiboArray[i]];
        
    }
    
    return [weibos joinWithBoundary:@" "];
}

@end
