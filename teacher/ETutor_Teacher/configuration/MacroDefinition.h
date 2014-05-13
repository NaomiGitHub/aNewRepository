//
//  MacroDefinition.h
//  ETutor_Teacher
//
//  Created by 张鼎辉 on 14-2-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//  常用宏定义

#ifndef ETutor_Teacher_MacroDefinition_h
#define ETutor_Teacher_MacroDefinition_h


/**
 *地图类型
 */
typedef enum{
    kMapStandard = 100, //正常地图
    kMapSatellite,      //卫星地图
    kMapTrafficOn,      //实时路况图
    kMapBusLines,        //线路图
    kNormal   //正常显示老师标注的地图
}MapType;
/**
 *地图线路查询类型
 */
typedef enum{
    kBusLineSearch = 0,//公交线路查询
    kWalkSearch,       //步行线路查询
}LineSearchType;

/**
 *订单列表切换值
 */
typedef enum {
    kWaitConfirm = 2240,
    kAlreadyComplete,
    kAlreadyCancel
}OrderSwitchTag;

/**
 *订单的7中状态
 *0：客户发出订单
 *1：教师确认订单
 *2：教师拒绝订单
 *3：客户取消订单
 *4：客户确认订单
 *5：教师确认订单
 *6：双方确认完成
 */
typedef enum{
    kOrderStatusAll = -1,
    kOrderStatusCustomerSend = 0,     //客户发出订单
    kOrderStatusTeacherNotarize = 1,      //教师确认订单
    kOrderStatusTeacherRefuse = 2,        //教师拒绝订单
    kOrderStatusCustomerCancel = 3,       //用户取消订单
    kOrderStatusCustomerNotarize = 4,     //客户确认订单
    kOrderStatusTeacherNotarizeFinish = 5, //教师确认完成
    kOrderStatusCustomerAndTeacherNotarizeFinish //双反确认完成
    
}OrderStatus;


//教师注册提交给服务器的url;
#define kDomainname @"218.249.130.194:8080/ehomeedu"
#define kTeacherRegisterURL [NSString stringWithFormat:@"http://%@/api/teacher/teacherregister.action",kDomainname]
#define kTeacherId @"TeacherId"
//教师登陆提交给服务器的url;
#define kTeacherLoginURL [NSString stringWithFormat:@"http://%@/api/teacher/teacherlogin.action",kDomainname]
//补充教师信息提交给服务器的url;
#define KTeacherOtherInfoURL [NSString stringWithFormat:@"http://%@/api/teacher/teacherotherinfo.action",kDomainname]
//查询教师信息url
#define kUrlFindTeacherDetail [NSString stringWithFormat:@"http://%@/api/customer/findteacherdetail.action",kDomainname]
//获取教师头像
#define kDowlondIconURL(backurl) [NSString stringWithFormat:@"http://%@%@",kDomainname,backurl]
//教师头像上传的URL
#define kTeacherIconUpload [NSString stringWithFormat:@"http://%@/api/teacher/teachericonupload.action",kDomainname]
//教师取得订单列表，提交给服务器的url;
#define kTeacherOrderList [NSString stringWithFormat:@"http://%@/api/teacher/findorderlist.action",kDomainname]
//取得订单详情，提交给服务器的url;
#define kTeacherOrderDetail [NSString stringWithFormat:@"http://%@/api/teacher/findorderdetail.action",kDomainname]
//教师确认订单，提交给服务器的url;
#define kTeacherConfirmOrder [NSString stringWithFormat:@"http://%@/api/teacher/confirmorder.action",kDomainname]
//教师取消订单，提交给服务器的url;
#define kTeacherCancelOrder [NSString stringWithFormat:@"http://%@/api/teacher/cancelorder.action",kDomainname]
//教师确认完成订单，提交给服务器的url;
#define kTeacherCompleteOrder [NSString stringWithFormat:@"http://%@/api/teacher/completeorder.action",kDomainname]

//删除订单
#define kUrlDeleteOrder  [NSString stringWithFormat:@"http://%@/api/common/deleteorder.action",kDomainname]



#endif
