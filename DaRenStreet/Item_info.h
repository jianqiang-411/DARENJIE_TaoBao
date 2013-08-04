//
//  Item_info.h
//  DaRenStreet
//
//  Created by Wang on 13-7-19.
//  Copyright (c) 2013年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface Item_info : UIViewController

@property(nonatomic,retain) NSString *cid;              //商品所属的叶子类目 id
@property(nonatomic,retain) NSString *detailUrl;        //商品url
@property(nonatomic,retain) NSString *nickName;         //卖家昵称
@property(nonatomic,retain) NSString *titleName;        //商品标题,不能超过60字节
@property(nonatomic,retain) NSString *type;             //商品类型(fixed:一口价;auction:拍卖)注：取消团购
@property(nonatomic,retain) NSString *desc;             //商品描述, 字数要大于5个字符，小于25000个字符
@property(nonatomic,retain) NSString *propsName;        //商品属性名称。标识着props内容里面的pid和vid所对应的名称。格式为：pid1:vid1:pid_name1:vid_name1;pid2:vid2:pid_name2:vid_name2……(注：属性名称中的冒号":"被转换为："#cln#"; 分号";"被转换为："#scln#" )
@property(nonatomic,retain) NSString *listTime;         //上架时间（格式：yyyy-MM-dd HH:mm:ss）
@property(nonatomic,retain) NSString *delistTime;       //下架时间（格式：yyyy-MM-dd HH:mm:ss）
@property(nonatomic,retain) NSString *price;            //商品价格
@property(nonatomic,retain) NSString *postFee;          //平邮费用
@property(nonatomic,retain) NSString *expressFee;       //快递费用
@property(nonatomic,retain) NSString *emsFee;           //ems费用
@property(nonatomic,retain) NSString *wapDetailUrl;     //适合wap应用的商品详情url
@property(nonatomic,retain) Location *location;         //用户地址
@property(nonatomic,retain) NSMutableArray *imageArr;   //图片集合网址
@property(nonatomic,retain) NSString *picUrl;           //图片网址
@end
