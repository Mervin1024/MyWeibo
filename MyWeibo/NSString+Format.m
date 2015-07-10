//


#import "NSString+Format.h"

@implementation NSString (Format)

- (NSString *) stringSwapWithBoundary: (NSString *)boundary
{
    NSString *res = boundary;
    res = [res stringByAppendingString:self];
    res = [res stringByAppendingString:boundary];
    return res;
}

@end
