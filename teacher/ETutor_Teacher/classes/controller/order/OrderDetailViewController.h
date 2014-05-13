//
//  OrderDetailViewController.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-20.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    //不可操作
    kCannot = 1040,
    
    kNotarizeOrder,
    //确认完成
    kNotarizeFinish,
    //取消订单
    kCancel,
    //继续预约
    kContinue,
    //删除订单
    kDelete
}OperationOrderType;
@class OrderDetail;
@interface OrderDetailViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic , strong)OrderDetail *orderDetail;
@end
