//
//  AppDelegate.m
//  Test1
//
//  Created by zhenhui yang on 2022/1/12.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    UINavigationController* vc = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
   /// vc.navigationBarHidden = YES;
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}


@end
