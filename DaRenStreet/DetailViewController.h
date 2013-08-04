//
//  DetailViewController.h
//  DaRenStreet
//
//  Created by Wang on 13-7-27.
//  Copyright (c) 2013年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *viewString;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
