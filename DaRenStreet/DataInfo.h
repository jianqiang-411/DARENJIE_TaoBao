//
//  DataInfo.h
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataInfo : NSObject
@property(nonatomic,strong)NSString *sellCount;         //卖出数量
@property(nonatomic,strong)NSString *itemPrice;         //商品价格
@property(nonatomic,strong)NSString *promotionPrice;    //促销价格
@property(nonatomic,strong)NSString *imageUrl;          //小图url
@property(nonatomic,strong)NSString *imageBigUrl;       //原图url
@property(nonatomic,strong)NSString *itemName;          //商品名
@property(nonatomic,strong)NSString *itemUrl;           //商品详情url
@property(nonatomic,strong)NSString *track_iid;         //商品id
@end
