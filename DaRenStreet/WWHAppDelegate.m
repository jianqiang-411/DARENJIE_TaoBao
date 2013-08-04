//
//  WWHAppDelegate.m
//  DaRenStreet
//
//  Created by Wang on 13-7-15.
//  Copyright (c) 2013年 Wang. All rights reserved.
//

#import "WWHAppDelegate.h"

#import "WWHViewController.h"
#import "InfoViewController.h"
#import "PBFlatSettings.h"
//导入网络测试的类
#import "Reachability.h"

@implementation WWHAppDelegate
@synthesize window,tabbarViewController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification
//                                               object:nil];
//    hostReach = [Reachability reachabilityWithHostname:@"www.taobao.com"];
//    [hostReach startNotifier];
    
    /////////////////////
    [[PBFlatSettings sharedInstance] navigationBarApperance];
    [[NSBundle mainBundle]loadNibNamed:@"MainWindow" owner:self options:nil];
    [self.window addSubview:tabbarViewController.view];
    
    self.window.backgroundColor = [UIColor whiteColor];
	[self.window makeKeyAndVisible];
	
    
    return YES;
}

//通过消息中心，知道网络装状况改变后，如何处理
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"恭喜网络畅通" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"你的网络不给力" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
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

@end
