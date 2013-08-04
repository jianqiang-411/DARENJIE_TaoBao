//
//  DetailViewController.m
//  DaRenStreet
//
//  Created by Wang on 13-7-27.
//  Copyright (c) 2013年 Wang. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize viewString,webView,activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //创建UIWebView
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"产品详情";
    //创建左侧的导航栏
    UIImage *backImg = [UIImage imageNamed:@"back.png"];
    
    UIButton *profileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    profileBtn.frame = CGRectMake(0, 0, 50, 33);
    [profileBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [profileBtn setBackgroundColor:[UIColor colorWithPatternImage:backImg]];
    
    UIBarButtonItem *profileItem = [[UIBarButtonItem alloc] initWithCustomView:profileBtn];
    
    self.navigationItem.leftBarButtonItem = profileItem;
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [webView setUserInteractionEnabled:YES];
    [webView setBackgroundColor:[UIColor clearColor]];
    //[webView setDelegate:self];
    [webView setOpaque:YES];//使网页透明
    
//    NSString *path = @"http://www.baidu.com";
//    NSURL *url = [NSURL URLWithString:path];
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    webView.scalesPageToFit = YES;
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView loadHTMLString:viewString baseURL:nil];
    
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [view setTag:103];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.8];
    [self.view addSubview:view];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:activityIndicator];
    
    [self.view addSubview:webView];
    
}

-(void)doBack:(UIButton *)bt
{
    [self.navigationController popViewControllerAnimated:YES];
}

//开始加载数据
//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [activityIndicator startAnimating];
//}

//数据加载完
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [activityIndicator stopAnimating];
//    UIView *view = (UIView *)[self.view viewWithTag:103];
//    [view removeFromSuperview];
//}

@end
