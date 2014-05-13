//
//  UILabel+Title.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-9.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Title)
//创建item标题
+ (UILabel *)itemTitleWithFrame:(CGRect)frame title:(NSString *)title;
//创建订单详情中的标题
+ (UILabel *)orderDeatilTitle:(NSString *)title frame:(CGRect)frame;
+ (UILabel *)orderDeatilContent:(NSString *)title frame:(CGRect)frame;
@end
