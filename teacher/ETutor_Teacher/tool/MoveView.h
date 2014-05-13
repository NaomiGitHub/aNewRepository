//
//  MoveView.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-7.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//  view的移动

#import <Foundation/Foundation.h>

@interface MoveView : NSObject

+ (void)moveTopOffset:(int)ofSet inView:(UIView *)view duration:(NSTimeInterval)time;
+ (void)moveDownOffset:(int)ofSet inView:(UIView *)view  duration:(NSTimeInterval)time ;

@end
