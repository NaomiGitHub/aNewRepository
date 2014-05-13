//
//  OrderDetail.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-3.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "Order.h"

@interface OrderDetail : Order

@property (nonatomic , assign)int teacherid;//教师编号
@property (nonatomic , assign)int customerid;//用户id
@property (nonatomic , copy)NSString *timeperiod;//辅导时间段
@property (nonatomic , copy)NSString *timeperiodStr; //将辅导时间段转换成--点--点格式
@property (nonatomic , copy)NSString *objectinfo;//辅导对象
@property (nonatomic , copy)NSString *subjectinfo;//科目信息
@property (nonatomic , copy)NSString *memo;//附加信息

- (OrderDetail *)initWithDict:(NSDictionary *)dict;
@end
