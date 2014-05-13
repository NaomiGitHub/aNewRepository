//
//  MainViewController.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-14.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "MainBtn.h"
#define kBorderWidth 5
#define kScrollHeight (self.view.frame.size.height*0.35)
#define kMainBtnHeight 80
#define kMainBtnWidth  80
#define kMainBtnTag 1000
#define kImgCount  5
@interface MainViewController ()<UIScrollViewDelegate,UIAlertViewDelegate>
{
    UIScrollView *_scrollView;
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"首  页";
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=kSetColor(0.95, 0.95, 0.95, 1);
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2.5)];
    line1.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line1];

    [self headerScrollView];
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame)+1.5, self.view.frame.size.width, 2.5)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line2];
    [self addSubView];
}
-(void)addSubView
{
    UIView *view=[[UIView alloc]init];
    view.bounds=CGRectMake(0,0 , self.view.frame.size.width*2/3, self.view.frame.size.height-kScrollHeight-100);
    view.center=CGPointMake(self.view.frame.size.width*0.5, kScrollHeight+view.bounds.size.height*0.5);
    [self.view addSubview:view];
    
    //个人中心按钮
    MainBtn *userCenter=[MainBtn buttonWithType:UIButtonTypeCustom];
    userCenter.bounds=CGRectMake(0, 0, kMainBtnWidth, kMainBtnHeight);
    userCenter.center=CGPointMake(view.frame.size.width*0.5, view.frame.size.height/4);
    [userCenter setTitle:@"个人中心" forState:UIControlStateNormal];
    [userCenter setImage:[UIImage imageNamed:@"profile.png"] forState:UIControlStateNormal];
    [userCenter addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    userCenter.tag=kMainBtnTag+1;
    [view addSubview:userCenter];
    
    //水平分割线
    UIView *horLine=[[UIView alloc]initWithFrame:CGRectMake(kBorderWidth,view.frame.size.height*0.5, view.frame.size.width-kBorderWidth*2, 1)];
    horLine.backgroundColor=[UIColor lightGrayColor];
    [view addSubview:horLine];
    
    //订单
    MainBtn *order=[MainBtn buttonWithType:UIButtonTypeCustom];
    order.bounds=CGRectMake(0, 0, kMainBtnWidth, kMainBtnHeight);
    order.center=CGPointMake(view.frame.size.width/4, view.frame.size.height*3/4);
    [order setTitle:@"订单" forState:UIControlStateNormal];
    [order setImage:[UIImage imageNamed:@"pop.png"] forState:UIControlStateNormal];
    [order addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    order.tag=kMainBtnTag+2;
    [view addSubview:order];
    
    //垂直分割线
    UIView *verLine=[[UIView alloc]initWithFrame:CGRectMake(view.frame.size.width*0.5,CGRectGetMaxY(horLine.frame)+kBorderWidth, 1,view.frame.size.height*0.42)];
    verLine.backgroundColor=[UIColor lightGrayColor];
    [view addSubview:verLine];
    
    //跟多按钮
    MainBtn *more=[MainBtn buttonWithType:UIButtonTypeCustom];
    more.bounds=CGRectMake(0, 0, kMainBtnWidth, kMainBtnHeight);
    more.center=CGPointMake(view.frame.size.width*3/4-1, view.frame.size.height*3/4);
    [more setTitle:@"更多" forState:UIControlStateNormal];
    [more setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    [more addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    more.tag=kMainBtnTag+3;
    [view addSubview:more];
}
#pragma mark - headerScrollView
-(void)headerScrollView
{
    _scrollView=[[UIScrollView alloc]init];
    _scrollView.frame=CGRectMake(0, 3.5, self.view.frame.size.width, kScrollHeight);
    //滚动区域(内容)大小
    _scrollView.contentSize=CGSizeMake(kImgCount*self.view.frame.size.width, kScrollHeight);
    _scrollView.showsHorizontalScrollIndicator=NO;
    //按页滚动
    _scrollView.pagingEnabled=YES;
    //设置代理再代理中自动切换图片
    _scrollView.delegate=self;
    //用户不能手触摸滚动
    _scrollView.userInteractionEnabled=NO;
    [self.view addSubview:_scrollView];
    //添加图片
    CGSize viewSize=_scrollView.frame.size;
    for (int i=0; i<kImgCount; i++) {
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.frame=(CGRect){{i * viewSize.width,0},viewSize};
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"header_page_%d.jpg",i+1]];
        [_scrollView addSubview:imageView];

    }
    //定时器
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollImage:) userInfo:nil repeats:YES];
}
#pragma mark - 自动滚动图片
-(void)scrollImage:(NSTimer *)timer
{
    static int k=0;
    static int i=1;
    k++;
    CGPoint point=_scrollView.contentOffset;
    point.x= i * self.view.frame.size.width;
    
    [_scrollView setContentOffset:point animated:NO ];
    i++;
    if (i == kImgCount-1)
    {
        i = 0;
    }
    
}
#pragma mark - 按钮点击
-(void)btnClick:(MainBtn *)sender
{
    if (sender.tag==(kMainBtnTag+1)) {
        //BOOL statu=[[NSUserDefaults standardUserDefaults]boolForKey:kLoginStatu];
        
        if (![[NSUserDefaults standardUserDefaults]boolForKey:kLoginStatu]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"您还没有登陆" message:@"是否现在登陆?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alert show];
            return;
            
        }else
        {
            _btnClickBlock(sender.tag);
        }
    }else
    {
        _btnClickBlock(sender.tag);

    }
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self presentViewController:[LoginViewController new] animated:YES completion:nil];
    }
}
@end
