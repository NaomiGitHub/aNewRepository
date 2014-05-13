//
//  UITextField+TextField.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-4.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "UITextField+TextField.h"

@implementation UITextField (TextField)

+ (UITextField *)searchFieldWithRect:(CGRect)rect placeholder:(NSString *)placeholder{
    UITextField *textField = [[UITextField alloc]init];
    textField.frame = rect;
    textField.layer.cornerRadius = 5;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = kSetColor(44, 181, 255 , 1).CGColor;
    textField.placeholder = placeholder;
    textField.font = [UIFont boldSystemFontOfSize:14];
    textField.textColor = kDefineColor;
    textField.textAlignment = NSTextAlignmentCenter;
    return textField;
}

@end
