//
//  OrderListViewController.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-16.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kDeleteOrder = 123,
    kContinueOrder,
    kCancelOrder
}CurrentOrderOperationType;
@interface OrderListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate>

@end
