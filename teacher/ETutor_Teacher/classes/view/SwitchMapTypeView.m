//
//  SwitchMapTypeView.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-4.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "SwitchMapTypeView.h"
#import "UIButton+Button.h"
#define kButtonHeight 40
#define kLeftLineWidth 3
#define kBottomLineHeight 1

@implementation SwitchMapTypeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kSetColor(5, 15, 25, 1);
        self.userInteractionEnabled = YES;
        [self addControl];
    }
    return self;
}

#pragma mark 添加控件
- (void)addControl{
    CGRect frame = self.frame;
//    UILabel *title = [[UILabel alloc]init];
//    title.text = @"更 多 操 作";
//    title.frame = CGRectMake(0, 0, frame.size.width, kNavBarHeight+kBottomLineHeight*0.5);
//    title.font =  kTitleBoladBigFont;
//    title.textColor = [UIColor brownColor];
//    title.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:title];
    
//    //添加分割线
//    UILabel *line = [[UILabel alloc]init];
//    line.backgroundColor = [UIColor whiteColor];
//    line.frame = CGRectMake(0, title.frame.size.height - kBottomLineHeight, frame.size.width, kBottomLineHeight);
//    [title addSubview:line];

    //添加左侧分割线
    UILabel *leftline = [[UILabel alloc]init];
    leftline.backgroundColor = kSetColor(44, 181, 255 , 1);
    leftline.frame = CGRectMake(0, 0, kLeftLineWidth , self.frame.size.height);
    [self addSubview:leftline];
    
    
    //切换正常地图
    CGRect switchNormalframe = CGRectMake(kLeftLineWidth, frame.size.height*0.2, frame.size.width , kButtonHeight);
    UIButton *switchNormal = [UIButton buttonWithTitle:@"标 准 视 图" frame:switchNormalframe Target:self action:@selector(switchMapType:) mapType:kMapStandard];
    [self addSubview:switchNormal];
    
    //切换卫星试图
    CGRect satelliteframe = CGRectMake(kLeftLineWidth, CGRectGetMaxY(switchNormalframe)+kDefineMargin*1.5, frame.size.width , kButtonHeight);
    UIButton *switchSatellite = [UIButton buttonWithTitle:@"卫 星 视 图" frame:satelliteframe Target:self action:@selector(switchMapType:) mapType:kMapSatellite];
    [self addSubview:switchSatellite];
    
    //切换实时路况图
    CGRect trafficOnframe =CGRectMake(kLeftLineWidth, CGRectGetMaxY(satelliteframe)+kDefineMargin*1.5, frame.size.width , kButtonHeight);
    UIButton *switchTrafficOn = [UIButton buttonWithTitle:@"实 时 路 况 图" frame:trafficOnframe Target:self action:@selector(switchMapType:) mapType:kMapTrafficOn];
    [self addSubview:switchTrafficOn];
    
    
    //公交路线图
    CGRect butLineOnframe = CGRectMake(kLeftLineWidth, CGRectGetMaxY(trafficOnframe)+kDefineMargin*1.5, frame.size.width , kButtonHeight);
    UIButton *switchButLine = [UIButton buttonWithTitle:@"路 线 查 询" frame:butLineOnframe Target:self action:@selector(switchMapType:) mapType:kMapBusLines];
    [self addSubview:switchButLine];
    
    //正常显示老师标注的地图
    CGRect normalframe = CGRectMake(kLeftLineWidth, CGRectGetMaxY(butLineOnframe)+kDefineMargin*1.5, frame.size.width , kButtonHeight);
    UIButton *normal = [UIButton buttonWithTitle:@"恢复 教师 位置" frame:normalframe Target:self action:@selector(switchMapType:) mapType:kNormal];
    [self addSubview:normal];
    
}

#pragma mark 切换地图事件
- (void)switchMapType:(UIButton *)sender{
    //将切换类型回掉给控制器
    self.switchMapType(sender.tag);
}

@end
