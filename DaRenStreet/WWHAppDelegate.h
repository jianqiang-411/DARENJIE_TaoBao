//
//  WWHAppDelegate.h
//  DaRenStreet
//
//  Created by Wang on 13-7-15.
//  Copyright (c) 2013年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomTabBar;
@class Reachability;

@interface WWHAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IBOutlet UITabBarController *tabbarViewController;

//定义一个判断网络状况的对象
//@property(nonatomic,retain) Reachability  *hostReach;
@end
