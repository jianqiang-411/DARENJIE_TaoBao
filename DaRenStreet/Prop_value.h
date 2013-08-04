//
//  Prop_value.h
//  aaaaaaa
//
//  保存每次从 taobao.itemprops.get  API 得到的
//  "prop_values"  "fields"数据
//
//  Created by liu on 13-7-2.
//  Copyright (c) 2013年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prop_value : NSObject

/*
 JSON              Objective-C
 ------------------------------
 null               NSNull
 true and false 	NSNumber
 Number             NSNumber
 String             NSString
 Array              NSArray
 Object             NSDictionary
 
 "name" : "硕氏",
 "vid" : 146934378,
 "is_parent" : true
 */
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSNumber *vid;
@property(nonatomic,retain)NSNumber *is_parent;


@end
