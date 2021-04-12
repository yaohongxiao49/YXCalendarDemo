//
//  AppDelegate.m
//  YXCalendarDemo
//
//  Created by ios on 2021/4/12.
//

#import "AppDelegate.h"
#import "YXCalendarVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    YXCalendarVC *rootVC = [[YXCalendarVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
