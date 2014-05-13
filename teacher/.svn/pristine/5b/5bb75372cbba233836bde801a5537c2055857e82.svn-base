//
//  UIBarButtonItem+Items.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-2-28.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "UIBarButtonItem+Items.h"

@implementation UIBarButtonItem (Items)
//设置只带图片的item
+(UIBarButtonItem *)barButtonItemWithIcon:(NSString *)icon target:(id)target action:(SEL)action
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
     [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.bounds=(CGRect){CGPointZero,CGSizeMake(30, 30)};
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}
//设置带图片 带title 的item
+(UIBarButtonItem *)barButtonItemWithTile:(NSString *)title icon:(NSString *)icon size:(CGSize)size target:(id)target action:(SEL)action
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.bounds=(CGRect){CGPointZero,size};
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:12];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

@end
