//
//  OrderDetailViewController.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-20.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetail.h"
#import "RequestTool.h"
#import "UILabel+Title.h"
//#import "TeacherDetailViewController.h"
#import "NSString+Date.h"
#import "NSString+Address.h"
#import "MapViewController.h"
#import "UIImage+Size.h"
#import "MoveView.h"
#import "PXAlertView.h"
#define labelWidth _cover.frame.size.width*0.5
#define labelHeight 25
@interface OrderDetailViewController (){
    UIButton *_customerName; //教师姓名
    UILabel *_subjectinfo; //辅导科目
    UILabel *_objectinfo;  //辅导对象
    UILabel *_timeperiod;  //辅导时间段
    UITextView *_memoView;        //备注
    UIButton *_serviceaddress; //服务地址
    UILabel *_orderdate; //订单生成时间
    UILabel *_orderStatus;//订单状态
    
    UILabel *_orderDetailTitle;
    UIImageView *_cover;
    UILabel *_memoTitle;
    //辅导地址的经纬度
    double latitude;//服务地址的经度
    double longitude;//服务地址的纬度
    //对订单操作的按钮
    UIButton *_operationOrderleft;
    UIButton *_operationOrderright;
    
    //操作类型
    OperationOrderType operationTypeLeft;
    OperationOrderType operationTypeRight;
    
    //继续预约面板内容
    UITextField *_continueServerAddress; //服务地址
    UITextView  *_continueServerMemo;
    PXAlertView *pxView;
    BOOL isMovePXView;
    UITextView *_cencelResultTestView;//取消预约原因
}

@end

@implementation OrderDetailViewController
- (id)init
{
    self = [super init];
    if (self) {
        //设置自身属性
        kNavigationBarFit(self);
        self.view.backgroundColor = kDefineColor;
        //添加控件
        [self addControl];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
}
#pragma mark 添加控件
- (void)addControl{
    
    _cover = [[UIImageView alloc]init];
    _cover.frame = CGRectMake(kDefineMargin, kDefineMargin, self.view.frame.size.width-kDefineMargin*2, 400);
    _cover.layer.cornerRadius = 5;
    _cover.layer.borderColor =kSetColor(0.17, 0.7, 1 , 1).CGColor;
    _cover.layer.borderWidth = 1.5;
    _cover.userInteractionEnabled = YES;
    [self.view addSubview:_cover];
    
    
    CGRect frame = _cover.frame;

    //标题
    _orderDetailTitle = [[UILabel alloc]init];
    _orderDetailTitle.frame = CGRectMake(0, kDefineMargin*2, frame.size.width , 20);
    _orderDetailTitle.font = [UIFont boldSystemFontOfSize: 16];
    _orderDetailTitle.textColor = [UIColor brownColor];
    _orderDetailTitle.textAlignment = NSTextAlignmentCenter;
    [_cover addSubview:_orderDetailTitle];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = kSetColor(0.17, 0.7, 1 , 1);
    line.frame = CGRectMake(kDefineMargin*2, CGRectGetMaxY(_orderDetailTitle.frame), frame.size.width-kDefineMargin*4, 1.5);
    [_cover addSubview:line];
    
    //姓名
    UILabel *nameTitle = [UILabel orderDeatilTitle:@"预约客户" frame:CGRectMake(0, CGRectGetMaxY(line.frame)+kDefineMargin, labelWidth , labelHeight)];
    [_cover addSubview:nameTitle];
    
    _customerName  = [UIButton buttonWithType:UIButtonTypeCustom];
    _customerName.frame = CGRectMake(CGRectGetMaxX(nameTitle.frame), CGRectGetMinY(nameTitle.frame), labelWidth, labelHeight);
    _customerName.layer.borderWidth = 1.5;
    _customerName.layer.borderColor = kSetColor(0.17, 0.7, 1 , 1).CGColor;
    _customerName.titleLabel.font = kTitleBoladNormalFont;
    [_customerName addTarget:self action:@selector(openTeacherDetail) forControlEvents:UIControlEventTouchUpInside];
    [_customerName setTitleColor:kSetColor(0.1, 0.65, 0.92 , 1) forState:UIControlStateNormal];
    [_cover addSubview:_customerName];
    
    //辅导科目
    UILabel *subjectTitle = [UILabel orderDeatilTitle:@"辅导科目" frame:CGRectMake(0, CGRectGetMaxY(_customerName.frame)+kDefineMargin, labelWidth , labelHeight)];
    [_cover addSubview:subjectTitle];
    
    //辅导对象
    UILabel *objectTitle = [UILabel orderDeatilTitle:@"辅导对象" frame:CGRectMake(0, CGRectGetMaxY(subjectTitle.frame)+kDefineMargin, labelWidth , labelHeight)];
    [_cover addSubview:objectTitle];
    
    //辅导时间段
    UILabel *timeperiodTitle = [UILabel orderDeatilTitle:@"辅导时间" frame:CGRectMake(0, CGRectGetMaxY(objectTitle.frame)+kDefineMargin, labelWidth , labelHeight)];
    [_cover addSubview:timeperiodTitle];
    
    //授课地址
    UILabel *serverAddress = [UILabel orderDeatilTitle:@"授课地址" frame:CGRectMake(0, CGRectGetMaxY(timeperiodTitle.frame)+kDefineMargin, labelWidth , labelHeight)];
    [_cover addSubview:serverAddress];
    //授课地址
    _serviceaddress  = [UIButton buttonWithType:UIButtonTypeCustom];
    _serviceaddress.frame = CGRectMake(labelWidth, CGRectGetMinY(serverAddress.frame), labelWidth, labelHeight);
    _serviceaddress.layer.borderWidth = 1.5;
    _serviceaddress.layer.borderColor = kSetColor(0.17, 0.7, 1 , 1).CGColor;
    _serviceaddress.titleLabel.font = kTitleBoladNormalFont;
    [_serviceaddress addTarget:self action:@selector(openMap) forControlEvents:UIControlEventTouchUpInside];
    [_serviceaddress setTitleColor:kSetColor(0.1, 0.65, 0.92 , 1) forState:UIControlStateNormal];
    [_cover addSubview:_serviceaddress];
    
    //订单状态
    UILabel *orderStatus = [UILabel orderDeatilTitle:@"订单状态" frame:CGRectMake(0, CGRectGetMaxY(serverAddress.frame)+kDefineMargin, labelWidth , labelHeight)];
    [_cover addSubview:orderStatus];
    
    //备注
    _memoTitle = [UILabel orderDeatilTitle:@"您的备注信息" frame:CGRectMake(0, CGRectGetMaxY(orderStatus.frame)+kDefineMargin, _cover.frame.size.width , labelHeight)];
    _memoTitle.backgroundColor = [UIColor clearColor];
    _memoTitle.textColor = [UIColor brownColor];
    [_cover addSubview:_memoTitle];
    
    //定义memo面板
    [self customerMemoView];
    
    //添加textView
    _memoView = [[UITextView alloc]init];
    _memoView.frame = CGRectMake(40, CGRectGetMaxY(_memoTitle.frame)+kDefineMargin*2, _cover.frame.size.width-82 , 50 );
    _memoView.backgroundColor = kDefineColor;
    _memoView.textColor = kSetColor(0.1, 0.63, 0.9 , 1);
    _memoView.userInteractionEnabled = NO;
    [_cover addSubview:_memoView];
    
    //对订单操作的but
    _operationOrderleft = [UIButton buttonWithType:UIButtonTypeCustom];
    _operationOrderleft.frame = CGRectMake(CGRectGetMinX(_cover.frame)+kDefineMargin, CGRectGetMaxY(_cover.frame)+kDefineMargin, _cover.frame.size.width/2-20, 25);
    [_operationOrderleft addTarget:self action:@selector(operationLiftAction) forControlEvents:UIControlEventTouchUpInside];
    _operationOrderleft.backgroundColor = kSetColor(0.17, 0.7, 1 , 1);
    _operationOrderleft.layer.cornerRadius = 3;
    _operationOrderleft.titleLabel.font = kTitleBoladNormalFont;
    [_operationOrderleft setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [self.view addSubview:_operationOrderleft];
    
    _operationOrderright = [UIButton buttonWithType:UIButtonTypeCustom];
    _operationOrderright.frame = CGRectMake(CGRectGetMaxX(_operationOrderleft.frame)+20, CGRectGetMaxY(_cover.frame)+kDefineMargin, _cover.frame.size.width/2-20, 25);
    _operationOrderright.backgroundColor = kSetColor(0.17, 0.7, 1 , 1);
    _operationOrderright.layer.cornerRadius = 3;
    _operationOrderright.titleLabel.font = kTitleBoladNormalFont;
    [_operationOrderright setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [_operationOrderright addTarget:self action:@selector(operationRightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_operationOrderright];
}

#pragma mark 自定义customerMemoView
- (void)customerMemoView{
    //添加左右侧背景
    UIImageView *leftView = [[UIImageView alloc]init];
    [_cover addSubview:leftView];
    
    UIImageView *rightView = [[UIImageView alloc]init];
    [_cover addSubview:rightView];
    
    //设置左右背景的大小
    CGFloat backGroudViewWidth =  _cover.frame.size.width-70;
    
    leftView.frame = CGRectMake(35,CGRectGetMaxY(_memoTitle.frame) ,backGroudViewWidth*0.5,80);
    rightView.frame = CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMaxY(_memoTitle.frame), backGroudViewWidth*0.5, 80);
    
    UIImage *leftimage = [UIImage imageNamed:@"icon_paopao_middle_left.png"];
    CGSize size = leftimage.size;
    leftimage = [leftimage stretchableImageWithLeftCapWidth:size.width*0.5 topCapHeight:size.height*0.5];
    
    UIImage *rightimage = [UIImage imageNamed:@"icon_paopao_middle_right.png"];
    CGSize rightsize = rightimage.size;
    rightimage = [rightimage stretchableImageWithLeftCapWidth:rightsize.width*0.5 topCapHeight:rightsize.height*0.5];
    leftView.image= leftimage;
    rightView.image= rightimage;
}
#pragma mark 打开教师详情
- (void)openTeacherDetail{
    
}
#pragma mark 打开地图
- (void)openMap{
    MapViewController *mapVC = [[MapViewController alloc]init];
    [mapVC showOrderWithAddress:_serviceaddress.currentTitle latitude:latitude longitude:longitude];
    [self.navigationController pushViewController:mapVC animated:YES];
}
- (void)setOrderDetail:(OrderDetail *)orderDetail{
    _orderDetail = orderDetail;
    NSString *orderdate = [NSString dateStringWithFormatterWithNSString:orderDetail.orderdate];
    _orderDetailTitle.text = [NSString stringWithFormat:@"客户在 %@ 发起的订单",orderdate];
    
    //姓名
    [_customerName setTitle:[NSString stringWithFormat:@"%@(客户)",orderDetail.customername] forState:UIControlStateNormal];
    
    //辅导科目
    _subjectinfo = [UILabel orderDeatilContent:orderDetail.subjectinfo frame:CGRectMake(labelWidth, CGRectGetMaxY(_customerName.frame)+kDefineMargin, labelWidth , labelHeight)];
    [_cover addSubview:_subjectinfo];
    
    //辅导对象
    _objectinfo = [UILabel orderDeatilContent:orderDetail.objectinfo frame:CGRectMake(labelWidth, CGRectGetMaxY(_subjectinfo.frame)+kDefineMargin, labelWidth , labelHeight)];
    [_cover addSubview:_objectinfo];
    
    //辅导时间
    _timeperiod = [UILabel orderDeatilContent:orderDetail.timeperiodStr frame:CGRectMake(labelWidth, CGRectGetMaxY(_objectinfo.frame)+kDefineMargin, labelWidth , labelHeight)];
    [_cover addSubview:_timeperiod];
    
    //辅导地址
    [_serviceaddress setTitle:[NSString stringWithAddress:orderDetail.serviceaddress][kOtherAddress] forState:UIControlStateNormal];
    
    //辅导时间
    _orderStatus = [UILabel orderDeatilContent:@"" frame:CGRectMake(labelWidth, CGRectGetMaxY(_serviceaddress.frame)+kDefineMargin, labelWidth , labelHeight)];
    [_cover addSubview:_orderStatus];

    
    //获取服务地址的经纬度
    latitude = orderDetail.latitude;
    longitude = orderDetail.longitude;
    
    //根据订单状态来设置一些属性
    [self judgeOrderStatus:orderDetail.orderStatus];
    
    //备注信息
    NSString *memo = orderDetail.memo;
    if([memo isEqualToString:@""]){
        _memoView.text = @"您没有对客户提出其他要求";
    }else{
        _memoView.text = memo;
    }
    
    
}

- (void)judgeOrderStatus:(OrderStatus)status{
    //设置按钮标题
    NSString *leftString = NULL;
    NSString *rightString = NULL;
    switch (status) {
        case kOrderStatusCustomerSend:
            _orderStatus.text = @"待您接收预约";
            operationTypeLeft = kNotarizeOrder;
            operationTypeRight = kCancel;    //取消订单
            leftString =  @"确认预约";
            rightString = @"取消订单";
            break;
        case kOrderStatusTeacherNotarize:
            _orderStatus.text = @"您已确认预约";
            operationTypeLeft = kNotarizeFinish; //确认完成
            operationTypeRight = kCancel;   //取消订单
            leftString =  @"确认完成";
            rightString = @"取消订单";
            break;
        case kOrderStatusCustomerNotarize:
            _orderStatus.text = @"待您确认完成";
            operationTypeLeft = kCannot; //不可操作
            operationTypeRight = kNotarizeFinish;
            leftString =  @"不支持操作";
            rightString = @"确认完成";
            break;
        case kOrderStatusTeacherRefuse:
            _orderStatus.text = @"您拒绝了此订单";
            operationTypeLeft = kContinue;   //继续预约
            operationTypeRight = kDelete;    //删除订单
            leftString =  @"继续预约";
            rightString = @"删除订单";
            break;
        case kOrderStatusCustomerCancel:
            _orderStatus.text = @"您已取消此订单";
            operationTypeLeft = kContinue;   //继续预约
            operationTypeRight = kDelete;    //删除订单
            leftString =  @"继续预约";
            rightString = @"删除订单";
            break;
        case kOrderStatusTeacherNotarizeFinish:
            _orderStatus.text = @"已完成";
            operationTypeLeft = kContinue;   //继续预约
            operationTypeRight = kDelete;    //删除订单
            leftString =  @"继续预约";
            rightString = @"删除订单";
            break;
        case kOrderStatusCustomerAndTeacherNotarizeFinish:
            _orderStatus.text = @"已完成";
            operationTypeLeft = kContinue;   //继续预约
            operationTypeRight = kDelete;    //删除订单
            leftString =  @"继续预约";
            rightString = @"删除订单";
            break;
        default:
            break;
    }
    [_operationOrderleft setTitle:leftString forState:UIControlStateNormal];
    [_operationOrderright setTitle:rightString forState:UIControlStateNormal];

}

#pragma mark 按钮的操作
- (void)operationLiftAction{
    //判断操作类型
    switch (operationTypeLeft) {
        case kNotarizeOrder:{
            
            [RequestTool requestConfirmOrder:self.orderDetail.orderid success:^(CodeType codeType, OrderStatus order_status) {
                NSLog(@"codetype=%d orderstatus=%d",codeType,order_status);
            } fail:^{
                
            }];
        }
            
            break;
        case kContinue:{

        }
            
            break;
        case kCannot:{
            
        }
            
            break;
            
        default:
            break;
    }
}
- (void)operationRightAction{
    //判断操作类型
    switch (operationTypeRight) {
        case kDelete:
            //删除订单
            [self deleteOrder];
        
            break;
        case kCancel:
            [self cancelOrder];
        
            break;
        case kCannot:
            break;
        case kNotarizeFinish:
        {
            //确认完成
            [PXAlertView showAlertWithTitle:@"提示" message:@"确认订单是不可以恢复的" cancelTitle:@"确认" otherTitle:@"返回" completion:^(BOOL cancelled) {
                if(cancelled){
                    [self finishOrder];
                }
            }];

        }
            break;
        default:
            break;
    }
}
#pragma mark 取消订单
- (void)cancelOrder{
    pxView = [PXAlertView showAlertWithTitle:@"取消操作" message:@"提示：取消后的订单将不能恢复" cancelTitle:@"确认" otherTitle:@"返回" contentView:[self cencelResultView] completion:^(BOOL cancelled) {
        pxView = nil;
        isMovePXView = NO;
        if(cancelled){
            [RequestTool requestCancelOrder:_orderDetail.orderid andReason:_cencelResultTestView.text success:^(CodeType codeType, OrderStatus order_status) {
                //隐藏加载框
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if(codeType == kCode_fail){
                    [PXAlertView showAlertWithTitle:@"取消订单失败,您可以从新取消此订单"];
                    return ;
                }
                //不可取消的情况
                if(order_status == kOrderStatusCustomerNotarize||
                   order_status == kOrderStatusTeacherNotarizeFinish||
                   order_status == kOrderStatusCustomerAndTeacherNotarizeFinish){
                    [PXAlertView showAlertWithTitle:@"取消订单失败，此订单已经被您确认或已经完成，您可刷新后在进行相应操作"];
                    return;
                }
                //重复取消
                if(order_status == -1){
                    [PXAlertView showAlertWithTitle:@"取消订单失败，此订单已经教师拒绝或取消，请刷新后在进行相应操作"];
                    return;
                }
                //可以取消
                [PXAlertView showAlertWithTitle:@"取消订单成功"];
            } fail:^{
                //隐藏加载框
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [PXAlertView showAlertWithTitle:@"取消订单失败,请检查您的网络连接"];
            }];
        }
    }];

}
#pragma mark 删除订单
- (void)deleteOrder{
    [PXAlertView showAlertWithTitle:@"提示" message:@"提示：删除后的订单将不能恢复" cancelTitle:@"删除" otherTitle:@"取消" completion:^(BOOL cancelled) {
        if(cancelled){
            [RequestTool requestDeleteOrderWithOrderid:_orderDetail.orderid accessed:^(CodeType codeType) {
                if(codeType == kCode_fail){
                    [PXAlertView showAlertWithTitle:@"取消删除失败,您可以从新删除此订单"];
                    return ;
                }
                //隐藏加载框
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [PXAlertView showAlertWithTitle:@"订单删除成功"];
            } fail:^{
                [PXAlertView showAlertWithTitle:@"请检查您的网络连接"];
            }];

        }
    }];

}
#pragma mark 确认完成
- (void)finishOrder{
    [self showHUD];
    [RequestTool requestCompleteOrder:self.orderDetail.orderid success:^(CodeType codeType, int order_status) {
        [self closeHUD];
        if(order_status == 4 || order_status == 6){
            [PXAlertView showAlertWithTitle:@"确认完成，您可以刷新订单后进行查看"];
            return ;
        }
        [PXAlertView showAlertWithTitle:@"你的订单状态可能发生了变动，请刷新后在进行此操作"];

    } fail:^{
        [PXAlertView showAlertWithTitle:@"请检查您的网络连接"];
    }];

}
- (void)showHUD{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)closeHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark 绘制取消原因面板
- (UIImageView *)cencelResultView{
    UIImageView *memoview = [[UIImageView alloc]init];
    memoview.frame = CGRectMake(0, 0, 200, 100);
    memoview.userInteractionEnabled = YES;
    
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"取消原因";
    title.frame = CGRectMake(memoview.frame.size.width/2-100/2, 0, 100, 15);
    title.textColor = [UIColor brownColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = kTitleBoladNormalFont;
    [memoview addSubview:title];
    
    _cencelResultTestView = [[UITextView alloc]init];
    _cencelResultTestView.frame = CGRectMake(kDefineMargin, CGRectGetMaxY(title.frame)+kDefineMargin*0.5, memoview.frame.size.width-kDefineMargin*2, memoview.frame.size.height-CGRectGetMaxY(title.frame));
    _cencelResultTestView.font = kTitleNormalFont;
    _cencelResultTestView.delegate = self;
    _cencelResultTestView.layer.cornerRadius = 5;
    _cencelResultTestView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _cencelResultTestView.backgroundColor = kDefineColor;
    _cencelResultTestView.textColor = kSetColor(0.17, 0.7, 1 , 1);
    [memoview addSubview:_cencelResultTestView];
    
    return memoview;
}

#pragma mark uitextview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if(isMovePXView)return;
    [MoveView moveTopOffset:70 inView:pxView duration:0.5];
    isMovePXView = YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(isMovePXView)return;
    [MoveView moveTopOffset:70 inView:pxView duration:0.5];
    isMovePXView = YES;
}

@end
