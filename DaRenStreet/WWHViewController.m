//
//  WWHViewController.m
//  DaRenStreet
//
//  Created by Wang on 13-7-15.
//  Copyright (c) 2013年 Wang. All rights reserved.
//

#import "WWHViewController.h"
//封装AppKey 的对象
#import "TopIOSClient.h"
//应用交互连接通信底层实体
#import "TopAppConnector.h"
//最常用的授权和请求工具
#import "TopIOSSdk.h"
//服务器响应对象
#import "TopApiResponse.h"
#import <QuartzCore/QuartzCore.h>
#import "WaterView.h"
#import "TopJSONTools.h"
#import "PBFlatBarButtonItems.h"
#import "Reachability.h"

@interface WWHViewController ()

@end

@implementation WWHViewController
@synthesize response,responseArr,scrollView,tapRecognizer,searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationItem setRightBarButtonItem:[PBFlatBarButtonItems searchBarButtonItemWithTarget:self selector:@selector(searchItem:)]];
    //(1) 创建一个测试网络状态对象
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.taobao.com"];
    //使用代码块和iOS6中的 GCD控制线程
    //(2) 测试网络畅通，改如何处理
    reach.reachableBlock = ^(Reachability * reachability)
    {
        //异步线程操作
        dispatch_async(dispatch_get_main_queue(), ^{
            //messageLbl.text = @"你的网络是通的";
            [self getView];
        });
    };
    
    //(3) 测试网络不通，改如何处理
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //messageLbl.text = @"你现在无法连接网络";
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"数据加载失败" message:@"请检查您的网络，并稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        });
    };
    
    [reach startNotifier];
    
    self.title = @"达人街";
    self.tabBarController.tabBarItem.title = @"逛逛";
    NSLog(@"-----------%f,%f",self.view.frame.size.width,self.view.frame.size.height);
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_2.png"]]];
}

- (void)getView
{
    //    NSArray *names = [[NSArray alloc]initWithObjects:@"连衣裙",@"T恤",@"小背心/小吊带",@"衬衫",@"蕾丝衫/雪纺衫",@"毛针织衫",@"短外套",@"风衣",@"半身裙",@"休闲裤",@"牛仔裤",@"打底裤", nil];
    NSArray *cids = [[NSArray alloc]initWithObjects:@"50010850",@"50000671",@"162105",@"162104",@"162116",@"50000697",@"50011277",@"50008901",@"1623",@"162201",@"162205",@"50007068", nil];
    //    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithObjects:names forKeys:keys];
    
    //加载广告
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 130)];
    imageView.image = [UIImage imageNamed:@"guanggao.png"];
    [scrollView addSubview:imageView];
    
    UIView *subview = [[UIView alloc]initWithFrame:CGRectMake(10,150,self.view.frame.size.width - 20,280)];
    subview.backgroundColor = [UIColor whiteColor];
    
    //设置圆角
    CALayer *subviewlayer = [subview layer];
    subviewlayer.borderColor = [UIColor blackColor].CGColor;
    subviewlayer.borderWidth = 1.0;
    subviewlayer.cornerRadius = 10.0;
    
    //设置滚动条
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 440);
    scrollView.scrollEnabled = YES;
    [scrollView addSubview:subview];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
    lbl.text = @"女装";
    lbl.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    lbl.textColor = [UIColor blackColor];
    [subview addSubview:lbl];
    
    
    //taobao.itemcats.increment.get 增量获取后台类目数据
    [self getCats];
    NSLog(@"------%@",self.response);
    
    NSData* jData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    //把 JSON 数据，转换为字典对象
    //JSOn 中存储的本身是 {"itemprops_get_response" : {}}
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:jData options:NSJSONReadingMutableContainers error:nil];
    
    //取出 itemcats_get_response 对象
    //{"itemcats_get_response" : {}}
    NSDictionary *itempropsGetResponses = [resultDict objectForKey:@"itemcats_get_response"];

    //{"item_cats":{}}
    NSDictionary *itemcats = [itempropsGetResponses objectForKey:@"item_cats"];
    
    //item_props 中存放的是数组
    //{"item_cat" : []}
    NSArray *itemcatsArr = [itemcats objectForKey:@"item_cat"];
    
    for (int i = 0; i < [itemcatsArr count]; i++) {
        NSDictionary *itemDic = [itemcatsArr objectAtIndex:i];
        //动态添加图片
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"nvzhuang_%i",i+1]];
        UIImageView *imgview = [[UIImageView alloc]initWithImage:img];
        if(i < 4)
        {
            imgview.frame = CGRectMake(i*75.0 + 10.0, 30.0, 57.0, 57.0);
        }
        else if(i>=4 && i < 8)
        {
            imgview.frame = CGRectMake(i%4*75.0 + 10.0, 110.0, 57.0, 57.0);
        }
        else
        {
            imgview.frame = CGRectMake(i%4*75.0 + 10.0, 190.0, 57.0, 57.0);
        }
        //设置圆角
        CALayer *layer = [imgview layer];
        layer.masksToBounds = YES;
        layer.cornerRadius = 10.0;
        imgview.userInteractionEnabled = YES;
        NSString *cid = [cids objectAtIndex:i];
        NSLog(@"%@",cid);
        UITapGestureRecognizer *tapRecognize=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touches:)];//调用函数handTap实现点击事件。
        [imgview addGestureRecognizer:tapRecognize];
        tapRecognize.view.tag = [cid integerValue];
        [subview addSubview:imgview];
        
        
        UILabel *lbl = [[UILabel alloc]init];
        lbl.text = [itemDic objectForKey:@"name"];
        if (i<4) {
            lbl.frame = CGRectMake(i*75.0, 85.0, 80.0, 20.0);
        }
        else if (i>=4 && i < 8) {
            lbl.frame = CGRectMake(i%4*75.0, 165.0, 80.0, 20.0);
        }
        else {
            lbl.frame = CGRectMake(i%4*75.0, 245.0, 80.0, 20.0);
        }
        lbl.font = [UIFont fontWithName:@"Helvetica" size:12.f];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = [UIColor blackColor];
        lbl.backgroundColor = [UIColor clearColor];
        [subview addSubview:lbl];
    }
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, -40.0, 320.0, 40.0)];
    searchBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.scrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    
    for (UIView *subview in searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    
    [self.view addSubview:searchBar];
}

-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
    CGRect searchBarFrame = searchBar.frame;
    if(panParam.state == UIGestureRecognizerStateChanged)
    {
        float percent = scrollView.contentOffset.y / scrollView.contentSize.height;
        NSLog(@"   contentOffset.y = %f   ", percent);
        if(percent < 0)
        {
            searchBarFrame.origin.y = 0;
            [UIView animateWithDuration:0.5
                                  delay:0.5
                                options: UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 searchBar.frame = searchBarFrame;
                             }
                             completion:^(BOOL finished){
                                 NSLog(@"Done!");
                             }];
        }
        else if(percent > 0)
        {
            searchBarFrame.origin.y = -searchBarFrame.size.height;
            // iOS4+
            [UIView animateWithDuration:0.5
                                  delay:0.5
                                options: UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 searchBar.frame = searchBarFrame;
                             }
                             completion:^(BOOL finished){
                                 NSLog(@"Done!");
                             }];
        }
    }

}

//touch事件
-(void)touches:(UITapGestureRecognizer *)gestureRecognizer
{
    NSString *cid =  [NSString stringWithFormat: @"%d", gestureRecognizer.view.tag];
    WaterView *water = [[WaterView alloc]init];
    [self getItems:cid];
    //传递数据给下一个视图控制器
    water.dataArr = responseArr;
    water.page = 1;
    water.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:water animated:YES];
}

-(void)getCats
{
    //创建 客户端 对象
    TopIOSClient *client = [TopIOSClient registerIOSClient:@"21553501" appSecret:@"c9566143c721c89e32c96cc76fb2708d" callbackUrl:@"appcallback://" needAutoRefreshToken:YES];
    
    //得到输入参数
    //method=taobao.itemprops.get&partner_id=top-apitools&format=json&cid=50012379&fields=pid,name,must,multi,prop_values
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"50010850,50000671,162105,162104,162116,50000697,50011277,50008901,1623,162201,162205,50007068" forKey:@"cids"];
    [params setObject:@"cid,parent_cid,name,is_parent" forKey:@"fields"];
    [params setObject:@"taobao.itemcats.get" forKey:@"method"];
    [params setObject:@"top-apitools" forKey:@"partner_id"];
    [params setObject:@"json" forKey:@"format"];
    
    //同步
    TopApiResponse *responseobj =[client api:@"GET" params:params userId:@""];
    if ([responseobj content])
    {
        self.response = [responseobj content];
    }
    else {
        NSLog(@"%@",[(NSError *)[responseobj error] userInfo]);
    }
}

-(void)getItems:(NSString*) cid
{
    //创建 客户端 对象
    //    TopIOSClient *client = [TopIOSClient registerIOSClient:@"21553501" appSecret:@"c9566143c721c89e32c96cc76fb2708d" callbackUrl:@"appcallback://" needAutoRefreshToken:YES];
    
    TopIOSClient *client = [TopIOSClient getIOSClientByAppKey:@"21553501"];
    
    //得到输入参数
    //method=taobao.itemprops.get&partner_id=top-apitools&format=json&cid=50012379&fields=pid,name,must,multi,prop_values
    NSMutableDictionary *params =[[NSMutableDictionary alloc]init];
    [params setObject:cid forKey:@"category_id"];
    [params setObject:@"1" forKey:@"recommend_type"];
    [params setObject:@"50" forKey:@"count"];
    [params setObject:@"taobao.categoryrecommend.items.get" forKey:@"method"];
    [params setObject:@"top-apitools" forKey:@"partner_id"];
    [params setObject:@"json" forKey:@"format"];
    
    //同步
    TopApiResponse *responseobj =[client api:@"GET" params:params userId:@""];
    if ([responseobj content])
    {
        self.response = [responseobj content];
        NSLog(@"-------------------------------------%@",response);
        TopJSONTools *jsonTool =[[TopJSONTools alloc]init];
        NSMutableArray *resultArr = [jsonTool getitemArrayFromNSJSON:response];
        self.responseArr = resultArr;
        //NSLog(@"==========JSON==========");
    }
    else {
        NSLog(@"%@",[(NSError *)[responseobj error] userInfo]);
    }
}

//查询当前用户方法的回调函数
//把 淘宝 服务器返回的信息，直接显示在当前界面上
-(void)showApiResponse:(id)data
{
    if ([data isKindOfClass:[TopApiResponse class]])
    {
        TopApiResponse *responseobj = (TopApiResponse *)data;
        
        if ([responseobj content])
        {
            NSLog(@"==========JSON==========");
            NSLog(@"%@",[responseobj content]);
            self.response = [responseobj content];
            NSLog(@"==========JSON==========");
        }
        else {
            NSLog(@"%@",[(NSError *)[responseobj error] userInfo]);
        }
    }
}

-(void)searchItem:(UIBarButtonItem *)sender
{
    CGRect searchBarFrame = searchBar.frame;
    searchBarFrame.origin.y = 0;
    
    // iOS4+
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         searchBar.frame = searchBarFrame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
}

-(void) keyboardWillShow:(NSNotification *) note {
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:tapRecognizer];
}
-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.searchBar resignFirstResponder];
}

@end
