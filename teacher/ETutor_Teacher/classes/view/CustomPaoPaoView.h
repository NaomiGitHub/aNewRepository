//
//  CustomPaoPaoView.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-2.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//  自定义气泡

#import <UIKit/UIKit.h>
//#import "Teacher.h"
#import "Order.h"
@interface CustomPaoPaoView : UIImageView

@property (nonatomic , strong)Order *order;
@property (nonatomic , copy)void (^openDetailView)(Order *);

@end
