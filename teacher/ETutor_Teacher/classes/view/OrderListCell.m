//
//  OrderListCell.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-18.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "OrderListCell.h"
#import "Order.h"
#import "NSString+Address.h"
#import "NSString+Date.h"
#define kTitleBoladNormalFont [UIFont boldSystemFontOfSize:14]
#define kTitleNormalFont [UIFont boldSystemFontOfSize:14]

@implementation OrderListCell{
    //添加状态告示牌
    UILabel *_billboard;
    //教师姓名
    UILabel *_teacherName;
    //授课地址
    UILabel *_serverAddress;
    //订单发起时间
    UILabel *_orderSendDate;
    //删除按钮
    UIButton *_deleteOrder;
    //取消订单按钮
    UIButton *_cancelOrder;
    //继续预约订单按钮
    UIButton * _continueOrder;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addControl];
        self.contentView.backgroundColor = kSetColor(0.98 , 0.98, 0.98, 0.8);
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = [UIColor brownColor].CGColor;
        
        UIImageView *selectedView = [[UIImageView alloc]init];
        selectedView.backgroundColor = kSetColor(0.95 , 0.95, 0.95, 0.8);
        selectedView.layer.borderWidth = 1;
        selectedView.layer.borderColor = kSetColor(0.1, 0.45, 1 , 1).CGColor;
        selectedView.layer.cornerRadius = 5;
        selectedView.layer.masksToBounds = YES;
        self.selectedBackgroundView = selectedView;
        
    }
    return self;
}

#pragma mark 添加控件
- (void)addControl{
    //添加分割线
    UILabel *line = [[UILabel alloc]init];
    line.frame = CGRectMake(10, 93, self.contentView.frame.size.width-20, 1);
    line.backgroundColor = kSetColor(0.1, 0.45, 1, 1);
    [self.contentView addSubview:line];
    
    
    UILabel *nameTitle = [[UILabel alloc]init];
    nameTitle.frame =  CGRectMake(kDefineMargin, kDefineMargin, 70, 20);
    nameTitle.text = @"授课教师:";
    nameTitle.font = kTitleBoladNormalFont;
    nameTitle.textAlignment = NSTextAlignmentLeft;
    nameTitle.textColor = [UIColor brownColor];
    [self.contentView addSubview:nameTitle];
    
    //教师姓名
    _teacherName = [[UILabel alloc]init];
    _teacherName.frame = CGRectMake(CGRectGetMaxX(nameTitle.frame), kDefineMargin, 90, 20);
    _teacherName.font = kTitleNormalFont;
    _teacherName.textAlignment = NSTextAlignmentLeft;
    _teacherName.textColor = kSetColor(0.1, 0.45, 1 , 1);
    [self.contentView addSubview:_teacherName];

    //状态
    UILabel *billboardTitle = [[UILabel alloc]init];
    billboardTitle.frame =  CGRectMake(CGRectGetMaxX(_teacherName.frame), kDefineMargin, 40, 20);
    billboardTitle.text = @"状态:";
    billboardTitle.font = kTitleNormalFont;
    billboardTitle.textAlignment = NSTextAlignmentLeft;
    billboardTitle.textColor = [UIColor brownColor];
    [self.contentView addSubview:billboardTitle];
    
    _billboard = [[UILabel alloc]init];
    _billboard.frame = CGRectMake(CGRectGetMaxX(billboardTitle.frame), kDefineMargin, 200, 20);
    _billboard.font = kTitleSmallFont;
    _billboard.textAlignment = NSTextAlignmentLeft;
    _billboard.textColor = [UIColor redColor];
    [self.contentView addSubview:_billboard];

    
    //授课地址
    UILabel *address = [[UILabel alloc]init];
    address.frame =  CGRectMake(kDefineMargin, CGRectGetMaxY(nameTitle.frame)+kDefineMargin*0.5, 70, 20);
    address.text = @"授课地址:";
    address.font = kTitleBoladNormalFont;
    address.textAlignment = NSTextAlignmentLeft;
    address.textColor = [UIColor brownColor];
    [self.contentView addSubview:address];

    _serverAddress = [[UILabel alloc]init];
    _serverAddress.frame = CGRectMake(CGRectGetMaxX(address.frame), CGRectGetMaxY(nameTitle.frame)+kDefineMargin*0.5, 200, 20);
    _serverAddress.font = kTitleNormalFont;
    _serverAddress.textAlignment = NSTextAlignmentLeft;
    _serverAddress.textColor = kSetColor(0.1, 0.45, 1 , 1);
    [self.contentView addSubview:_serverAddress];
    
    //预约时间
    UILabel *ordertime = [[UILabel alloc]init];
    ordertime.frame =  CGRectMake(kDefineMargin, CGRectGetMaxY(address.frame)+kDefineMargin*0.5, 90, 20);
    ordertime.text = @"预约发起时间:";
    ordertime.font = kTitleBoladNormalFont;
    ordertime.textAlignment = NSTextAlignmentLeft;
    ordertime.textColor = [UIColor brownColor];
    [self.contentView addSubview:ordertime];
    
    _orderSendDate = [[UILabel alloc]init];
    _orderSendDate.frame = CGRectMake(CGRectGetMaxX(ordertime.frame), CGRectGetMaxY(address.frame)+kDefineMargin*0.5, 120, 20);
    _orderSendDate.font = kTitleNormalFont;
    _orderSendDate.textAlignment = NSTextAlignmentLeft;
    _orderSendDate.textColor = kSetColor(0.1, 0.45, 1 , 1);
    [self.contentView addSubview:_orderSendDate];

    //删除按钮
    _deleteOrder = [UIButton deleteButtonWithTitle:@"删除订单" frame:CGRectMake(CGRectGetMaxX(_orderSendDate.frame), CGRectGetMinY(_orderSendDate.frame), 100, 20)];
    [_deleteOrder addTarget:self action:@selector(deleteOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteOrder];
    _deleteOrder.hidden = YES;
    
    //取消订单按钮
    _cancelOrder = [UIButton deleteButtonWithTitle:@"取消订单" frame:CGRectMake(CGRectGetMaxX(_orderSendDate.frame), CGRectGetMinY(_orderSendDate.frame), 100, 20)];
    [_cancelOrder addTarget:self action:@selector(cancelOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_cancelOrder];
    _cancelOrder.hidden = YES;
    
    //继续订单按钮
    _continueOrder = [UIButton deleteButtonWithTitle:@"继续预约" frame:CGRectMake(CGRectGetMaxX(_orderSendDate.frame), CGRectGetMinY(_orderSendDate.frame), 100, 20)];
    [_continueOrder addTarget:self action:@selector(continueOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_continueOrder];
    _continueOrder.hidden = YES;

}
#pragma mark 删除订单
- (void)deleteOrderAction{
    self.deleteOrderOperation(self.order);
}
#pragma mark 取消订单
- (void)cancelOrderAction{
    self.cancelOrderOperation(self.order);
}
#pragma mark 继续订单
- (void)continueOrderAction{
    self.continueOrderOperation(self.order);
}
#pragma mark 获取order时设置控件内容
- (void)setOrder:(Order *)order{
    _order = order;
    //根据订单状态不同设置不同的告示牌
    
    switch (order.orderStatus) {
        case kOrderStatusCustomerSend:
            _billboard.text = @"待您接收预约";
            _billboard.textColor = kSetColor(0.1, 0.2, 0.99 , 1);
            _cancelOrder.hidden = NO;
            break;
        case kOrderStatusTeacherNotarize:
            _billboard.text = @"教师已确认预约";
             _billboard.textColor = kSetColor(0.1, 0.2, 0.99  , 1);
            _cancelOrder.hidden = NO;
            break;
        case kOrderStatusCustomerNotarize:
            _billboard.text = @"待您确认完成";
             _billboard.textColor = kSetColor(0.1, 0.2, 0.99  , 1);
            _cancelOrder.hidden = NO;
            break;
        case kOrderStatusTeacherRefuse:
            _billboard.text = @"教师拒绝了此订单";
            _billboard.textColor = kSetColor(0.98, 0.35, 0.35, 1);
            _deleteOrder.hidden = NO;
            _cancelOrder.hidden = YES;
            break;
        case kOrderStatusCustomerCancel:
            _billboard.text = @"您已取消此订单";
            _billboard.textColor = kSetColor(0.97, 0.35, 0.35, 1);
            _deleteOrder.hidden = NO;
            _cancelOrder.hidden = YES;
            break;
        case kOrderStatusTeacherNotarizeFinish:
            _billboard.text = @"已完成";
            _deleteOrder.hidden = YES;
            _cancelOrder.hidden = YES;
            _continueOrder.hidden = NO;
            _billboard.textColor = [UIColor brownColor];
            break;
        case kOrderStatusCustomerAndTeacherNotarizeFinish:
            _billboard.text = @"已完成";
            _deleteOrder.hidden = YES;
            _cancelOrder.hidden = YES;
            _continueOrder.hidden = NO;
            _billboard.textColor = [UIColor brownColor];
            break;
        default:
            break;
    }
   
    
    //教师姓名
    _teacherName.text = [NSString stringWithFormat:@"%@",order.customername];
    //授课地址
    _serverAddress.text = [NSString stringWithAddress:order.serviceaddress][kOtherAddress];
    //预约发起时间
    _orderSendDate.text = [NSString dateStringWithFormatterWithNSString:order.orderdate];
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += 10;
    frame.size.height -= 5;
    frame.origin.x += 5;
    frame.size.width -= 10;
    [super setFrame:frame];
}

@end
