

#import "NewsModel.h"
#import "Random.h"

@implementation NewsModel

#pragma mark - Dictionary Format For NewsModel

+ (NSDictionary *) directoryForAtrributesAndTpyes
{
    NSArray *keys = [NSArray arrayWithObjects:@"avatar", @"name", @"desc", @"weibo", @"weibo_image", nil];
    NSArray *types = [NSArray arrayWithObjects:@"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", nil];
    return [NSDictionary dictionaryWithObjects: types forKeys: keys];
}

+ (NSDictionary *) directoryForAtrributesAndNames
{
    NSArray *keys = [NSArray arrayWithObjects:@"avatar", @"name", @"desc", @"weibo", @"weibo_image", nil];
    return [NSDictionary dictionaryWithObjects: keys forKeys: keys];
}

+ (NewsModel *) newsWithRandomValues
{
    NewsModel *news = [[NewsModel alloc] init];
    
    news.weibo = [Random stringOfRandomWeibo:[Random randZeroToNum:3]];
    
    if ([Random possibilityTenOfNum:5]) {
        news.name = @"苍井空";
        
        news.weiboImage = @"weibo1";
        if ([Random possibilityTenOfNum:5]) {
            news.avatar = @"Aoi1";
            news.desc = @"杂志模特";
        } else {
            news.avatar = @"Aoi2";
            news.desc = @"亲爱的老师";
        }
    } else {
        news.name = @"新垣结衣";
        
        news.weiboImage = @"weibo2";
        if ([Random possibilityTenOfNum:5]) {
            news.avatar = @"Aragaki1";
            news.desc = @"日本演员";
        } else {
            news.avatar = @"Aragaki2";
            news.desc = @"模特，歌手";
        }
    }
    
    return news;
}

#pragma mark - Initialize

- (id) initNewsWithRandomValues
{
    self = [super init];
    if (self) {
        _name = @"新垣结衣";
        _avatar = @"Aragaki1";
        _desc = @"日本演员";
        _weibo = @"I am singing";
        _weiboImage = @"weibo2";
        
    }
    
    return self;
}

#pragma mark - Dictionary Form For Instance

- (NSDictionary *) dictionaryWithNewsPairs
{
    NSArray *keys = [NSArray arrayWithObjects:@"avatar", @"name", @"desc", @"weibo", @"weibo_image", nil];
    NSArray *types = [NSArray arrayWithObjects:_avatar, _name, _desc, _weibo, _weiboImage, nil];
    return [NSDictionary dictionaryWithObjects: types forKeys: keys];
}

@end

