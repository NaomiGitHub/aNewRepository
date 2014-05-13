	//
//  AppDelegate.m
//  ETutor_Teacher
//
//  Created by 张鼎辉 on 14-2-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "AppDelegate.h"
#import "NavViewController.h"
#import "NewFeatureViewController.h"
#import "MainViewController.h"
#import "RootViewController.h"
#define kBaiduMAPKey @"gRqgBux41eGIincQqmR3Vd14"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    _manager = [[BMKMapManager alloc]init];
    BOOL ret = [_manager start:kBaiduMAPKey generalDelegate:self];
	if (!ret) {
		NSLog(@"manager start failed!");
	}
    
    NSLog(@"helloworld");

    
    
    NSString *key=(NSString *)kCFBundleVersionKey;
    
    NSString *lastVersionCode=[[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    NSString *current=[NSBundle mainBundle].infoDictionary[key];
    
    NewFeatureViewController *newFeature=[NewFeatureViewController new];
//    newFeature.start=^()
//    {
//        [self start];
//    };
    //不是第一次使用此版本
    if ([lastVersionCode isEqualToString:current]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kLoginStatu]) {
            [self start];
        }else
        {
            newFeature.pageCount=1;
            self.window.rootViewController=newFeature;
        }
    }else //第一次使用此版本
    {
        [[NSUserDefaults standardUserDefaults]setObject:current forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        newFeature.pageCount=1;
        self.window.rootViewController=newFeature;
    }
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)start
{
    [UIApplication sharedApplication].statusBarHidden=YES;
    RootViewController *root=[RootViewController new];
    self.window.rootViewController=root;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark baiduMap代理
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

@end
