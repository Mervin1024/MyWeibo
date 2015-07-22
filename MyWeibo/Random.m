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
    // YES = ?/10 概率
}

+ (int) randZeroToNum:(int)num
{
    return arc4random() % num;
    // 随机数 = 0 到 ?-1
}

+ (NSArray *) randNum:(int)num inZeroToNum:(int)numb{
    NSMutableArray *nums = [NSMutableArray array];
    NSMutableArray *numbs = [NSMutableArray array];
    for (int i = 0; i < numb; i++) {
        [numbs addObject:@(i)];
    }
    for (int i = 0; i < num; i++) {
        int a = arc4random() % numbs.count;
        [nums addObject:numbs[a]];
        [numbs removeObjectAtIndex:a];
    }
    return nums;
    // 从 numb 个数中随机抽取 num 个数
}


@end
