//
//  UITextField+TextField.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-4.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (TextField)
//快速创建textField
+ (UITextField *)searchFieldWithRect:(CGRect)rect placeholder:(NSString *)placeholder;
@end
