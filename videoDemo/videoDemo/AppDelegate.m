//
//  AppDelegate.m
//  videoDemo
//
//  Created by SHANPX on 16/4/15.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import "AppDelegate.h"
#import "SMAVPlayerViewController.h"
#import "VideoModel.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor grayColor];
    SMAVPlayerViewController *playerVC = [[SMAVPlayerViewController alloc] initWithNibName:@"SMAVPlayerViewController" bundle:nil];
    NSMutableArray *arrVedio = [NSMutableArray array];
    for (NSInteger i = 0 ; i < 2; i++) {
        VideoModel *videoModel = [[VideoModel alloc] init];
        switch (i) {
            case  0:
                videoModel.strURL =@"story1";
                videoModel.strTitle = @"玉髓究竟怎么玩";
                break;
            case  1:
                videoModel.strURL =@"story1";
                videoModel.strTitle = @"玉髓究竟怎么玩";
                break;
            case  2:
                videoModel.strURL =@"story1";
                videoModel.strTitle = @"玉髓究竟怎么玩";
                break;
            default:
                break;
        }
        videoModel.vedioType = 1;
        videoModel.strUserID = @"1";
        [arrVedio addObject:videoModel];
    }
    playerVC.arrVedio = arrVedio;

    UINavigationController *navaController=[[UINavigationController alloc]initWithRootViewController:playerVC];
    self.window.rootViewController=navaController;
    [self.window makeKeyAndVisible];

    return YES;
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
