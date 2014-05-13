//
//  TimePicker.h
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-26.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePicker : UIView
@property(strong,nonatomic)UIDatePicker *startPicher;
@property(strong,nonatomic)UIDatePicker *endPicker;
@property(copy,nonatomic)NSString *start;
@property(copy,nonatomic)NSString *end;
@property(strong,nonatomic)void(^timeBlock)(NSString *time);
@end
