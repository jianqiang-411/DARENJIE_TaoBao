//
//  MessView.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "MessView.h"
#import "UrlImageButton.h"
#import <ImageIO/ImageIO.h>
#import "ItemInfoViewController.h"
#import "WaterView.h"
#define WIDTH 320/3
@implementation MessView
@synthesize idelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithData:(DataInfo *)data yPoint:(float) y{
//    NSURL *url = [NSURL URLWithString:data.imageUrl];
//    NSData *imageData = [NSData dataWithContentsOfURL:url];
//    UIImage *image = [UIImage imageWithData:imageData];

//    float imgW=data.width;//图片原宽度
//    float imgH=data.height;//图片原高度
    //float imgW=width;//图片原宽度
    //float imgH=height;//图片原高度
    
    float sImgW = WIDTH-4;//缩略图宽带
    //float sImgH = sImgW*imgH/imgW;//缩略图高度
    //float sImgH = sImgW*(image.size.height/image.size.width);//缩略图高度
    float sImgH = sImgW;
    self = [super initWithFrame:CGRectMake(0, y, WIDTH, sImgH+4)];
    if (self) {
        UrlImageButton *imageBtn = [[UrlImageButton alloc]initWithFrame:CGRectMake(2,2, sImgW, sImgH)];//初始化url图片按钮控件
        [imageBtn setImageFromUrl:YES withUrl:data.imageBigUrl];//设置图片地质
        imageBtn.accessibilityHint = data.track_iid;
        [imageBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageBtn];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 38, self.frame.size.height-17, 36, 15)];
        label.backgroundColor = [UIColor whiteColor];
        label.alpha=0.8;
        label.text=data.itemPrice;
        label.textColor =[UIColor redColor];
        label.font = [UIFont fontWithName:@"Helvetica" size:10];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
       
    }
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)click:(id)sender
{
    [self.idelegate click:self.dataInfo];
    
    UrlImageButton *btn = (UrlImageButton*)sender;
    ItemInfoViewController *itemInfo = [[ItemInfoViewController alloc]init];
    itemInfo.track_iid = btn.accessibilityHint;
    
    //响应消息链，找出当前view所在的viewController
    id next = [self nextResponder];
    while(![next isKindOfClass:[WaterView class]])
    {
        next = [next nextResponder];
    }
    if ([next isKindOfClass:[WaterView class]])
    {
        WaterView *water = (WaterView *)next;
        [water.navigationController pushViewController:itemInfo animated:YES];
    }
}



@end
