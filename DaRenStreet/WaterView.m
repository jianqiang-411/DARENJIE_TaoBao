//
//  WaterView.m
//  DaRen
//
//  Created by Wang on 13-7-8.
//  Copyright (c) 2013年 Wang. All rights reserved.
//

#import "WaterView.h"
#import "WWHViewController.h"
#import "Reachability.h"
#define pageCount 12
#define totalPage 50/pageCount

@interface WaterView ()

@end

@implementation WaterView
@synthesize dataArr,page,dArray,btnView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //(1) 创建一个测试网络状态对象
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.taobao.com"];
    //使用代码块和iOS6中的 GCD控制线程
    //(2) 测试网络畅通，改如何处理
    reach.reachableBlock = ^(Reachability * reachability)
    {
        //异步线程操作
        dispatch_async(dispatch_get_main_queue(), ^{
            //messageLbl.text = @"你的网络是通的";
            dArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<pageCount; i++) {
                [dArray addObject:[dataArr objectAtIndex:i]];
            }
            self.aoView = [[AOWaterView alloc]initWithDataArray:dArray];
            self.aoView.delegate=self;
            self.aoView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:self.aoView];
            [self createHeaderView];
            //[self setFooterView];
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
        });
    };
    
    //(3) 测试网络不通，改如何处理
    reach.unreachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //messageLbl.text = @"你现在无法连接网络";
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"数据加载失败" message:@"请检查您的网络，并稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        });
    };
    
    [reach startNotifier];
    
    //创建左侧的导航栏
    UIImage *backImg = [UIImage imageNamed:@"back.png"];
    
    UIButton *profileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    profileBtn.frame = CGRectMake(0, 0, 50, 33);
    [profileBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [profileBtn setBackgroundColor:[UIColor colorWithPatternImage:backImg]];
    
    UIBarButtonItem *profileItem = [[UIBarButtonItem alloc] initWithCustomView:profileBtn];
    
    self.navigationItem.leftBarButtonItem = profileItem;
}


-(void)doBack:(UIButton *)bt
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[self.aoView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

-(void)setFooterView{
    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.aoView.contentSize.height, self.aoView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.aoView.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.aoView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.aoView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark-
#pragma mark force to show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.aoView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.aoView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        self.aoView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.aoView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
	}
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
}
//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
    
	// overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.aoView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.aoView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

//刷新调用的方法
-(void)refreshView{
    dArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<pageCount; i++) {
        [dArray addObject:[dataArr objectAtIndex:i]];
    }
    [self.aoView refreshView:dArray];
    [self testFinishedLoadData];
    
}
//加载调用的方法
-(void)getNextPageView{
    [self removeFooterView];
    [dArray removeAllObjects];
    if(page < totalPage)
        page++;
    else
        page = 1;
    dArray = [[NSMutableArray alloc]init];
    for (int i = (page - 1) * pageCount; i<page * pageCount; i++) {
        [dArray addObject:[dataArr objectAtIndex:i]];
    }
    [self.aoView getNextPage:dArray];
    [self testFinishedLoadData];
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}

@end
