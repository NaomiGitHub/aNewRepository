//
//  UIButton+Button.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-4.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Button)
typedef enum{
    kMen = 3001,
    kWomen
}TeacherSex;
//创建地图切换按钮
+ (UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame  Target:(id)target action:(SEL)selector mapType:(MapType)maptype;
//建造返回按钮
+ (UIButton *)backButton;
//创建item
+ (UIButton *)itemButtonWithIcon:(NSString *)icon frame:(CGRect)frame;
//创建科目按钮
+ (UIButton *)subjectButtonWithTitle:(NSString *)title frame:(CGRect)frame;
//创建选择性别按钮
+ (UIButton *)chooseSexTeacherWithSex:(TeacherSex)teachersex frame:(CGRect)frame;
//创建距离选择按钮
+ (UIButton *)distancefilterWithTitle:(NSString *)title frame:(CGRect)frame;
//创建订单swtich按钮
+ (UIButton *)orderSwitchWithTitle:(NSString *)title frame:(CGRect)frame;
//创建删除按钮
+ (UIButton *)deleteButtonWithTitle:(NSString *)title frame:(CGRect)frame;
@end
