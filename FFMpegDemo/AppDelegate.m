//
//  AppDelegate.m
//  FFMpegDemo
//
//  Created by 陈林 on 2016/10/19.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setAppUI];
    
    return YES;
}

- (void)setAppUI { // 设置应用UI
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:26/225.f green:31/225.f blue:39/225.f alpha:1.0f]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //     设置导航栏没有边线
    //    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
    //                                      forBarPosition:UIBarPositionAny
    //                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTranslucent:YES]; // 毛玻璃半透明效果
    [[UINavigationBar appearance] setOpaque:YES];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    
    // 已经在info.plist文件中设置了statusBarStyle属性为lightContent
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
