//
//  WaterView.h
//  DaRen
//
//  Created by Wang on 13-7-8.
//  Copyright (c) 2013年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "AOWaterView.h"

@interface WaterView : UIViewController
<EGORefreshTableDelegate,UIScrollViewDelegate>
{
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
}
@property(nonatomic,strong)AOWaterView *aoView;
@property(nonatomic,retain)NSMutableArray *dArray;
@property(nonatomic,retain)NSMutableArray *dataArr;
@property(nonatomic,strong)UIView *btnView;
@property int page;
@end
