//
//  LineSearchView.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-4.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "LineSearchView.h"
#import "Order.h"
#import "TeacherUser.h"
#import "NSString+Address.h"
#import "UITextField+TextField.h"
#import "PXAlertView.h"
#define kSearchTextFieldWidth 180
#define kSearchTextFieldHeight 30
#define kSearchButWidth 85
#define kSearchButHeight 25
#define kOpenListButHeight 30
#define kOpenListButWidth 30
#define kTeacherListHeight 200
@implementation LineSearchView{
    UITextField *_startText;   //起点
    UITextField *_endText;     //终点
    UIButton *_walkSearchBut;  //步行路线
    UIButton *_busSeatchBut;   //公交路线
    UIButton *_openList;       //选择教师地址
    UIImageView *_endBackView;
    
    Order *order; //当前选中的教师
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置自身属性
        self.backgroundColor = kSetColor(245, 110, 0, 1);
        self.layer.cornerRadius = 5;
        self.userInteractionEnabled = YES;
        self.layer.masksToBounds = YES;
        [self addControl];
    
    }
    return self;
}
#pragma mark 添加控件
- (void)addControl{
    //起点
    UILabel *startLabel = [[UILabel alloc]init];
    startLabel.text = @"我的位置:";
    startLabel.textColor = kDefineColor;
    startLabel.font = [UIFont boldSystemFontOfSize:14];
    startLabel.frame = CGRectMake(kDefineMargin*2, kDefineMargin*2, 70, kSearchTextFieldHeight);
    [self addSubview:startLabel];
    
    _startText = [UITextField searchFieldWithRect:CGRectMake(CGRectGetMaxX(startLabel.frame), kDefineMargin*2, kSearchTextFieldWidth, kSearchTextFieldHeight ) placeholder:@"起点"];
    _startText.userInteractionEnabled = NO;
    [self addSubview:_startText];
    
    //终点
    UILabel *endLabel = [[UILabel alloc]init];
    endLabel.text = @"教师位置:";
    endLabel.textColor = kDefineColor;
    endLabel.font = [UIFont boldSystemFontOfSize:14];
    endLabel.frame = CGRectMake(kDefineMargin*2, CGRectGetMaxY(_startText.frame)+kDefineMargin, 70, kSearchTextFieldHeight);
    [self addSubview:endLabel];
    
    //终点地址背景view
    _endBackView = [[UIImageView alloc]init];
    _endBackView.frame = CGRectMake(CGRectGetMaxX(startLabel.frame), CGRectGetMinY(endLabel.frame), kSearchTextFieldWidth , kSearchTextFieldHeight );
    _endBackView.layer.cornerRadius = 5;
    _endBackView.layer.borderWidth = 1;
    _endBackView.layer.borderColor = kSetColor(44, 181, 255 , 1).CGColor;
    _endBackView.layer.masksToBounds = YES;
    _endBackView.userInteractionEnabled = YES;
    [self addSubview:_endBackView];
    
    _endText   = [UITextField searchFieldWithRect:CGRectMake(0, 0 , kSearchTextFieldWidth, kSearchTextFieldHeight ) placeholder:@"终点"];
    _endText.userInteractionEnabled = NO;
    _endText.layer.borderWidth = 0;
    [_endBackView addSubview:_endText];
    
    
    //添加搜索按钮
    _walkSearchBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _walkSearchBut.frame = CGRectMake(self.frame.size.width/2-kDefineMargin-kSearchButWidth, CGRectGetMaxY(_endBackView.frame)+kDefineMargin, kSearchButWidth, kSearchButHeight);
    _walkSearchBut.layer.cornerRadius = 5;
    _walkSearchBut.tag = kWalkSearch;
    _walkSearchBut.backgroundColor =  kSetColor(44, 181, 255 , 1);
    _walkSearchBut.titleLabel.font = kTitleBoladNormalFont;
    _walkSearchBut.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_walkSearchBut addTarget:self action:@selector(lineSearch:) forControlEvents:UIControlEventTouchUpInside];
    [_walkSearchBut setTitle:@"步行路线" forState:UIControlStateNormal];
    [self addSubview:_walkSearchBut];
    
    _busSeatchBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _busSeatchBut.frame = CGRectMake(self.frame.size.width/2+kDefineMargin, CGRectGetMaxY(_endBackView.frame)+kDefineMargin, kSearchButWidth, kSearchButHeight);
    _busSeatchBut.layer.cornerRadius = 5;
    _busSeatchBut.tag = kBusLineSearch;
    _busSeatchBut.backgroundColor = kSetColor(44, 181, 255 , 1);
    _busSeatchBut.titleLabel.font = kTitleBoladNormalFont;
    _busSeatchBut.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_busSeatchBut addTarget:self action:@selector(lineSearch:) forControlEvents:UIControlEventTouchUpInside];
    [_busSeatchBut setTitle:@"公交路线" forState:UIControlStateNormal];
    [self addSubview:_busSeatchBut];

}

#pragma mark 打开或关闭教师列表
- (void)openTeacherList:(UIButton *)button{
    button.selected = !button.selected;
    if(button.selected){
        [UIView animateWithDuration:0.4 animations:^{
            button.transform = CGAffineTransformMakeRotation(3.15);
        }];
        [self openList];
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            button.transform = CGAffineTransformMakeRotation(0);
        }];
        [self closeList];
    }
}


#pragma mark 弹出选择列表
- (void)openList{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = self.frame;
        frame.size.height += kTeacherListHeight;
        self.frame = frame;
        
        CGRect endFrame = _endBackView.frame;
        endFrame.size.height += kTeacherListHeight;
        _endBackView.frame = endFrame;
        
        CGRect walkFrame = _walkSearchBut.frame;
        walkFrame.origin.y += kTeacherListHeight;
        _walkSearchBut.frame = walkFrame;
        
        CGRect busFrame = _busSeatchBut.frame;
        busFrame.origin.y += kTeacherListHeight;
        _busSeatchBut.frame = busFrame;
        
    }];
    _isOpenAddressList = YES;
}

#pragma mark 关闭选择列表
- (void)closeList{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = self.frame;
        frame.size.height -= kTeacherListHeight;
        self.frame = frame;
        
        CGRect endFrame = _endBackView.frame;
        endFrame.size.height -= kTeacherListHeight;
        _endBackView.frame = endFrame;
        
        CGRect walkFrame = _walkSearchBut.frame;
        walkFrame.origin.y -= kTeacherListHeight;
        _walkSearchBut.frame = walkFrame;
        
        CGRect busFrame = _busSeatchBut.frame;
        busFrame.origin.y -= kTeacherListHeight;
        _busSeatchBut.frame = busFrame;
        
    }];
    _isOpenAddressList = NO;
}

- (void)setIsOpenAddressList:(BOOL)isOpenAddressList{
    _isOpenAddressList = isOpenAddressList;
    if(!_isOpenAddressList){
        _openList.selected = !_openList.selected;
        [UIView animateWithDuration:0.4 animations:^{
            _openList.transform = CGAffineTransformMakeRotation(0);
        }];
        [self closeList];
        
    }
}

#pragma mark 点击查询按钮后回掉给控制器
/**
 *回掉参数
 *1:查询类型
 *2:终点地址
 */
- (void)lineSearch:(UIButton *)button{
       self.searchLine(button.tag , order);
}

- (void)setStartAddress:(NSString *)startAddress{
    _startAddress = [NSString stringWithAddress:startAddress][kOtherAddress];
    _startText.text = _startAddress;
}

- (void)setEndAddress:(NSString *)endAddress{
    _endAddress = endAddress;
    _endText.text = _endAddress;
}
@end
