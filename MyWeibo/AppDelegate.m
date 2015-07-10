

#import "AppDelegate.h"
#import "FMDatabase.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setTab];
    
    return YES;
}



- (void) setTab{
    UITabBarController *tabViewController = (UITabBarController *) self.window.rootViewController;
    [tabViewController setSelectedIndex:0];
    //
    UITabBar *tabBar = tabViewController.tabBar;
    [tabBar setTintColor: [UIColor greenColor]];
    
    //UITabBarItem
    UITabBarItem *tab1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tab2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tab3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tab4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tab5 = [tabBar.items objectAtIndex:4];
    
    UIImage *tab1Image = [UIImage imageNamed:@"Home"];
    UIImage *scaledTab1Image = [UIImage imageWithCGImage: [tab1Image CGImage] scale:(tab1Image.scale * 4) orientation:(tab1Image.imageOrientation)];
    
    UIImage *tab1SelectedImage = [UIImage imageNamed:@"Home"];
    UIImage *scaledTab1SelectedImage = [UIImage imageWithCGImage: [tab1SelectedImage CGImage] scale:(tab1SelectedImage.scale * 4) orientation:(tab1SelectedImage.imageOrientation)];
    (void)[tab1 initWithTitle:@"主页" image:scaledTab1Image selectedImage:scaledTab1SelectedImage];
    
    UIImage *tab2Image = [UIImage imageNamed:@"Message"];
    UIImage *scaledTab2Image = [UIImage imageWithCGImage: [tab2Image CGImage] scale:(tab2Image.scale * 4) orientation:(tab2Image.imageOrientation)];
    
    UIImage *tab2SelectedImage = [UIImage imageNamed:@"Message"];
    UIImage *scaledTab2SelectedImage = [UIImage imageWithCGImage: [tab2SelectedImage CGImage] scale:(tab2SelectedImage.scale * 4) orientation:(tab2SelectedImage.imageOrientation)];
    (void)[tab2 initWithTitle:@"消息" image:scaledTab2Image selectedImage:scaledTab2SelectedImage];
    
    UIImage *tab3Image = [UIImage imageNamed:@"Add"];
    UIImage *scaledTab3Image = [UIImage imageWithCGImage: [tab3Image CGImage] scale:(tab3Image.scale * 4) orientation:(tab3Image.imageOrientation)];
    
    UIImage *tab3SelectedImage = [UIImage imageNamed:@"Add"];
    UIImage *scaledTab3SelectedImage = [UIImage imageWithCGImage: [tab3SelectedImage CGImage] scale:(tab3SelectedImage.scale * 4) orientation:(tab3SelectedImage.imageOrientation)];
    (void)[tab3 initWithTitle:@"添加" image:scaledTab3Image selectedImage:scaledTab3SelectedImage];
    
    UIImage *tab4Image = [UIImage imageNamed:@"Search"];
    UIImage *scaledTab4Image = [UIImage imageWithCGImage: [tab4Image CGImage] scale:(tab4Image.scale * 4) orientation:(tab4Image.imageOrientation)];
    
    UIImage *tab4SelectedImage = [UIImage imageNamed:@"Search"];
    UIImage *scaledTab4SelectedImage = [UIImage imageWithCGImage: [tab4SelectedImage CGImage] scale:(tab4SelectedImage.scale * 4) orientation:(tab4SelectedImage.imageOrientation)];
    (void)[tab4 initWithTitle:@"搜索" image:scaledTab4Image selectedImage:scaledTab4SelectedImage];
    
    UIImage *tab5Image = [UIImage imageNamed:@"Aavatar"];
    UIImage *scaledTab5Image = [UIImage imageWithCGImage: [tab5Image CGImage] scale:(tab5Image.scale * 4) orientation:(tab5Image.imageOrientation)];
    
    UIImage *tab5SelectedImage = [UIImage imageNamed:@"Aavatar"];
    UIImage *scaledTab5SelectedImage = [UIImage imageWithCGImage: [tab5SelectedImage CGImage] scale:(tab5SelectedImage.scale * 4) orientation:(tab5SelectedImage.imageOrientation)];
    (void)[tab5 initWithTitle:@"个人" image:scaledTab5Image selectedImage:scaledTab5SelectedImage];
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
