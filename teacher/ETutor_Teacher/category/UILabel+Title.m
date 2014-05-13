//
//  UILabel+Title.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-9.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "UILabel+Title.h"
#define kDefineColor kSetColor(0.98 , 0.98, 0.98, 1)
#define kTitleBoladNormalFont [UIFont boldSystemFontOfSize:14]
#define kTitleBoladBigFont [UIFont boldSystemFontOfSize:16]
#define kTitleNormalFont [UIFont boldSystemFontOfSize:14]

@implementation UILabel (Title)
#pragma mark 快速创建tabBar上item的标题
+ (UILabel *)itemTitleWithFrame:(CGRect)frame title:(NSString *)title{
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.textColor = kDefineColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = kTitleBoladNormalFont;
    label.textColor = kDefineColor;
    label.frame = frame;
    return label;
}

#pragma mark 快速创建订单详情中的title
+ (UILabel *)orderDeatilTitle:(NSString *)title frame:(CGRect)frame{
    UILabel *teacherTitle = [[UILabel alloc]init];
    teacherTitle.text = title;
    teacherTitle.font = kTitleBoladBigFont;
    teacherTitle.textColor = [UIColor whiteColor];
    teacherTitle.textAlignment = NSTextAlignmentCenter;
    teacherTitle.frame = frame;
    teacherTitle.backgroundColor = kSetColor(0.17, 0.7, 1, 1);
    return teacherTitle;
}
+ (UILabel *)orderDeatilContent:(NSString *)title frame:(CGRect)frame{
    UILabel *teacherTitle = [[UILabel alloc]init];
    teacherTitle.text = title;
    teacherTitle.font = kTitleNormalFont;
    teacherTitle.textColor = [UIColor brownColor];
    teacherTitle.textAlignment = NSTextAlignmentCenter;
    teacherTitle.frame = frame;
    teacherTitle.layer.borderWidth = 1.5;
    teacherTitle.layer.borderColor = kSetColor(0.17, 0.7, 1 , 1).CGColor;
   
    return teacherTitle;
}
@end
