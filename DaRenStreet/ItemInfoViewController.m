//
//  ItemInfoViewController.m
//  DaRenStreet
//
//  Created by Wang on 13-7-19.
//  Copyright (c) 2013年 Wang. All rights reserved.
//

#import "ItemInfoViewController.h"
//封装AppKey 的对象
#import "TopIOSClient.h"
//应用交互连接通信底层实体
#import "TopAppConnector.h"
//最常用的授权和请求工具
#import "TopIOSSdk.h"
//服务器响应对象
#import "TopApiResponse.h"
#import <QuartzCore/QuartzCore.h>
#import "TopJSONTools.h"
#import "Item_info.h"
#import "EGOImageView.h"
#import "DetailViewController.h"

@interface ItemInfoViewController ()

@end

float endOffset = 0;

@implementation ItemInfoViewController

@synthesize track_iid,itemInfo,scrollView,btnView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getItems];

    [self drawBackView];
    
    //NSURL *url = [[NSURL alloc] initWithString :itemInfo.picUrl];
    //NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
    //imageView.image = [[UIImage alloc] initWithData:imageData];
    EGOImageView *egoImageView = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"loading.gif"]];
    egoImageView.frame = CGRectMake(20.f, 45.f, 280.f, 380.f);
    egoImageView.imageURL = [NSURL URLWithString:itemInfo.picUrl];
    [scrollView addSubview:egoImageView];
    [self initWithImages];
    scrollView.contentSize = CGSizeMake(320.0, 510.0 + 385*itemInfo.imageArr.count);
    
    //给scrollView添加事件
    [self.scrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(20.0, 433.0, 280.0, 70.0)];
    
    UILabel *lbl_price = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 25.0, 42.0, 21.0)];
    lbl_price.text = itemInfo.price;
    lbl_price.textColor = [UIColor redColor];
    lbl_price.font = [UIFont fontWithName:@"Helvetica" size:18];
    CGSize size = CGSizeMake(100,21);
    CGSize labelsize = [itemInfo.titleName sizeWithFont:lbl_price.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    lbl_price.frame = CGRectMake(10.0, 25.0, labelsize.width, labelsize.height );
    [detailView addSubview:lbl_price];
    
    UILabel *lbl_title = [[UILabel alloc]initWithFrame:CGRectMake(75.0, 9.0, 170.0, 53.0)];
    lbl_title.text = itemInfo.titleName;
    lbl_title.textColor = [UIColor grayColor];
    lbl_title.font = [UIFont fontWithName:@"Helvetica" size:12];
    lbl_title.numberOfLines = 0;
    size = CGSizeMake(170,53);
    labelsize = [itemInfo.titleName sizeWithFont:lbl_title.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    lbl_title.frame = CGRectMake(75.0, 9.0, labelsize.width, labelsize.height);
    [detailView addSubview:lbl_title];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(goToDetail:)];
    [detailView addGestureRecognizer:tapRecognizer];
    
    UILabel *lbl_nick = [[UILabel alloc]initWithFrame:CGRectMake(8.0, 15.0, 100.0, 21.0)];
    NSString *nick = [itemInfo.nickName stringByAppendingFormat:@" 推荐"];
    lbl_nick.text = nick;
    lbl_nick.font = [UIFont fontWithName:@"Helvetica" size:10];
    lbl_nick.textColor = [UIColor grayColor];
    [scrollView addSubview:lbl_nick];
    
    UILabel *lbl_location = [[UILabel alloc]initWithFrame:CGRectMake(258.0, 15.0, 80.0, 21.0)];
    NSString *location = [itemInfo.location.state stringByAppendingFormat:@" %@",itemInfo.location.city];
    lbl_location.text = location;
    lbl_location.font = [UIFont fontWithName:@"Helvetica" size:10];
    [scrollView addSubview:lbl_location];
    [scrollView addSubview:detailView];
    
    
}

-(void)drawBackView
{
    //创建左侧的导航栏
    UIImage *backImg = [UIImage imageNamed:@"back.png"];
    
    UIButton *profileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    profileBtn.frame = CGRectMake(0, 0, 30, 30);
    [profileBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [profileBtn setBackgroundColor:[UIColor colorWithPatternImage:backImg]];
    
    btnView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 10.0, profileBtn.frame.size.width, profileBtn.frame.size.height)];
    btnView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    CALayer *layer = [btnView layer];
    layer.masksToBounds = YES;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:layer.bounds
                                                   byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = layer.bounds;
    maskLayer.path = maskPath.CGPath;
    layer.mask = maskLayer;
    
    btnView.userInteractionEnabled = YES;
    [btnView addSubview:profileBtn];
    [self.view addSubview:btnView];
}

-(void)doBack:(UIButton *)bt
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getItems
{
    //创建 客户端 对象
    //    TopIOSClient *client = [TopIOSClient registerIOSClient:@"21553501" appSecret:@"c9566143c721c89e32c96cc76fb2708d" callbackUrl:@"appcallback://" needAutoRefreshToken:YES];
    
    TopIOSClient *client = [TopIOSClient getIOSClientByAppKey:@"21553501"];
    
    //得到输入参数
    //method=taobao.itemprops.get&partner_id=top-apitools&format=json&cid=50012379&fields=pid,name,must,multi,prop_values
    NSMutableDictionary *params =[[NSMutableDictionary alloc]init];
    [params setObject:@"detail_url,num_iid,title,nick,type,cid,seller_cids,props,input_pids,input_str,desc,pic_url,num,valid_thru,list_time,delist_time,stuff_status,location,price,post_fee,express_fee,ems_fee,has_discount,freight_payer,has_invoice,has_warranty,has_showcase,modified,increment,approve_status,postage_id,product_id,auction_point,property_alias,item_img,prop_img,sku,video,outer_id,is_virtual" forKey:@"fields"];
    [params setObject:track_iid forKey:@"track_iid"];
    [params setObject:@"taobao.item.get" forKey:@"method"];
    [params setObject:@"top-apitools" forKey:@"partner_id"];
    [params setObject:@"json" forKey:@"format"];
    
    //同步
    TopApiResponse *responseobj =[client api:@"GET" params:params userId:@""];
    if ([responseobj content])
    {
        NSString *responseString = [responseobj content];
        //NSLog(@"-------------------------------------%@",responseString);
        TopJSONTools *jsonTool =[[TopJSONTools alloc]init];
        itemInfo = [jsonTool getItemInfoFromNSJSON:responseString];
        //NSLog(@"==========JSON==========");
    }
    else {
        NSLog(@"%@",[(NSError *)[responseobj error] userInfo]);
    }
}

-(void)initWithImages
{
    for (int i = 0; i<[itemInfo.imageArr count]; i++) {
        EGOImageView *egoImageView = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"loading.gif"]];
        egoImageView.frame = CGRectMake(20.f, (510.f + 385.f * i), 280.f, 380.f);
        egoImageView.imageURL = [NSURL URLWithString:[itemInfo.imageArr objectAtIndex:i]];
        [self.scrollView addSubview:egoImageView];
    }
}

-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
    CGRect btnFrame = btnView.frame;
    if(panParam.state == UIGestureRecognizerStateChanged)
    {
        float percent = scrollView.contentOffset.y / scrollView.contentSize.height - endOffset;
        NSLog(@"   contentOffset.y = %f   ", percent);
        if(percent < 0)
        {
            btnFrame.origin.x = 0;
            [UIView animateWithDuration:0.5
                                  delay:0.5
                                options: UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 btnView.frame = btnFrame;
                             }
                             completion:^(BOOL finished){

                             }];
        }
        else if(percent > 0)
        {
            btnFrame.origin.x = -btnFrame.size.width;
            // iOS4+
            [UIView animateWithDuration:0.5
                                  delay:0.5
                                options: UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 btnView.frame = btnFrame;
                             }
                             completion:^(BOOL finished){

                             }];
        }
    }
    else if(panParam.state == UIGestureRecognizerStateEnded)
    {
        endOffset = scrollView.contentOffset.y / scrollView.contentSize.height ;
    }
}

-(void)goToDetail: (UITapGestureRecognizer*) recognizer {
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    DetailViewController *dvc = [[DetailViewController alloc]init];
    dvc.viewString = itemInfo.desc;
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

@end
