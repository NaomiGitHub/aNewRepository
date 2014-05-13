//
//  OrderDetail.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-3.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "OrderDetail.h"

@implementation OrderDetail
- (OrderDetail *)initWithDict:(NSDictionary *)dict{
    if(self = [super initWithDict:dict]){
        
        self.orderStatus = [dict[@"orderstatus"]intValue];
        self.teacherid = [dict[@"teacherid"]intValue];
        self.timeperiod = dict[@"timeperiod"];
        self.objectinfo = dict[@"objectinfo"];
        self.subjectinfo = dict[@"subjectinfo"];
        self.memo = dict[@"memo"];
        self.customerid = [dict[@"customerid"]intValue];
    }
    return self;

}

- (void)setTimeperiod:(NSString *)timeperiod{
    _timeperiod = timeperiod;
    NSArray *array = [timeperiod componentsSeparatedByString:@"-"];
    self.timeperiodStr = [NSString stringWithFormat:@"%@点 -- %@点",array[0],array[1]];
}
@end
