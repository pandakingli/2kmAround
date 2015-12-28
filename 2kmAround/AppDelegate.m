//
//  AppDelegate.m
//  2kmAround
//
//  Created by 李宁 on 15/12/24.
//  Copyright © 2015年 Nthan. All rights reserved.
//

#import "AppDelegate.h"
#import "Headers.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //注册错误事件报告
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    
    //如果使用美国站点，请加上这行代码 [AVOSCloud useAVCloudUS];
    [AVOSCloud setApplicationId:@"30oPVCE5nctT4MtHDjfkQ9kp-gzGzoHsz"
                      clientKey:@"oUJdiYATIDvOz2Gg6LSytttT"];
    
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    
    //获取本地存储的账号信息
    AVUser *currentUser = [AVUser currentUser];
    if(currentUser!=nil)
    {
        //本地存在用户-认为已经登录
        [UserHandle shareUser].isUserLogin = YES;
        [UserHandle shareUser].myUser =currentUser;
        NSLog(@"找到用户-已经登录-%@",currentUser.username);
    }
    else
    {
        //本地无用户-没有登录
        
        [UserHandle shareUser].isUserLogin = NO;
        NSLog(@"未找到用户");
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    RootTabBarController * rootTBC = [[RootTabBarController alloc] init];
    self.window.rootViewController = rootTBC;
    
    
    
    
    
    
   //UITabBarItem字体的颜色 没有被选中的时候
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],                                                                                                              NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateNormal];
 
    
    //UITabBarItem字体的颜色 被选中的时候
     [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    
    
    
    
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
