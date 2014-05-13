//
//  TimePicker.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-26.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "TimePicker.h"

@implementation TimePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=kSetColor(0.6, 0.6, 0.6, 1);
        [self timePickerView];
    }
    return self;
}
-(void)timePickerView
{
    UIButton *cancle=[UIButton buttonWithType:UIButtonTypeCustom];
    cancle.frame=CGRectMake(0, 0, 50, 40);
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancle];
    UIView *vorline=[[UIView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, 2)];
    vorline.backgroundColor=[UIColor blackColor];
    [self addSubview:vorline];
    UIButton *sure=[UIButton buttonWithType:UIButtonTypeCustom];
    sure.frame=CGRectMake(self.frame.size.width-50, 0, 50, 40);
    [sure setTitle:@"完成" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sure];
    
    self.startPicher=[[UIDatePicker alloc]init];
    self.startPicher.tintColor=[UIColor whiteColor];
    
    self.startPicher.frame=CGRectMake(0, 40, self.frame.size.width*0.5-10, self.frame.size.height);
    self.startPicher.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.startPicher.datePickerMode=UIDatePickerModeTime;
    [self.startPicher addTarget:self action:@selector(startTime:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.startPicher];
    
    UIImageView *jiantou=[[UIImageView alloc]init];
    jiantou.frame=CGRectMake(CGRectGetMaxX(self.startPicher.frame), self.frame.size.width*0.5-10, 20, 20);
    [self addSubview:jiantou];
    
    self.endPicker=[[UIDatePicker alloc]init];
    self.endPicker.tintColor=[UIColor blackColor];
    self.endPicker.frame=CGRectMake(CGRectGetMaxX(jiantou.frame), 40, self.frame.size.width*0.5-10, self.frame.size.height);
    self.endPicker.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.endPicker.datePickerMode=UIDatePickerModeTime;
    [self.endPicker addTarget:self action:@selector(endTime:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.endPicker];
}
-(void)cancle
{
    [self removeFromSuperview];
    self.start=nil;
    self.startPicher=nil;
    self.end=nil;
    self.endPicker=nil;
}
-(void)sure
{
    if ([self.start isEqualToString:@""]||[self.start isEqualToString:@""]) {
        
    }else
    {
        NSString *time=[NSString stringWithFormat:@"%@-%@",self.start,self.end];
        self.timeBlock(time);
    }
    [self cancle];
}
-(void)startTime:(UIDatePicker *)sender
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"HH:mm";
    self.start=[formatter stringFromDate:sender.date];
    self.endPicker.minimumDate=sender.date;
}
-(void)endTime:(UIDatePicker *)sender
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"HH:mm";
    self.end=[formatter stringFromDate:sender.date];
}
@end
