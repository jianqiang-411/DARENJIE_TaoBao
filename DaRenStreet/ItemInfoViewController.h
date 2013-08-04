//
//  ItemInfoViewController.h
//  DaRenStreet
//
//  Created by Wang on 13-7-19.
//  Copyright (c) 2013年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Item_info;

@interface ItemInfoViewController : UIViewController

@property(nonatomic,retain)NSString* track_iid;
@property(nonatomic,retain)Item_info *itemInfo;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)UIView* btnView;

@end
