//
//  MoveView.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-7.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "MoveView.h"

@implementation MoveView

#pragma mark 上移view
+ (void)moveTopOffset:(int)ofSet inView:(UIView *)view duration:(NSTimeInterval)time{
   
    [UIView animateWithDuration:time animations:^{
        CGRect frame = view.frame;
        frame.origin.y -= ofSet;
        view.frame = frame;
    }];
}

#pragma mark 下移view

+ (void)moveDownOffset:(int)ofSet inView:(UIView *)view duration:(NSTimeInterval)time {

    [UIView animateWithDuration:time animations:^{
        CGRect frame = view.frame;
        frame.origin.y += ofSet;
        view.frame = frame;
    }];
}

@end
