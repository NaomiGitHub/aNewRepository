//
//  OrderListViewController.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-16.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "OrderListViewController.h"
#import "Order.h"
#import "OrderDetail.h"
#import "RequestTool.h"
#import "UIButton+Button.h"
#import "OrderListCell.h"
#import "MoveView.h"
#import "NoOrderView.h"
#import "LoginViewController.h"
#import "OrderDetailViewController.h"
#import "PXAlertView.h"
#import "UserStatus.h"

#define kSwitchButWidth (self.view.frame.size.width / 3)
#define kSwitchButHeight 30

@interface OrderListViewController (){
    NSMutableArray *waitConfirm;//未完成的订单
    NSMutableArray *alreadyComplete;//已经完成订单
    NSMutableArray *alreadyCancel;//已经取消的订单
    NSMutableArray *tableViewSource;
    
    UIButton *_waitConfirmBut; //待完成按钮
    UIButton *_alreadyCompleteBut;//已经完成按钮
    UIButton *_alreadyCancelBut;//已经取消按钮
    UIButton *_currentSelectBut;
    UIImageView *_arrow;//剪头
    UILabel *_rollline;
    //三中表格
    UITableView *_waitTableView;
    UITableView *_completeTableView;
    UITableView *_cancelTableView;
    
    //当前表格
    UITableView *_currentTableView;
    
    UIScrollView *_scrollView;
    UILabel *_line;
    //对cell的操作类型
    CurrentOrderOperationType operationType;
    Order *operationOrder;
    
    //取消原因
    UITextView *_cencelResultTestView;
    PXAlertView *pxView;
    
    //继续预约服务地址
    UITextField *_continueServerAddress;
    //继续预约备注
    UITextView  *_continueServerMemo;
    
    //没有订单时显示的view
    NoOrderView *_nowaitOrderView;
    NoOrderView *_nocompleteOrderView;
    NoOrderView *_nocancelOrderView;
    //判断view是否上移
    BOOL isMovePXView;
}


@end

@implementation OrderListViewController

- (id)init{
    if(self = [super init]){
        kNavigationBarFit(self);
        self.view.backgroundColor = kDefineColor;
        //设置右侧刷新按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        button.frame=CGRectMake(0, 10, 20, 20);
        [button addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    waitConfirm = [NSMutableArray arrayWithCapacity:42];
    alreadyComplete = [NSMutableArray arrayWithCapacity:42];
    alreadyCancel = [NSMutableArray arrayWithCapacity:42];
    //添加控件
    [self addControl];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //控件复位
    self.navigationItem.title = @"未完成订单";
    _scrollView.contentOffset = CGPointMake(0, 0);
    _rollline.frame = CGRectMake(10, 0, kSwitchButWidth-20, 2.5);
    _arrow.frame = CGRectMake(kSwitchButWidth/2-10, CGRectGetMaxY(_line.frame)+2, 20, 11);
    
    //查找订单
    [self findOrders];
    //刷新第一个表单
    tableViewSource = waitConfirm;
    [_waitTableView reloadData];

}
#pragma mark 刷新数据
- (void)refreshData{
    [self findOrders];
    //刷新表格
    [_currentTableView reloadData];
}
#pragma mark 添加控件
- (void)addControl{
    //添加switch控件
    CGRect frame = self.view.frame;
    //默认title
    self.navigationItem.title = @"未完成订单";
    //为完成
    _waitConfirmBut=[UIButton orderSwitchWithTitle:@"未完成" frame:(CGRect){{0,0},{kSwitchButWidth,kSwitchButHeight}}];
    _waitConfirmBut.tag = kWaitConfirm;
    [_waitConfirmBut addTarget:self action:@selector(switchTableView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_waitConfirmBut];
    //已完成
    _alreadyCompleteBut=[UIButton orderSwitchWithTitle:@"已完成" frame:(CGRect){{kSwitchButWidth,0},{kSwitchButWidth,kSwitchButHeight}}];
    _alreadyCompleteBut.tag = kAlreadyComplete;
    [_alreadyCompleteBut addTarget:self action:@selector(switchTableView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_alreadyCompleteBut];
    //已取消
    _alreadyCancelBut=[UIButton orderSwitchWithTitle:@"已取消" frame:(CGRect){{kSwitchButWidth*2,0},{kSwitchButWidth,kSwitchButHeight}}];
    _alreadyCancelBut.tag = kAlreadyCancel;
    [_alreadyCancelBut addTarget:self action:@selector(switchTableView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_alreadyCancelBut];
    
    //分割线
    _line = [[UILabel alloc]init];
    _line.frame = CGRectMake(0, CGRectGetMaxY(_waitConfirmBut.frame), frame.size.width, 2.5);
    _line.backgroundColor =  kSetColor(0.2, 0.3, 0.4 , 1);
    [self.view addSubview:_line];
    
    //滚动线
    _rollline = [[UILabel alloc]init];
    _rollline.layer.cornerRadius = 5;
    _rollline.frame = CGRectMake(10, 0, kSwitchButWidth-20, 2.5);
    _rollline.backgroundColor =  kSetColor(0.3, 0.3, 0.3, 1);
    [_line addSubview:_rollline];
    
    //角标
    _arrow = [[UIImageView alloc]init];
    _arrow.frame = CGRectMake(kSwitchButWidth/2-10, CGRectGetMaxY(_line.frame)+2, 20, 11);
    _arrow.image = [UIImage imageNamed:@"orderArrows"];
    [self.view addSubview:_arrow];
    
    //添加滚动view
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, CGRectGetMaxY(_arrow.frame), frame.size.width, frame.size.height-CGRectGetMaxY(_arrow.frame)-49);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.
    _scrollView.contentSize = CGSizeMake(frame.size.width*3, 0);
    [self.view addSubview:_scrollView];
    
    [self addContentViewInView:_scrollView];
}


#pragma mark 在scrollview内添加view
- (void)addContentViewInView:(UIScrollView *)scrollView{
    CGFloat tableViewWidth = self.view.frame.size.width;
    CGFloat tableViewHeight = self.view.frame.size.height-CGRectGetMaxY(_arrow.frame)-kDefineMargin*3;
    //添加未完成表格
    _waitTableView = [[UITableView alloc]init];
    _waitTableView.contentInset = UIEdgeInsetsMake(10, 0, 120, 0);
    _waitTableView.delegate = self;
    _waitTableView.layer.cornerRadius = 5;
    _waitTableView.backgroundColor = kDefineColor;
    _waitTableView.dataSource = self;
    _waitTableView.showsVerticalScrollIndicator = NO;
    _waitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _waitTableView.frame = CGRectMake(0, 0, tableViewWidth, tableViewHeight);
    
    _completeTableView = [[UITableView alloc]init];
    _completeTableView.layer.cornerRadius = 5;
    _completeTableView.backgroundColor = kDefineColor;
    _completeTableView.delegate = self;
    _completeTableView.dataSource = self;
    _completeTableView.showsVerticalScrollIndicator = NO;
    _completeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _completeTableView.frame = CGRectMake(tableViewWidth , 0, tableViewWidth, tableViewHeight);
    
    _cancelTableView = [[UITableView alloc]init];
    _cancelTableView.layer.cornerRadius = 5;
    _cancelTableView.backgroundColor = kDefineColor;
    _cancelTableView.showsVerticalScrollIndicator = NO;
    _cancelTableView.delegate = self;
    _cancelTableView.dataSource = self;
    _cancelTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _cancelTableView.frame = CGRectMake(tableViewWidth*2, 0, tableViewWidth, tableViewHeight);
    
    
    //添加没有订单时的遮盖view
    _nowaitOrderView = [[NoOrderView alloc]initWithFrame:CGRectMake(0, 0, tableViewWidth, tableViewHeight)];
    _nocompleteOrderView = [[NoOrderView alloc]initWithFrame:CGRectMake(0, 0, tableViewWidth, tableViewHeight)];
    _nocancelOrderView = [[NoOrderView alloc]initWithFrame:CGRectMake(0, 0, tableViewWidth, tableViewHeight)];
    
    

    
    [scrollView addSubview:_waitTableView];
    [scrollView addSubview:_completeTableView];
    [scrollView addSubview:_cancelTableView];
    
    [_waitTableView addSubview:_nowaitOrderView];
    [_completeTableView addSubview:_nocompleteOrderView];
    [_cancelTableView addSubview:_nocancelOrderView];
    
}
#pragma mark 获取订单
- (void)findOrders{
    
    //判断是否登陆
    if(![UserStatus isLogin]){
        _nowaitOrderView.hint = @"您还没有登陆";
        _nocompleteOrderView.hint = @"您还没有登陆";
        _nocancelOrderView.hint = @"您还没有登陆";
        [PXAlertView showAlertWithTitle:@"订单查询失败" message:@"您可以在登陆后在进行订单查询" cancelTitle:@"登陆" otherTitle:@"返回" completion:^(BOOL cancelled) {
            if(cancelled){
                //跳转登陆界面
                LoginViewController *login = [[LoginViewController alloc]init];
                //login.popViewController = self;
                [self presentViewController:login animated:YES completion:nil];
            }
        }];
        return;
    }
    _nowaitOrderView.hint = @"没有客户预约，您可以再客户预约后查询";
    _nocompleteOrderView.hint = @"你没有已完成的订单";
    _nocancelOrderView.hint = @"没有任何订单被取消";
    //发送请求获取订单列表
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在努力查找...";
    [RequestTool requesetOrderList:@"26" andOrderStatus:kOrderStatusAll andPage:1 success:^(CodeType codeType, NSArray *lists) {
        //解析不同的订单
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(codeType == kCode_fail){
            [PXAlertView showAlertWithTitle:@"查找失败" message:@"未知错误，您可以按刷新建重新获取"];
            return;
        }
        if(lists.count == 0){
            [PXAlertView showAlertWithTitle:@"没有您的订单" message:@"没有家长预约您"];
            return;
        }
        //移除之前的数据源
        [waitConfirm removeAllObjects];
        [alreadyCancel removeAllObjects];
        [alreadyComplete removeAllObjects];
        _nowaitOrderView.hidden = YES;
        _nocompleteOrderView.hidden = YES;
        _nocancelOrderView.hidden = YES;
        
        //对订单进行分类
        for(Order *order in lists){
            //教师确认订单，或者客户确认完成订单都属于未完成订单
            if(order.orderStatus == kOrderStatusCustomerSend || //客户发出预约
               order.orderStatus == kOrderStatusCustomerNotarize|| //客户确定完成
               order.orderStatus == kOrderStatusTeacherNotarize){   //教师确认预约
                [waitConfirm addObject:order];
            }
            //双方确认已经完成的订单
            if(order.orderStatus == kOrderStatusTeacherNotarizeFinish||
               order.orderStatus == kOrderStatusCustomerAndTeacherNotarizeFinish){
                [alreadyComplete addObject:order];
            }
            //已经取消的订单
            if(order.orderStatus == kOrderStatusTeacherRefuse ||
               order.orderStatus == kOrderStatusCustomerCancel){
                [alreadyCancel addObject:order];
            }
        }
        //判断哪个数组没有数据
        if(waitConfirm.count==0){
            _nowaitOrderView.hidden = NO;
        }
        if(alreadyComplete.count == 0){
            _nocompleteOrderView.hidden = NO;
        }
        if(alreadyCancel.count == 0){
            _nocancelOrderView.hidden = NO;
        }


    } fail:^{
        [PXAlertView showAlertWithTitle:@"查找失败" message:@"请检查您的网络连接"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
    
}
#pragma mark 切换表格
- (void)switchTableView:(UIButton *)button{
    [self transformAnimationWithTag:button.tag];
}

#pragma mark scrollView切换动画
- (void)transformAnimationWithTag:(int)tag{
    CGFloat lineX = 0 ;
    CGFloat arrowX = 0;
    CGFloat contentOffsetX = 0;
    switch (tag) {
        case kWaitConfirm:{
            //切换title
            self.navigationItem.title=@"未完成订单";
            //该表line的位置
            lineX = 10;
            arrowX = kSwitchButWidth/2-10;
            //切换数据源
            tableViewSource = waitConfirm;
            _currentTableView = _waitTableView;
            [_waitTableView reloadData];
            //设置偏移
            contentOffsetX = 0;
        }
            break;
        case kAlreadyComplete:{
            //切换title
            self.navigationItem.title=@"已完成订单";
            //该表line的位置
            lineX = 10+kSwitchButWidth;
            arrowX = kSwitchButWidth/2-10+kSwitchButWidth;
            //切换数据源
            tableViewSource = alreadyComplete;
            _currentTableView =  _completeTableView;
            [_completeTableView reloadData];
            //设置偏移
            contentOffsetX = self.view.frame.size.width;
        }
            break;
        case kAlreadyCancel:{
            //切换title
            self.navigationItem.title=@"已取消订单";
            //该表line的位置
            lineX = 10+kSwitchButWidth*2;
            arrowX = kSwitchButWidth/2-10+kSwitchButWidth*2;
            //切换数据源
            tableViewSource = alreadyCancel;
            _currentTableView = _cancelTableView;
            [_cancelTableView reloadData];
            contentOffsetX = self.view.frame.size.width*2;
        }
            break;
            
        default:
            break;
    }
    //切换动画
    [UIView animateWithDuration:0.2 animations:^{
        _rollline.frame = CGRectMake(lineX, 0, kSwitchButWidth-20, 2.5);
        CGRect arrowFrame = _arrow.frame;
        arrowFrame.origin.x = arrowX;
        _arrow.frame = arrowFrame;
        //切换偏移
        _scrollView.contentOffset = CGPointMake(contentOffsetX, 0);
    }];

}

#pragma mark scrollView的代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView != _scrollView) {
        return;
    }
    int  x = scrollView.contentOffset.x/self.view.frame.size.width;
    switch (x) {
        case 0:
            [self transformAnimationWithTag:kWaitConfirm];
            break;
        case 1:
            [self transformAnimationWithTag:kAlreadyComplete];
            break;
        case 2:
            [self transformAnimationWithTag:kAlreadyCancel];
            break;
            
        default:
            break;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return tableViewSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[OrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.order = tableViewSource[indexPath.row];
    //监听cell的回掉
    //删除订单操作
    cell.deleteOrderOperation = ^(Order *order){
        [PXAlertView showAlertWithTitle:@"提示" message:@"提示：删除后的订单将不能恢复" cancelTitle:@"删除" otherTitle:@"取消" completion:^(BOOL cancelled) {
            if(cancelled){
                [self operationCellWithOrder:order operationType:kDeleteOrder tableView:tableView IndexPath:indexPath];
            }
        }];
    };
    //取消订单操作
    cell.cancelOrderOperation = ^(Order *order){
        pxView = [PXAlertView showAlertWithTitle:@"取消操作" message:@"提示：取消后的订单将不能恢复" cancelTitle:@"确认" otherTitle:@"返回" contentView:[self cencelResultView] completion:^(BOOL cancelled) {
            [pxView removeFromSuperview];
            pxView = nil;
            isMovePXView = NO;
            if(cancelled){
                [self operationCellWithOrder:order operationType:kCancelOrder tableView:tableView IndexPath:indexPath];
            }
        }];
       
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc]init];
    Order *order = tableViewSource[indexPath.row];
    [RequestTool requestOrderDetail:order.orderid success:^(CodeType codeType, OrderDetail *orderDetail) {
        if(codeType == kCode_fail || !orderDetail){
            [PXAlertView showAlertWithTitle:@"查询失败" message:@"服务器错误，您可以重新查询"];
            return ;
        }
        orderDetailVC.orderDetail = orderDetail;
        [self.navigationController pushViewController:orderDetailVC animated:YES];

    } fail:^{
        [PXAlertView showAlertWithTitle:@"查询失败" message:@"请检查您的网络连接"];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}

#pragma mark 绘制继续预约面板
- (UIImageView *)continueOrderView{
    UIImageView *memoview = [[UIImageView alloc]init];
    memoview.frame = CGRectMake(0, 0, 250, 100);
    memoview.userInteractionEnabled = YES;
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"服务地址";
    title.textColor = [UIColor brownColor];
    title.font = kTitleBoladNormalFont;
    title.textColor = [UIColor whiteColor];
    title.frame = CGRectMake(kDefineMargin, kDefineMargin, 60, 20);
    [memoview addSubview:title];
    
    _continueServerAddress = [[UITextField alloc]init];
    _continueServerAddress.frame = CGRectMake(CGRectGetMaxX(title.frame), CGRectGetMinY(title.frame), 170, 20);
    _continueServerAddress.layer.cornerRadius = 5;
    _continueServerAddress.font = kTitleNormalFont;
    _continueServerAddress.textColor = kSetColor(0.1, 0.4, 1 , 1);
    _continueServerAddress.backgroundColor = kDefineColor;
    _continueServerAddress.layer.borderWidth = 1;
    _continueServerAddress.delegate = self;
    _continueServerAddress.placeholder = @"服务地如果不变可不填此项";
    _continueServerAddress.layer.borderColor = [UIColor whiteColor].CGColor;
    [memoview addSubview:_continueServerAddress];
    
    _continueServerMemo = [[UITextView alloc]init];
    _continueServerMemo.frame = CGRectMake(10, CGRectGetMaxY(_continueServerAddress.frame)+kDefineMargin, 230, 70);
    _continueServerMemo.delegate = self;
    _continueServerMemo.text = @"对此客户的要求写在这里";
    _continueServerMemo.font = kTitleNormalFont;
    _continueServerMemo.textColor = kSetColor(0.1, 0.4, 1 , 1);
    _continueServerMemo.backgroundColor = kDefineColor;
    _continueServerMemo.layer.cornerRadius = 5;
    
    [memoview addSubview:_continueServerMemo];
    return memoview;
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
    _cencelResultTestView.textColor = kSetColor(0.1, 0.4, 1 , 1);
    [memoview addSubview:_cencelResultTestView];
    
    return memoview;
}

#pragma mark 对cell的操作
- (void)operationCellWithOrder:(Order *)order operationType:(CurrentOrderOperationType)type tableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //删除订单
    if(type == kDeleteOrder){
        hud.labelText = @"正在删除订单...";
        
        [RequestTool  requestDeleteOrderWithOrderid:order.orderid accessed:^(CodeType codeType) {
            if(codeType == kCode_fail){
                [PXAlertView showAlertWithTitle:@"取消删除失败,您可以从新删除此订单"];
                return ;
            }
            //删除数据源
            [tableViewSource removeObjectAtIndex:indexPath.row];
            //删除cell
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //刷新表格
            [tableView reloadData];
            //隐藏加载框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [PXAlertView showAlertWithTitle:@"订单删除成功"];
        } fail:^{
            [PXAlertView showAlertWithTitle:@"请检查您的网络连接"];
        }];
     }
    //修改订单
    if(type == kCancelOrder){
        hud.labelText = @"正在取消订单...";
        [RequestTool requestCancelOrder:order.orderid andReason:_cencelResultTestView.text success:^(CodeType codeType, OrderStatus order_status) {
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
            //删除数据源
            [tableViewSource removeObjectAtIndex:indexPath.row];
            //删除cell
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //刷新表格
            [tableView reloadData];

        } fail:^{
            //隐藏加载框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [PXAlertView showAlertWithTitle:@"取消订单失败,请检查您的网络连接"];

        }];
    }
}

#pragma mark 想服务器发送请求获取订单详情
- (OrderDetail *)getOrderDetailWithOrderId:(int)orderid isAccess:(BOOL *)access{
    __block OrderDetail *neworderDetail = nil;
    [RequestTool requestOrderDetail:orderid success:^(CodeType codeType, OrderDetail *orderDetail) {
        if(codeType == kCode_fail || !orderDetail){
            *access = NO;
            return ;
        }
        *access = YES;
        neworderDetail = orderDetail;
    } fail:^{
        *access = NO;
    }];
    return  neworderDetail;
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
