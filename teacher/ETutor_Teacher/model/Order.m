//
//  Order.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-3.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//  

#import "Order.h"

@implementation Order

- (Order *)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){

        self.orderStatus = [dict[@"orderstatus"]intValue];
        self.latitude = [dict[@"latitude"]doubleValue];
        self.longitude = [dict[@"longitude"]doubleValue];
        self.serviceaddress = dict[@"serviceaddress"];
        self.customername = dict[@"customername"];
        self.orderdate = dict[@"orderdate"];
        self.orderid = [dict[@"orderid"]intValue];
        
    }
    return self;
}

@end
