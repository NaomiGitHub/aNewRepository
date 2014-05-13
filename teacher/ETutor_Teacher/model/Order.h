//
//  Order.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-3.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//  一条订单

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic , assign)int orderid;//订单编号
@property (nonatomic , assign)OrderStatus orderStatus;//订单状态

@property (nonatomic , assign)double latitude;//服务地址的经度
@property (nonatomic , assign)double longitude;//服务地址的纬度

@property (nonatomic , copy)NSString *serviceaddress;//服务地址
@property (nonatomic , copy)NSString *orderdate;//订单生成时间
@property (nonatomic , copy)NSString *customername;//教师名称

- (Order *)initWithDict:(NSDictionary *)dict;
@end
