//
//  OrderListCell.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-18.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Order;
@interface OrderListCell : UITableViewCell
@property (nonatomic , strong)Order *order;
@property (nonatomic , copy)void (^deleteOrderOperation)(Order *order);
@property (nonatomic , copy)void (^cancelOrderOperation)(Order *order);
@property (nonatomic , copy)void (^continueOrderOperation)(Order *order);
@end
