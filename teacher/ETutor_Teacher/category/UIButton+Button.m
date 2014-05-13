//
//  UIButton+Button.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-4.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "UIButton+Button.h"
static int i = 1;
@implementation UIButton (Button)

#pragma mark 快速创建地图切换按钮
+ (UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame Target:(id)target action:(SEL)selector mapType:(MapType)maptype{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:title forState:UIControlStateNormal];
    but.frame = frame;
    but.tag =  maptype;
//    but.layer.cornerRadius = 3;
    but.backgroundColor = kSetColor(44, 181, 255 , 1);
    [but setTitleColor:kDefineColor forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [but addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return but;
}

#pragma mark 快速创建返回按钮
+ (UIButton *)backButton{
    UIButton *backBut = [UIButton buttonWithType:UIButtonTypeCustom];
   
    UIImageView *backView = [[UIImageView alloc]init];
    backView.image = [UIImage imageNamed:@"common_back.png"];
    backView.frame = CGRectMake(0, 0, 15, 15);
    [backBut addSubview:backView];
    
    UILabel *backtitle = [[UILabel alloc]init];
    backtitle.text = @"返回";
    backtitle.textColor = [UIColor grayColor];
    backtitle.font = kTitleNormalFont;
    backtitle.frame = CGRectMake(CGRectGetMaxX(backView.frame)+kDefineMargin*0.3, 0, 50, 15);
    [backBut addSubview:backtitle];
    
    return backBut;
}

#pragma mark 快速创建item
+ (UIButton *)itemButtonWithIcon:(NSString *)icon frame:(CGRect)frame{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = frame;
    [but setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    return but;
}

#pragma mark 快速创建科目按钮
+ (UIButton *)subjectButtonWithTitle:(NSString *)title frame:(CGRect)frame{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.cornerRadius = 3;
    button.backgroundColor = kSetColor(210 , 210, 210, 1);
    button.titleLabel.font = kTitleNormalFont;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return button;
}
#pragma 快速创建选择教师性别按钮
+ (UIButton *)chooseSexTeacherWithSex:(TeacherSex)teachersex frame:(CGRect)frame{
   
    NSString *sexImage = NULL;
    if(teachersex == kMen){
        sexImage = @"男 教 师";
    }else{
        sexImage = @"女 教 师";
    }
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = frame;
    but.layer.cornerRadius = 3;
    but.layer.borderColor = kSetColor(44/255, 181/255, 255/255 , 1).CGColor;
    but.layer.borderWidth = 1.5;
    but.titleLabel.font = kTitleBoladNormalFont;
    [but setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [but setTitle:sexImage forState:UIControlStateNormal];
//    //添加icon
//    UIImageView *icon = [[UIImageView alloc]init];
//    icon.image = [UIImage imageNamed:sexImage];
//    icon.frame = CGRectMake(5, 3, 40 , frame.size.height);
//    [but addSubview:icon];
    
    return but;
}

#pragma mark 快速创建距离选择按钮
+ (UIButton *)distancefilterWithTitle:(NSString *)title frame:(CGRect)frame{
    UIButton *but = [[UIButton alloc]init];
    but.backgroundColor = kDefineColor;
    but.frame = frame;
    but.layer.cornerRadius = 3;
    but.titleLabel.font = kTitleBoladNormalFont;
    [but setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [but setTitle:title forState:UIControlStateNormal];
    return  but;
}
#pragma mark 快速创建订单选择按钮
+ (UIButton *)orderSwitchWithTitle:(NSString *)title frame:(CGRect)frame{
    
    UIButton *but = [[UIButton alloc]init];

    but.frame = frame;

    but.titleLabel.font = kTitleBoladBigFont;
    [but setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [but setTitle:title forState:UIControlStateNormal];
   
    if(i!=3){
        //添加右侧分割线
        UILabel *line = [[UILabel alloc]init];
        line.backgroundColor = [UIColor brownColor];
        line.frame = CGRectMake(frame.size.width-1, 7, 1, frame.size.height-14);
        [but addSubview:line];
    }
    i ++;
    return  but;
}
#pragma mark 快速绘制删除按钮
+ (UIButton *)deleteButtonWithTitle:(NSString *)title frame:(CGRect)frame{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = frame;
    
    //删除图片
    UIImageView *deleteIcon = [[UIImageView alloc]init];
    deleteIcon.frame = CGRectMake(0, 0, frame.size.height+10, frame.size.height);
    [but addSubview:deleteIcon];
    
    //删除文字
    UILabel *deleteTitle = [[UILabel alloc]init];
    deleteTitle.font = kTitleBoladSmallFont;
    deleteTitle.text = title;
    deleteTitle.frame = CGRectMake(CGRectGetMaxX(deleteIcon.frame), 0, frame.size.width-CGRectGetMaxX(deleteIcon.frame), frame.size.height);
    [but addSubview:deleteTitle];
    //line
    UILabel *line = [[UILabel alloc]init];
    line.frame = CGRectMake(CGRectGetMaxX(deleteIcon.frame)*0.5, CGRectGetMaxY(deleteIcon.frame)-1, frame.size.width-CGRectGetMaxX(deleteIcon.frame)*0.5, 0.5);
    [but addSubview:line];
    
    if([title isEqualToString:@"继续预约"]){
        deleteIcon.image = [UIImage imageNamed:@"continueOrder"];
        line.backgroundColor = kSetColor(50/255, 118/255, 191/255, 1);
        deleteTitle.textColor = kSetColor(50/255, 118/255, 191/255, 1);
    }else{
        deleteIcon.image = [UIImage imageNamed:@"deleteOrderIcon"];
        line.backgroundColor = kSetColor(213/255, 25/255, 22/255, 1);
        deleteTitle.textColor = kSetColor(30/255, 30/255, 22/255, 1);
        
    }

    return  but;
}
@end
