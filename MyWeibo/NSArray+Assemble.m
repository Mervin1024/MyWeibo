


#import "NSArray+Assemble.h"
#import "NSString+Format.h"

@implementation NSArray (Assemble)
- (NSString *) joinWithBoundary:(NSString *)boundary
{
    NSString *mapString = @"";
    
    for (int i = 0; i < self.count; i++) {
        mapString = [mapString stringByAppendingString: self[i]];
        if (i < self.count - 1) {
            mapString = [mapString stringByAppendingString: boundary];
        }
    }
    
    return mapString;
}
- (NSString *) joinToStringWithBoundary:(NSString *) boundary
{
    NSString *mapString = @"";

    for (int i = 0; i < self.count; i++) {
        mapString = [mapString stringByAppendingString: [(NSString *)self[i] stringSwapWithBoundary:@"'"]];
        if (i < self.count - 1) {
            mapString = [mapString stringByAppendingString: boundary];
        }
    }
    
    return mapString;
}

@end
