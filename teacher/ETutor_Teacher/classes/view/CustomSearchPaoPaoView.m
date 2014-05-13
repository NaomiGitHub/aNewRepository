//
//  CustomSearchPaoPaoView.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-5.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "CustomSearchPaoPaoView.h"
#import "NSString+Address.h"
#import "UIImage+Size.h"

#define kClickButWidth 100
#define kClickButHeight 20
@implementation CustomSearchPaoPaoView{
    UILabel *titlelable;
    UIButton *clickBut;
    UIImageView *leftView;
    UIImageView *rightView;
}

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = YES;
        [self addControl];
    }
    return self;
}

- (void)addControl{
    //添加左右侧背景
    leftView = [[UIImageView alloc]init];
    [self addSubview:leftView];
    
    rightView = [[UIImageView alloc]init];
    [self addSubview:rightView];
    
    //添加当前地址标签
    titlelable = [[UILabel alloc]init];
    titlelable.numberOfLines = 0;
    titlelable.textAlignment = NSTextAlignmentCenter;
    titlelable.font = [UIFont systemFontOfSize:14];
    [self addSubview:titlelable];
    
    //选择当前地址按钮
    clickBut = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBut.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    clickBut.layer.borderWidth = 1;
    clickBut.layer.borderColor = [UIColor blackColor].CGColor;
    clickBut.backgroundColor = [UIColor greenColor];
    clickBut.layer.cornerRadius = 5;
    [clickBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [clickBut setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [clickBut setTitle:@"设置为我的位置" forState:UIControlStateNormal];
    [clickBut addTarget:self action:@selector(clickBut) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clickBut];
   
}
#pragma mark 重写setTitle方法，设置控件位置
- (void)setOtherAddress:(NSString *)otherAddress{

    _otherAddress = otherAddress;
    
    //以title字体个数大小获取title的大小
    CGRect rect = [otherAddress boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    
    //根据title大小改变本身控件的大小
    CGRect frame = self.frame;
    frame.size.width = rect.size.width + kDefineMargin*2;
    self.frame = frame;
    
    
    //设置左右背景的大小
    CGFloat backGroudViewWidth =  rect.size.width > kClickButWidth?rect.size.width:kClickButWidth+kDefineMargin*2;
    
    leftView.frame = CGRectMake(0, 0,backGroudViewWidth*0.5, frame.size.height);
    rightView.frame = CGRectMake(CGRectGetMaxX(leftView.frame), 0, backGroudViewWidth*0.5, frame.size.height);
    
    leftView.image=[UIImage resizableImageWithIcon:[NSString getMyBundlePath1:@"images/icon_paopao_middle_left.png"]];
    rightView.image = [UIImage resizableImageWithIcon:[NSString getMyBundlePath1:@"images/icon_paopao_middle_right.png"]];
    
    titlelable.frame = (CGRect){{backGroudViewWidth/2 - rect.size.width/2 , kDefineMargin},rect.size};
    titlelable.text = otherAddress;
    
    clickBut.frame = CGRectMake(backGroudViewWidth*0.5-kClickButWidth*0.5, CGRectGetMaxY(titlelable.frame)+kDefineMargin , kClickButWidth, kClickButHeight);
    
}

- (void)clickBut{
    //拼接标准地址
    NSString *address = [NSString jointNormAddressWithProvince:@"未知" city:_cityAddress other:_otherAddress];
    self.changeAddress(address);
}


@end
