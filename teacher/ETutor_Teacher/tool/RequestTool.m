//
//  RequestTool.m
//  ETutor_Teacher
//
//  Created by fengpengfei on 14-2-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "RequestTool.h"
@implementation RequestTool

#pragma mark 教师注册
+(void)requestRegister:(NSString *)username andPassword:(NSString *)password success:(void(^)(CodeType codeType,NSString *teacherid))success fail:(void(^)())fail
{
    //对输入的密码进行加密
    NSString *base64Str = [password base64EncodedString];
    //拼接字符串
    NSString *jsonStr = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}",username,base64Str];
    //创建ASIFormDataRequest对象；
     __weak ASIFormDataRequest *dataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kTeacherRegisterURL]];
    //设置post请求方式；
    [dataRequest setPostValue:jsonStr forKey:@"info"];
    //开始异步请求；
    [dataRequest startAsynchronous];
    [dataRequest setCompletionBlock:^{
        
//        NSString * str = [dataRequest responseString];
//        NSLog(@"%@",str);
        NSData *data=[dataRequest responseData];
            //数据返回成功后解析数据
            NSDictionary *listDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers  error:nil];
            int code = [[listDic objectForKey:@"code"] intValue];
            NSString *teacherid = [listDic objectForKey:@"id"];
            //将注册后的id持久化储存；
            [[NSUserDefaults standardUserDefaults] setObject:teacherid forKey:kTeacherId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //将解析内容回调
            success(code,teacherid);
    }];
    [dataRequest setFailedBlock:^{
            fail();
    }];
}

#pragma mark 教师登陆
+(void)requesetLogin:(NSString *)username andPassword:(NSString *)password success:(void(^)(CodeType codeType,TeacherUser *teacherUser))success fail:(void(^)())fail
{
    //对输入密码进行加密
    NSString *base64Str = [password base64EncodedString];
    //拼接字符串
    NSString *jsonStr = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}",username,base64Str];
    //创建ASIFormDataRequest对象
    __weak ASIFormDataRequest *dataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kTeacherLoginURL]];
    [dataRequest setPostValue:jsonStr forKey:@"info"];
    //开始异步请求
    [dataRequest startAsynchronous];
    [dataRequest setCompletionBlock:^{
        
        NSLog(@"%@",[dataRequest responseString]);
        NSData *data=[dataRequest responseData];
            //数据返回成功后解析数据；

            NSDictionary *listDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];        
            int code = [[listDic objectForKey:@"code"] intValue];
            NSDictionary *teaDic = [listDic objectForKey:@"teacherinfo"];
        
            //创建教师对象；
            TeacherUser *teaUser = [[TeacherUser alloc]initWithDict:teaDic];
            //登陆成功后持久化id
            [[NSUserDefaults standardUserDefaults] setObject:[teaDic objectForKey:@"teacherid"] forKey:kTeacherId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //将解析内容回调

            success(code,teaUser);
        
    }];
    [dataRequest setFailedBlock:^{
        if (fail) {
            fail();
        }
    }];

}

#pragma mark 补充教师信息
+(void)requestDetailInfo:(TeacherUser *)teacherUser success:(void(^)(CodeType codeType))success fail:(void(^)())fail
{
    //拼接字符串
    NSString *jsonStr = [NSString stringWithFormat:@"{\"teacherid\":\"%@\",\"name\":\"%@\",\"birthday\":\"%@\",\"gender\":\"%@\",\"identity\":\"%@\",\"qq\":\"%@\",\"sinaweibo\":\"%@\",\"telephone\":\"%@\",\"degree\":\"%@\",\"timeperiod\":\"%@\",\"objectinfo\":\"%@\",\"subjectinfo\":\"%@\",\"memo\":\"%@\",\"majoraddress\":\"%@\",\"latitude\":\"%f\",\"longitude\":\"%f\"}",teacherUser.teacherid,teacherUser.name,teacherUser.birthday,teacherUser.gender,teacherUser.identity,teacherUser.qq,teacherUser.sinaweibo,teacherUser.telephone,teacherUser.degree,teacherUser.timepriod,teacherUser.objectinfo,teacherUser.subjectinfo,teacherUser.memo,teacherUser.majoraddress,teacherUser.latitude,teacherUser.longitude];
    
//    NSLog(@"________________________%@___________________",jsonStr);
    //创建ASIFormDataRequest对象
    __weak ASIFormDataRequest *dataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:KTeacherOtherInfoURL]];
    [dataRequest setPostValue:jsonStr forKey:@"info"];
    //开始异步请求
    [dataRequest startAsynchronous];
    [dataRequest setCompletionBlock:^{
                    //数据返回成功后解析数据；
        NSData *data=[dataRequest responseData];
        NSLog(@"++++++++++++++++++%@",[dataRequest responseString]);
        NSDictionary *listDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            int code = [[listDic objectForKey:@"code"] intValue];
            success(code);
    }];
    [dataRequest setFailedBlock:^{
        if (fail) {
            fail();
        }
    }];
    
//    古城南里42号

}
#pragma mark 查询教师详情
+(void)requestQueryTeacherId:(int)teacherid accessed:(void (^)(CodeType,  TeacherUser* ))access fail:(void (^)())fail{
    //拼接json
    NSMutableString *json = [NSMutableString stringWithFormat:@"{\"teacherid\"=\"%d\"}",teacherid];
    //判断是如果有关键字则追加到josn后面
    

    //创建ASPHTTPRequest对象
     __weak ASIFormDataRequest *dataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kUrlFindTeacherDetail]];
    [dataRequest setPostValue:json forKey:@"info"];
    [dataRequest startAsynchronous];
    [dataRequest setCompletionBlock:^{
        NSData *data=[dataRequest responseData];
                //数据返回成功后解析数据
        NSError *error;
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"info=%@",info);
            int code = [info[@"code"]intValue];
            //获取教师详情字典
            NSDictionary *dict = info[@"teacherinfo"];
            TeacherUser *detail = [[TeacherUser alloc]initWithDict:dict];
            //将解析的内容回掉
            access(code,detail);
    }];
    [dataRequest setFailedBlock:^{
        if (fail) {
            fail();
        }
    }];

}



#pragma mark 教师头像上传
+(void)requestIconUpload:(NSString *)filepath andTeacherid:(NSString *)teacherid success:(void(^)(CodeType codeType))success fail:(void(^)())fail
{
    __weak ASIFormDataRequest *dataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kTeacherIconUpload]];
    [dataRequest setFile:filepath  forKey:@"teachericon"];
    [dataRequest setPostValue:teacherid forKey:@"teacherid"];
    [dataRequest startAsynchronous];
    [dataRequest setCompletionBlock:^{
        NSData *data=[dataRequest responseData];
        NSLog(@"%@",[dataRequest responseString]);
        NSDictionary *listDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        int code = [[listDic objectForKey:@"code"] intValue];
        success(code);
    }];
    [dataRequest setFailedBlock:^{
        if (fail) {
            fail();
        }
    }];

}

#pragma mark 教师取得订单列表
+(void)requesetOrderList:(NSString *)teacherid andOrderStatus:(OrderStatus)orderstatus andPage:(int)page success:(void(^)(CodeType codeType,NSArray* lists))success fail:(void(^)())fail
{
   
    
    
    
    //拼接字符串
    NSString *jsonStr = [NSString stringWithFormat:@"{\"teacherid\":%@,\"orderstatus\":%d,\"page\":%d,\"count\":10}",teacherid,orderstatus,page];
    
    NSLog(@"%@",jsonStr);
    __weak ASIFormDataRequest *dataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kTeacherOrderList]];
    [dataRequest setPostValue:jsonStr forKey:@"info"];
    [dataRequest startAsynchronous];
    [dataRequest setCompletionBlock:^{
        NSData *data=[dataRequest responseData];
                   NSDictionary *listDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            int code = [[listDic objectForKey:@"code"] intValue];
            NSArray *listArr = [listDic objectForKey:@"ordersinfo"];
        NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:42];
        for(NSDictionary *dict in listArr){
            Order *order = [[Order alloc]initWithDict:dict];
            [newArray addObject:order];
        }
        
            success(code,newArray);
    }];
    [dataRequest setFailedBlock:^{
        if (fail) {
            fail();
        }
    }];

}

#pragma mark 取得订单详情
+(void)requestOrderDetail:(int)orderid success:(void(^)(CodeType codeType,OrderDetail *orderDetail))success fail:(void(^)())fail
{
    NSString *jsonStr = [NSString stringWithFormat:@"{\"orderid\":\"%d\"}",orderid];
    __weak ASIFormDataRequest *dataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kTeacherOrderDetail]];
    [dataRequest setPostValue:jsonStr forKey:@"info"];
    [dataRequest startAsynchronous];
    [dataRequest setCompletionBlock:^{
        NSData *data=[dataRequest responseData];
            NSDictionary *listDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            int code = [[listDic objectForKey:@"code"] intValue];
            NSDictionary *orderDic = [listDic objectForKey:@"orderinfo"];
            OrderDetail *orderDetail = [[OrderDetail alloc]initWithDict:orderDic];
            success(code,orderDetail);
    }];
    [dataRequest setFailedBlock:^{
        if (fail) {
            fail();
        }
    }];

}

#pragma mark 教师确认订单
+(void)requestConfirmOrder:(int)orderid success:(void(^)(CodeType codeType,OrderStatus order_status))success fail:(void(^)())fail
{
    NSString *jsonStr = [NSString stringWithFormat:@"{\"orderid\":\"%d\",\"orderstatus\":\"%@\"}",orderid,[@(kOrderStatusTeacherNotarize) stringValue]];
    __weak ASIFormDataRequest *dataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kTeacherConfirmOrder]];
    [dataRequest setPostValue:jsonStr forKey:@"info"];
    [dataRequest startAsynchronous];
    [dataRequest setCompletionBlock:^{
        NSData *data=[dataRequest responseData];
        NSDictionary *listDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        int code = [[listDic objectForKey:@"code"] intValue];
        int orderStatus = [[listDic objectForKey:@"orderstatus"] intValue];
            success(code,orderStatus);
    }];
    [dataRequest setFailedBlock:^{
        if (fail) {
            fail();
        }
    }];

    
}

#pragma mark 教师取消订单
+(void)requestCancelOrder:(int)orderid andReason:(NSString *)reason success:(void(^)(CodeType codeType,OrderStatus order_status))success fail:(void(^)())fail
{
    NSString *jsonStr = [NSString stringWithFormat:@"{\"orderid\":\"%d\",\"orderstatus\":\"%@\",\"memo\":\"%@\"}",orderid,[@(kOrderStatusTeacherRefuse) stringValue],reason];
   __weak ASIFormDataRequest *dataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kTeacherCancelOrder]];
    [dataRequest setPostValue:jsonStr forKey:@"info"];
    dataRequest.delegate = self;
    [dataRequest startAsynchronous];
    [dataRequest setCompletionBlock:^{
        NSData *data=[dataRequest responseData];
            NSDictionary *listDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            int code = [[listDic objectForKey:@"code"] intValue];
            int orderStatus = [[listDic objectForKey:@"orderstatus"] intValue];
            success(code,orderStatus);
    }];
    [dataRequest setFailedBlock:^{
        if (fail) {
            fail();
        }
    }];

}

#pragma mark 教师确认完成订单
+(void)requestCompleteOrder:(int)orderid success:(void(^)(CodeType codeType,int order_status))success fail:(void(^)())fail
{
    NSString *jsonStr = [NSString stringWithFormat:@"{\"orderid\":\"%d\",\"orderstatus\":\"%@\"}",orderid,[@(kOrderStatusTeacherNotarizeFinish) stringValue]];
    __weak ASIFormDataRequest *dataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kTeacherCompleteOrder]];
    [dataRequest setPostValue:jsonStr forKey:@"info"];
    dataRequest.delegate = self;
    [dataRequest startAsynchronous];
    [dataRequest setCompletionBlock:^{
        NSData *data=[dataRequest responseData];
            NSDictionary *listDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            int code = [[listDic objectForKey:@"code"] intValue];
            int orderStatus = [[listDic objectForKey:@"orderstatus"] intValue];
            success(code,orderStatus);
    }];
    [dataRequest setFailedBlock:^{
        if (fail) {
            fail();
        }
    }];

}
#pragma mark 删除订单
+ (void)requestDeleteOrderWithOrderid:(int)orderid accessed:(void (^)(CodeType))access fail:(void (^)())fail{
    //拼接json
    NSString *json = [NSMutableString stringWithFormat:@"{\"orderid\"=%@}",[@(orderid)stringValue]];
    //判断是如果有关键字则追加到josn后面
   // MyLog(@"订单列表 json:%@",json);
    
    //创建ASPHTTPRequest对象
    __weak ASIFormDataRequest *dataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kUrlDeleteOrder]];
    [dataRequest setPostValue:json forKey:@"info"];
    [dataRequest startAsynchronous];
    [dataRequest setCompletionBlock:^{
        
        //数据返回成功后解析数据
        NSDictionary *info =  [NSJSONSerialization JSONObjectWithData:[dataRequest responseData] options:NSJSONReadingMutableContainers error:nil];
        int code = [info[@"code"]intValue];
        //将解析的内容回掉
        access(code);
    }];
    [dataRequest setFailedBlock:^{
        
        fail();
        
    }];
    
}



@end
