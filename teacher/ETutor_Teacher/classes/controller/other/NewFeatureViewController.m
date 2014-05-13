//
//  NewFeatureViewController.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-2-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#define kImageCount 3
#define kBottomScale 0.75
@interface NewFeatureViewController ()<UIScrollViewDelegate>
{
    UIScrollView  *_scrollView;
    UIPageControl *_pageControl;
    UIButton *_login;
    UIButton *_register;
    UIButton *_share;
}
@end

@implementation NewFeatureViewController
#pragma mark - 自定义控制器的view
-(void)loadView
{
    [super loadView];
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.frame=[UIScreen mainScreen].bounds;
    imageView.image=[UIImage fullScreenImageWithName:@"new_feature_background.png"];
    imageView.userInteractionEnabled=YES;
    self.view=imageView;
}	
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addScrollView];
    [self addImageView];
    //[self addBottomView];
}
#pragma mark -1,加载scrollView

-(void)addScrollView
{
    CGSize viewSize=self.view.bounds.size;
 
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    //不显示水平滚动条
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.bounces=NO;
    //按页滚动
    scrollView.pagingEnabled=YES;
    //滚动区域大小
    scrollView.contentSize=CGSizeMake(self.pageCount*viewSize.width, 0);
    _scrollView=scrollView;
    [self.view addSubview:scrollView];
}
#pragma mark - 2,加载UIImageView
-(void)addImageView
{
    for (int i=0; i<self.pageCount; i++) {
        CGSize viewSize=self.view.frame.size;
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.frame=(CGRect){{i * viewSize.width,0},viewSize};
        NSString *name=[NSString stringWithFormat:@"new_feature_%d.png",i+1];
        imageView.image=[UIImage fullScreenImageWithName:name];
        [_scrollView addSubview:imageView];
        if (i==self.pageCount-1) {
            imageView.userInteractionEnabled=YES;
            imageView.image=[UIImage imageNamed:@"home_bg.png"];
            if ([AllAccManager sharedAllAccManager].teaAcc&&[[NSUserDefaults standardUserDefaults]boolForKey:kLoginStatu]) {
                [self addEndPageBtnForLogined:imageView];
            }else
                [self addEndPageBtn:imageView];
        }
    }
}
#pragma mark - 添加最后一页按钮(有登录按钮)
-(void)addEndPageBtnForLogined:(UIImageView *)imgV
{
    CGSize viewSize=self.view.frame.size;

    UIButton *start=[UIButton buttonWithType:UIButtonTypeCustom];
    //设置普通状态下背景图片
    //UIImage *startNormal=[UIImage imageNamed:@""];
    
    //设置高亮状态下背景图片
    //UIImage *starthighlight=[UIImage imageNamed:@""];
    //[start setBackgroundImage:startNormal forState:UIControlStateNormal];
    //[start setBackgroundImage:starthighlight forState:UIControlStateHighlighted];
    
    [start setTitle:@"开起家教之路" forState:UIControlStateNormal];
    [start setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置位置和大小
    start.center=CGPointMake(viewSize.width*0.5, viewSize.height*0.85);
    start.bounds=CGRectMake(0, 0, 150, 40);
    
    //监听开始按钮
    [start addTarget:self action:@selector(startWeibo) forControlEvents:UIControlEventTouchUpInside];
    [imgV addSubview:start];
    

}
#pragma mark 开始按钮事件
-(void)startWeibo
{
    if (_start) {
        _start();
    }
}


#pragma mark - 5，添加最后一页跳转按钮(没有登录)
-(void)addEndPageBtn:(UIImageView *)imageView
{
    CGSize viewSize=self.view.bounds.size;
    _login=[UIButton buttonWithType:UIButtonTypeCustom];
    _login.center=CGPointMake(viewSize.width*0.25, viewSize.height*0.85);
    _login.bounds=CGRectMake(0, 0, 80, 80);
    [_login setBackgroundImage:[UIImage imageNamed:@"home_login@2x.png"] forState:UIControlStateNormal];
    [_login setBackgroundImage:[UIImage imageNamed:@"home_login_highlighted@2x.png"] forState:UIControlStateHighlighted];
    [_login addTarget:self action:@selector(startJump:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:_login];
    
    _register=[UIButton buttonWithType:UIButtonTypeCustom];
    _register.center=CGPointMake(viewSize.width*0.75, viewSize.height*0.85);
    _register.bounds=CGRectMake(0, 0, 80, 80);
    [_register setBackgroundImage:[UIImage imageNamed:@"home_register@2x.png"] forState:UIControlStateNormal];
    [_register setBackgroundImage:[UIImage imageNamed:@"home_register_highlighted@2x.png"] forState:UIControlStateHighlighted];
    [_register addTarget:self action:@selector(startJump:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:_register];
    
    
}
#pragma mark - 按钮点击事件
-(void)startJump:(UIButton *)sender
{
    if (sender==_login) {
        LoginViewController *logi=[LoginViewController new];
        [self presentViewController:logi animated:YES completion:nil];
    }else if(sender==_register)
    {
        RegisterViewController *reg=[RegisterViewController new];
        [self presentViewController:reg animated:YES completion:nil];
    }}
@end
