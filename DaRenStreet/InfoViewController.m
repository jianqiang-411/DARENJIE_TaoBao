//
//  InfoViewController.m
//  DaRen
//
//  Created by Wang on 13-7-15.
//  Copyright (c) 2013年 Wang. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize lbl_connect;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    lbl_connect.text = @"451246809@qq.com";
    lbl_connect.textColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
