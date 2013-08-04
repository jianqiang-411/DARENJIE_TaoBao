//
//  Item_prop.h
//  aaaaaaa
//
//  保存每次从 taobao.itemprops.get  API 得到的
//  "pid,name,must,multi,prop_values"  "fields"数据
//
//  Created by liu on 13-7-2.
//  Copyright (c) 2013年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item_prop : NSObject

/*
 JSON              Objective-C
 ------------------------------
 null               NSNull
 true and false 	NSNumber
 Number             NSNumber
 String             NSString
 Array              NSArray
 Object             NSDictionary
 
"multi" : false,
"must" : false,
"name" : "包装数量(片)",
"pid" : 98
*/

@property(nonatomic,retain) NSDictionary *prop_values;
@property(nonatomic,retain) NSNumber *multi;
@property(nonatomic,retain) NSNumber *must;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSNumber *pid;



@end
