//
//  NSDictionary+Assemble.m
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "NSDictionary+Assemble.h"
#import "NSArray+Assemble.h"
#import "NSString+Format.h"

@implementation NSDictionary (Assemble)
#pragma mark - NSDictionary → NSString

- (NSString *) stringByJoinEntireWithSpaceCharacter:(NSString *)spaceCharacter andBoundary:(NSString *)boundary{
    NSString *string;
    NSArray *keys = [self allKeys];
    NSArray *pairs = [keys arrayByMap:^(NSString *key){
        NSString *value = [self objectForKey:key];
        NSString *assemble = key;
        assemble = [assemble stringByAppendingFormat:@"%@%@",spaceCharacter,[value stringSwapWithBoundary:@"'"]];
        return assemble;
    }];
    string = [pairs stringByJoinSimplyWithBoundary:boundary];
    return string;
    // @{a:b,c:de} → @"'a' _boundary 'b' _spaceCharacter 'c' _boundary 'de'"
}


@end
