//
//  CustomPaoPaoView.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-2.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "CustomPaoPaoView.h"
#import "Order.h"
#import "NSString+Address.h"
#define kIconWidth 50
#define kIconHeight 50
#define kImageWidth 230
#define kImageHeight 163
#define kMargin 5
#define kFont [UIFont systemFontOfSize:12]
@implementation CustomPaoPaoView{
    UILabel *_name; //姓名
    UILabel *_address; //地址
    UIImageView *_teacherIcon; //头像
    UILabel *_subjectInfo; //辅导科目
    UIButton *_goDetail; //进入详情
    UIImageView *_backgroudView;
}


- (id)init{
    if(self = [super init]){
        
        self.userInteractionEnabled = YES;
        //设置背景
        
        self.frame = CGRectMake(0, 0, kImageWidth+60, kImageHeight);
        //添加控件
        [self addControl];

    }
    return self;
}

/**
 *添加气泡控件
 */
- (void)addControl{
    
    _backgroudView = [[UIImageView alloc]init];
    _backgroudView.userInteractionEnabled = YES;
    _backgroudView.frame = CGRectMake(96, 0, kImageWidth, kImageHeight);
    _backgroudView.image = [UIImage imageNamed:@"teacher_paopao"];
    [self addSubview:_backgroudView];
    
    _teacherIcon = [[UIImageView alloc]initWithFrame:CGRectMake(kMargin*4 ,kMargin*6, kIconWidth, kIconHeight)];
    _teacherIcon.layer.cornerRadius = 5;
    _teacherIcon.layer.masksToBounds = YES;
    [_backgroudView addSubview:_teacherIcon];
    
    _name = [[UILabel alloc]init];
    _name.font = [UIFont systemFontOfSize:13];
    _name.textColor =  [UIColor whiteColor];
    [_backgroudView addSubview:_name];
    
    _subjectInfo = [[UILabel alloc]init];
    _subjectInfo.textAlignment = NSTextAlignmentLeft;
    _subjectInfo.font = [UIFont systemFontOfSize:13];
    _subjectInfo.textColor =  [UIColor whiteColor];
    [_backgroudView addSubview:_subjectInfo];

    
    _address = [[UILabel alloc]init];
    _address.font = [UIFont systemFontOfSize:13];
    _address.textColor = [UIColor whiteColor];
    _address.textAlignment = NSTextAlignmentLeft;
    _address.numberOfLines = 0;
    [_backgroudView addSubview:_address];
    
    
    _goDetail = [UIButton buttonWithType:UIButtonTypeSystem];
    _goDetail.backgroundColor = kSetColor(44, 181, 255 , 1);
    _goDetail.layer.cornerRadius = 3;
    _goDetail.titleLabel.font = kTitleBoladNormalFont;
    [_goDetail setTitleColor:kDefineColor forState:UIControlStateNormal];
    [_goDetail setTitle:@"了 解 详 情" forState:UIControlStateNormal];
    [_goDetail addTarget:self action:@selector(goDetail) forControlEvents:UIControlEventTouchUpInside];
    [_backgroudView addSubview:_goDetail];
    
    

    
}

/**
 *设置内控件位置
 */
#pragma mark 重写setTeacher设置空间位置及内容
- (void)setOrder:(Order *)order{
    _order = order;

    
    NSString *nameStr = [NSString stringWithFormat:@"%@(用户)",_order.customername];
    _name.frame = CGRectMake(CGRectGetMaxX(_teacherIcon.frame)+kMargin , CGRectGetMinY(_teacherIcon.frame), 100, 15);
    _name.text = nameStr;



    
    NSString *addressStr = [NSString stringWithFormat:@"地址：%@",[NSString stringWithAddress:_order.serviceaddress][kOtherAddress]];
    CGRect addressRect = [addressStr boundingRectWithSize:CGSizeMake(150, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil];
    _address.frame = (CGRect){{CGRectGetMaxX(_teacherIcon.frame)+kMargin,CGRectGetMaxY(_subjectInfo.frame)},addressRect.size};
    _address.text = addressStr;
    
    
    _goDetail.frame = CGRectMake(CGRectGetMinX(_teacherIcon.frame)+kDefineMargin*3,CGRectGetMaxY(_address.frame)+kDefineMargin*1,120,20);
    
}
#pragma mark 打开详情
- (void)goDetail{
    self.openDetailView(self.order);
}
@end
