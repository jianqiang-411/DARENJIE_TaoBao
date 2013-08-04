//
//  TopJSONTools.m
//  aaaaaaa
//
//  Created by liu on 13-7-2.
//  Copyright (c) 2013年 liu. All rights reserved.
//

#import "TopJSONTools.h"

#import "JSONKit.h"

//导入存放解析后数据的类
#import "Item_prop.h"
#import "Prop_value.h"
#import "DataInfo.h"
#import "Item_info.h"

@implementation TopJSONTools

#pragma mark - JSONKit 解析
//使用 JSONKit 解析
//得到 婴儿纸尿裤 类目数据
-(NSMutableDictionary *)getArrayFromJSONKit1:(NSString *)jsondata
{
    NSMutableDictionary * dict= nil;
    //针对NSString字符串数据
    NSData* jData = [jsondata dataUsingEncoding:NSUTF8StringEncoding];
    //把 JSON 数据，转换为字典对象
    //JSOn 本身
    NSDictionary *resultDict = [jData objectFromJSONData];
    //NSLog(@"包装整个JSON数据为OC对象 :%@",resultDict);
    
    //取出 itemprops_get_response 对象
    //{"itemprops_get_response" : {}}
    NSDictionary *itempropsGetResponses = [resultDict objectForKey:@"itemprops_get_response"];
    //NSLog(@"第一层对象 is :%@",itempropsGetResponses);
    
    //取出 itemprops_get_response 对象
    //{"item_props":{}}
    NSDictionary *itemprops = [itempropsGetResponses objectForKey:@"item_props"];
    //NSLog(@"第二层对象 is :%@",itemprops);
    
    //item_props 中存放的是数组
    //{"item_prop" : []}
    NSArray *itempropArr = [itemprops objectForKey:@"item_prop"];
    //NSLog(@"第三层对象个数 is :%d",[itempropArr count]);
    
    
    //数组中，每个下标对应的对象，意义不一样
    //itempropArr[0]   包装规格:"name" : "包装数量(片)",
    //itempropArr[1]   品牌名称:"name" : "BaKen\/倍康",
    //itempropArr[2]   尺码规格:"name" : "S",
    //itempropArr[3]   用户分类:"name" : "男宝宝",
    //itempropArr[4]   产品分类:"name" : "纸尿裤",
    //itempropArr[5]   适用分类:"name" : "0-5公斤",
    //itempropArr[6]   产地分类:"name" : "中国大陆",
    
    //如果取出了 JSON 中的数据，新建保存最终结果的字典对象
    if (itempropArr != nil) {
        dict = [[NSMutableDictionary alloc]init];
    }else{
        return nil;
    }
 
    //
    for (int i=0; i<[itempropArr count]; i++) {
        NSDictionary *index = [itempropArr objectAtIndex:i];
        
        Item_prop *indexPro =[[Item_prop alloc]init];
        [indexPro setMust:[index objectForKey:@"must"]];
        [indexPro setMulti:[index objectForKey:@"multi"]];
        [indexPro setName:[index objectForKey:@"name"]];
        [indexPro setPid:[index objectForKey:@"pid"]];
        if ([index objectForKey:@"prop_values"] != nil)
        {
            [indexPro setProp_values:[index objectForKey:@"prop_values"]];
        }
        
        //一边循环，一边往字典中存放数据
        if ([indexPro.name isEqualToString:@"包装数量(片)"]) {
            [dict setValue:indexPro forKey:@"packge"];
        }
        if ([indexPro.name isEqualToString:@"品牌"]) {
            [dict setValue:indexPro forKey:@"brand"];
        }
        if ([indexPro.name isEqualToString:@"型号"]) {
            //尺码规格:"name" : "S",
            [dict setValue:indexPro forKey:@"size"];
        }
        if ([indexPro.name isEqualToString:@"适用"]) {
            //用户分类:"name" : "男宝宝",
            [dict setValue:indexPro forKey:@"user"];
        }
        if ([indexPro.name isEqualToString:@"尿不湿品类"]) {
            //产品分类:"name" : "纸尿裤",
            [dict setValue:indexPro forKey:@"product"];
        }
        if ([indexPro.name isEqualToString:@"适合体重"]) {
            //适用分类:"name" : "0-5公斤",
            [dict setValue:indexPro forKey:@"weight"];
        }
        if ([indexPro.name isEqualToString:@"产地"]) {
            //产地分类:"name" : "中国大陆",
            [dict setValue:indexPro forKey:@"country"];
        }
    }
    
    //NSLog(@"最终结果  %@",dict);
    
    return dict;
}


//使用 JSONKit 解析
//得到孕妇装的类目数据
-(NSMutableDictionary *)getArrayFromJSONKit2:(NSString *)jsondata
{
    NSMutableDictionary * dict= nil;
    
    //json格式解码
    JSONDecoder *jd=[[JSONDecoder alloc] init];
    NSData* jData = [jsondata dataUsingEncoding:NSUTF8StringEncoding];
    
    //把 JSON 数据，转换为字典对象
    //JSOn 中存储的本身是 {"itemprops_get_response" : {}}
    NSDictionary *resultDict = [jd objectWithData:jData];
    
    NSLog(@"包装整个JSON数据为OC对象 :%@",resultDict);
    
    //取出 itemprops_get_response 对象
    //{"itemprops_get_response" : {}}
    NSDictionary *itempropsGetResponses = [resultDict objectForKey:@"itemprops_get_response"];
    NSLog(@"第一层对象 is :%@",itempropsGetResponses);
    
    //取出 itemprops_get_response 对象
    //{"item_props":{}}
    NSDictionary *itemprops = [itempropsGetResponses objectForKey:@"item_props"];
    NSLog(@"第二层对象 is :%@",itemprops);
    
    //item_props 中存放的是数组
    //{"item_prop" : []}
    NSArray *itempropArr = [itemprops objectForKey:@"item_prop"];
    NSLog(@"第三层对象个数 is :%d",[itempropArr count]);
    
    
    //数组中，每个下标对应的对象，意义不一样
    //itempropArr[0]   品牌名称:"name" : "十月妈咪",
    //itempropArr[1]   颜色分类:"name" : "紫色",
    //itempropArr[2]   "name" : "货号",
    //itempropArr[3]   尺码:"name" : "XL",
    //itempropArr[4]   按价格展示:"name" : "300元-500元",
    //itempropArr[5]   面料分类:"name" : "金属混纺纤维",
    //itempropArr[6]   适合季节:"name" : "春秋",
    
    //如果取出了 JSON 中的数据，新建保存最终结果的字典对象
    if (itempropArr != nil) {
        dict = [[NSMutableDictionary alloc]init];
    }else{
        return nil;
    }
    
    //循环数组，把 JSON 中的数据重新放入规定的字典对象中
    for (int i=0; i<[itempropArr count]; i++) {
        NSDictionary *index = [itempropArr objectAtIndex:i];
        
        Item_prop *indexPro =[[Item_prop alloc]init];
        [indexPro setMust:[index objectForKey:@"must"]];
        [indexPro setMulti:[index objectForKey:@"multi"]];
        [indexPro setName:[index objectForKey:@"name"]];
        [indexPro setPid:[index objectForKey:@"pid"]];
        if ([index objectForKey:@"prop_values"] != nil)
        {
            [indexPro setProp_values:[index objectForKey:@"prop_values"]];
        }
        
        //一边循环，一边往字典中存放数据
        if ([indexPro.name isEqualToString:@"品牌"]) {
            [dict setValue:indexPro forKey:@"brand"];
        }
        if ([indexPro.name isEqualToString:@"货号"]) {
            [dict setValue:indexPro forKey:@"productNum"];
        }
        if ([indexPro.name isEqualToString:@"颜色分类"]){
            [dict setValue:indexPro forKey:@"color"];
        }
        if ([indexPro.name isEqualToString:@"尺码"]) {
            [dict setValue:indexPro forKey:@"size"];
        }
        if ([indexPro.name isEqualToString:@"按价格展示"]) {
            [dict setValue:indexPro forKey:@"priceShow"];
        }
        if ([indexPro.name isEqualToString:@"防辐射服面料"]) {
            [dict setValue:indexPro forKey:@"material"];
        }
        if ([indexPro.name isEqualToString:@"适合季节"]) {
            [dict setValue:indexPro forKey:@"season"];
        }
    }
    
    NSLog(@"孕妇装最终结果  %@",dict);
    
    
    return dict;
}


#pragma mark - NSJSONSerialization 解析
//使用 NSJSONSerialization 解析
-(NSMutableDictionary *)getArrayFromNSJSON:(NSString *)jsondata
{
    NSMutableDictionary * dict= nil;
    NSData* jData = [jsondata dataUsingEncoding:NSUTF8StringEncoding];

    //把 JSON 数据，转换为字典对象
    //JSOn 中存储的本身是 {"itemprops_get_response" : {}}
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:jData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"包装整个JSON数据为OC对象 :%@",resultDict);
    
    //取出 itemprops_get_response 对象
    //{"itemprops_get_response" : {}}
    NSDictionary *itempropsGetResponses = [resultDict objectForKey:@"itemprops_get_response"];
    //NSLog(@"第一层对象 is :%@",itempropsGetResponses);
    
    //取出 itemprops_get_response 对象
    //{"item_props":{}}
    NSDictionary *itemprops = [itempropsGetResponses objectForKey:@"item_props"];
    //NSLog(@"第二层对象 is :%@",itemprops);
    
    //item_props 中存放的是数组
    //{"item_prop" : []}
    NSArray *itempropArr = [itemprops objectForKey:@"item_prop"];
    //NSLog(@"第三层对象个数 is :%d",[itempropArr count]);
    
    
    //数组中，每个下标对应的对象，意义不一样
    //itempropArr[0]   品牌名称:"name" : "十月妈咪",
    //itempropArr[1]   颜色分类:"name" : "紫色",
    //itempropArr[2]   "name" : "货号",
    //itempropArr[3]   尺码:"name" : "XL",
    //itempropArr[4]   按价格展示:"name" : "300元-500元",
    //itempropArr[5]   面料分类:"name" : "金属混纺纤维",
    //itempropArr[6]   适合季节:"name" : "春秋",
    
    //如果取出了 JSON 中的数据，新建保存最终结果的字典对象
    if (itempropArr != nil) {
        dict = [[NSMutableDictionary alloc]init];
    }else{
        return nil;
    }
    
    //循环数组，把 JSON 中的数据重新放入规定的字典对象中
    for (int i=0; i<[itempropArr count]; i++) {
        NSDictionary *index = [itempropArr objectAtIndex:i];
        
        Item_prop *indexPro =[[Item_prop alloc]init];
        [indexPro setMust:[index objectForKey:@"must"]];
        [indexPro setMulti:[index objectForKey:@"multi"]];
        [indexPro setName:[index objectForKey:@"name"]];
        [indexPro setPid:[index objectForKey:@"pid"]];
        if ([index objectForKey:@"prop_values"] != nil)
        {
            [indexPro setProp_values:[index objectForKey:@"prop_values"]];
        }
        
        //一边循环，一边往字典中存放数据
        if ([indexPro.name isEqualToString:@"品牌"]) {
            [dict setValue:indexPro forKey:@"brand"];
        }
        if ([indexPro.name isEqualToString:@"货号"]) {
            [dict setValue:indexPro forKey:@"productNum"];
        }
        if ([indexPro.name isEqualToString:@"颜色分类"]){
            [dict setValue:indexPro forKey:@"color"];
        }
        if ([indexPro.name isEqualToString:@"尺码"]) {
            [dict setValue:indexPro forKey:@"size"];
        }
        if ([indexPro.name isEqualToString:@"按价格展示"]) {
            [dict setValue:indexPro forKey:@"priceShow"];
        }
        if ([indexPro.name isEqualToString:@"防辐射服面料"]) {
            [dict setValue:indexPro forKey:@"material"];
        }
        if ([indexPro.name isEqualToString:@"适合季节"]) {
            [dict setValue:indexPro forKey:@"season"];
        }
    }
    
    //NSLog(@"最终结果  %@",dict);

    
    
    
    return dict;
}

//使用 NSJSONSerialization 解析
-(NSMutableArray *)getitemArrayFromNSJSON:(NSString *)jsondata
{
    NSMutableArray * arr= nil;
    NSData* jData = [jsondata dataUsingEncoding:NSUTF8StringEncoding];
    
    //把 JSON 数据，转换为字典对象
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:jData options:NSJSONReadingMutableContainers error:nil];

    NSDictionary *itemsGetResponses = [resultDict objectForKey:@"categoryrecommend_items_get_response"];

    NSDictionary *items = [itemsGetResponses objectForKey:@"favorite_items"];

    NSArray *itemArr = [items objectForKey:@"favorite_item"];
    
    //如果取出了 JSON 中的数据，新建保存最终结果的字典对象
    if (itemArr != nil) {
        arr = [[NSMutableArray alloc]init];
    }else{
        return nil;
    }
    
    //循环数组，把 JSON 中的数据重新放入规定的字典对象中
    for (int i=0; i<[itemArr count]; i++) {
        NSDictionary *index = [itemArr objectAtIndex:i];
        
        DataInfo *indexItem =[[DataInfo alloc]init];
        [indexItem setTrack_iid:[index objectForKey:@"track_iid"]];
        [indexItem setSellCount:[index objectForKey:@"sell_count"]];
        [indexItem setItemPrice:[index objectForKey:@"item_price"]];
        [indexItem setItemName:[index objectForKey:@"item_name"]];
        [indexItem setPromotionPrice:[index objectForKey:@"promotion_price"]];
        NSString *imageUrl = [index objectForKey:@"item_pictrue"];
        [indexItem setImageBigUrl:[imageUrl stringByAppendingFormat:@"_120x120.jpg"]];
        //[indexItem setImageBigUrl:imageUrl];
        [indexItem setImageUrl:[imageUrl stringByAppendingFormat:@"_sum.jpg"]];
        [indexItem setItemUrl:[index objectForKey:@"item_url"]];
        [arr addObject:indexItem];
    }
    //NSLog(@"最终结果  %@",dict);
    return arr;
}

-(Item_info *)getItemInfoFromNSJSON:(NSString *)jsondata
{
    Item_info * itemInfo= nil;
    NSData* jData = [jsondata dataUsingEncoding:NSUTF8StringEncoding];
    
    //把 JSON 数据，转换为字典对象
    //JSOn 中存储的本身是 {"item_get_response" : {}}
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:jData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"包装整个JSON数据为OC对象 :%@",resultDict);
    
    //取出 item_get_response 对象
    //{"item_get_response" : {}}
    NSDictionary *itemGetResponses = [resultDict objectForKey:@"item_get_response"];
    //NSLog(@"第一层对象 is :%@",itempropsGetResponses);
    
    //取出 item 对象
    //{"item":{}}
    NSDictionary *item = [itemGetResponses objectForKey:@"item"];
    //NSLog(@"第二层对象 is :%@",itemprops);
    
    //如果取出了 JSON 中的数据，新建保存最终结果的字典对象
    if (item != nil) {
        itemInfo = [[Item_info alloc]init];
    }else{
        return nil;
    }
    itemInfo.cid = [item objectForKey:@"cid"];
    itemInfo.detailUrl = [item objectForKey:@"detail_url"];
    itemInfo.titleName = [item objectForKey:@"title"];
    itemInfo.nickName = [item objectForKey:@"nick"];
    itemInfo.type = [item objectForKey:@"type"];
    itemInfo.desc = [item objectForKey:@"desc"];
    itemInfo.propsName = [item objectForKey:@"props_name"];
    itemInfo.listTime = [item objectForKey:@"list_time"];
    itemInfo.delistTime = [item objectForKey:@"delist_time"];
    itemInfo.price = [item objectForKey:@"price"];
    itemInfo.postFee = [item objectForKey:@"post_fee"];
    itemInfo.expressFee = [item objectForKey:@"express_fee"];
    itemInfo.emsFee = [item objectForKey:@"ems_fee"];
    itemInfo.wapDetailUrl = [item objectForKey:@"wap_detail_url"];
    itemInfo.picUrl = [item objectForKey:@"pic_url"];
    
    NSDictionary *locationDic = [item objectForKey:@"location"];
    Location *location = [[Location alloc]init];
    location.state = [locationDic objectForKey:@"state"];
    location.city = [locationDic objectForKey:@"city"];
    
    itemInfo.location = location;
    
    
    NSDictionary *img = [item objectForKey:@"item_imgs"];
    NSArray *imgArr = [img objectForKey:@"item_img"];
    NSMutableArray *imgMuArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < [imgArr count]; i++) {
        NSDictionary *index = [imgArr objectAtIndex:i];
        NSString *url = [index objectForKey:@"url"];
        [imgMuArr addObject:url];
    }
    itemInfo.imageArr = imgMuArr;
    
    return itemInfo;
}

@end
