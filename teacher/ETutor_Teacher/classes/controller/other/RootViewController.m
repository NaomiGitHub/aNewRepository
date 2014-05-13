//
//  RootViewController.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-14.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "RootViewController.h"
#import "MainViewController.h"
#import "UserViewController.h"
#import "MoreViewController.h"
#import "OrderViewController.h"
#import "OrderListViewController.h"
#import "NavViewController.h"
#define kMainBtnTag 1000
@interface RootViewController ()<UINavigationControllerDelegate>
{
    MainViewController *_main;
    NavViewController *_currentController;
    UIViewController *_currentVC;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addSubVC];
    [self addMainView];
}
-(void)addMainView
{
    _main=self.childViewControllers[0];
    _main.view.frame=self.view.frame;//CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_main.view];
    
    

}
-(void)addSubVC
{
    _main=[MainViewController new];
    __unsafe_unretained RootViewController *root=self;
    _main.btnClickBlock=^(int tag)
    {
        [root clickBtnToControllerAtIndex:tag];
    };
    [self addChildViewController:_main];
    
    UserViewController *user=[UserViewController new];
    [self addChildViewController:user];
    
    OrderListViewController *order=[OrderListViewController new];
    [self addChildViewController:order];
    
    MoreViewController *more=[MoreViewController new];
    [self addChildViewController:more];

}
-(void)addChildViewController:(UIViewController *)childController
{
    NavViewController *nav=[[NavViewController alloc]initWithRootViewController:childController];
    nav.delegate=self;
    [super addChildViewController:nav];
}

-(void)clickBtnToControllerAtIndex:(int)tag
{
    //先从父控制器自带控制器数组中取出子控制器
    NavViewController *controller=self.childViewControllers[tag-kMainBtnTag];
    controller.view.frame=CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:controller.view];
    CGRect mainFrame=_main.view.frame;
    CGRect othFrame=controller.view.frame;
    mainFrame.origin.x-=320;
    othFrame.origin.x-=320;
    [UIView animateWithDuration:0.5 animations:^{
        _main.view.frame=mainFrame;
        controller.view.frame=othFrame;
    }];
    _currentController=controller;
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NavViewController *root=navigationController.viewControllers[0];
    
    if (![viewController isKindOfClass:[MainViewController class]]) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.bounds=CGRectMake(0, 0, 30, 25);
        [btn setImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backitem=[[UIBarButtonItem alloc]initWithCustomView:btn];
        root.navigationItem.leftBarButtonItem=backitem;
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    if (viewController!=root) {
        _currentVC=viewController;
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.bounds=CGRectMake(0, 0, 30, 25);
        [btn setImage:[UIImage imageNamed:@"backward.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backitem=[[UIBarButtonItem alloc]initWithCustomView:btn];
        viewController.navigationItem.leftBarButtonItem=backitem;
        [btn addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    }
   
}
-(void)popVC
{
    [_currentVC.navigationController popViewControllerAnimated:YES];
}
-(void)back
{
    CGRect mainFrame=_main.view.frame;
    CGRect othFrame=_currentController.view.frame;
    mainFrame.origin.x+=320;
    othFrame.origin.x+=320;
    [UIView animateWithDuration:0.4 animations:^{
        _main.view.frame=mainFrame;
        _currentController.view.frame=othFrame;
    } completion:^(BOOL finished) {
            [_currentController.view removeFromSuperview];
    }];
}
@end
