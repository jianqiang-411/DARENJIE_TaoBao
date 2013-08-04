//
//  WWHViewController.h
//  DaRenStreet
//
//  Created by Wang on 13-7-15.
//  Copyright (c) 2013年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWHViewController : UIViewController

@property(retain,nonatomic)NSString *response;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
//接受包含解析后数据的字典对象
@property(retain,nonatomic)NSMutableArray *responseArr;

@property (retain, nonatomic) UITapGestureRecognizer *tapRecognizer;

@property (retain,nonatomic)UISearchBar *searchBar;

//得到 所有指定cid的类目
-(void)getCats;

//得到 指定cid下所有类目
-(void)getItems:(NSString*) cid;
@end
