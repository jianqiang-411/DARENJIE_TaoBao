//
//  TopJSONTools.h
//  aaaaaaa
//
//  解析 项目中生成的各种 JSON 数据
//  解析结果，根据程序中的需要为 NSArray NSDictionary NSString 等
//
//  Created by liu on 13-7-2.
//  Copyright (c) 2013年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Item_info;

@interface TopJSONTools : NSObject

//使用 JSONKit 解析
-(NSMutableDictionary *)getArrayFromJSONKit1:(NSString *)jsondata;
-(NSMutableDictionary *)getArrayFromJSONKit2:(NSString *)jsondata;

//使用 NSJSONSerialization 解析
-(NSMutableDictionary *)getArrayFromNSJSON:(NSString *)jsondata;

-(NSMutableArray *)getitemArrayFromNSJSON:(NSString *)jsondata;

-(Item_info *)getItemInfoFromNSJSON:(NSString *)jsondata;

@end





