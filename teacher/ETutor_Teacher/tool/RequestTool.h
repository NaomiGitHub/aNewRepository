//
//  RequestTool.h
//  ETutor_Teacher
//
//  Created by fengpengfei on 14-2-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "Base64.h"
#import "TeacherUser.h"
#import "Order.h"
#import "OrderDetail.h"
/**
 服务器返回code值类型
 *0：成功
 *1：失败
 */
typedef enum {
    kCode_success = 0,
    kCode_fail = 1,
    kCode_equal =2
}CodeType;


@interface RequestTool : NSObject<ASIHTTPRequestDelegate>

//教师注册；
+(void)requestRegister:(NSString *)username andPassword:(NSString *)password success:(void(^)(CodeType codeType,NSString *teacherid))success fail:(void(^)())fail;

//教师登陆；
+(void)requesetLogin:(NSString *)username andPassword:(NSString *)password success:(void(^)(CodeType codeType,TeacherUser *teacherUser))success fail:(void(^)())fail;

//补充教师信息；
+(void)requestDetailInfo:(TeacherUser *)teacherUser success:(void(^)(CodeType codeType))success fail:(void(^)())fail;

//查找教师详情
+(void)requestQueryTeacherId:(int)teacherid accessed:(void(^)(CodeType codeType,TeacherUser *teacher))access fail:(void(^)())fail;

//教师头像上传
+(void)requestIconUpload:(NSString *)filepath andTeacherid:(NSString *)teacherid success:(void(^)(CodeType codeType))success fail:(void(^)())fail;

//取得教师订单列表
+(void)requesetOrderList:(NSString *)teacherid andOrderStatus:(OrderStatus)orderstatus andPage:(int)page success:(void(^)(CodeType codeType,NSArray* lists))success fail:(void(^)())fail;

//取得订单详情
+(void)requestOrderDetail:(int)orderid success:(void(^)(CodeType codeType,OrderDetail *orderDetail))success fail:(void(^)())fail;

//教师确认订单
+(void)requestConfirmOrder:(int)orderid success:(void(^)(CodeType codeType,OrderStatus order_status))success fail:(void(^)())fail;

//教师取消订单
+(void)requestCancelOrder:(int)orderid andReason:(NSString *)reason success:(void(^)(CodeType codeType,OrderStatus order_status))success fail:(void(^)())fail;

//教师确认完成订单
+(void)requestCompleteOrder:(int)orderid success:(void(^)(CodeType codeType,int order_status))success fail:(void(^)())fail;

//删除订单
+ (void)requestDeleteOrderWithOrderid:(int)orderid accessed:(void(^)(CodeType codeType))access fail:(void(^)())fail;

@end
