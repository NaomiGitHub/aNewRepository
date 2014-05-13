//
//  LoginViewController.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-2-28.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "RootViewController.h"
#import "RequestTool.h"
#import "TeacherAccount.h"
#import "AllAccManager.h"
#import "TeacherUser.h"
#import "TeacherManager.h"
#define kIconY 100
#define kIconH 100
typedef enum {
    kAlertSuccess =0,
    kAlertTextNone = 1,
    kAlertUserNameEqual = 2,
    kAlertServerErr =3,
    kAlertWebErr
    
    
}AlertId;

@interface LoginViewController ()<UITextFieldDelegate>
{
    BOOL _isEditing;
    UITextField *_account;
    UITextField *_pw;
    
}
@end

@implementation LoginViewController
- (id)init
{
    self = [super init];
    if (self) {
        self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    }
    return self;
}
-(void)loadView
{
    [super loadView];
    UIImageView *imgv=[[UIImageView alloc]init];
    imgv.image=[UIImage imageNamed:@"background@2x.png"];
    imgv.frame=self.view.frame;
    imgv.userInteractionEnabled=YES;
    self.view=imgv;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    IconBtn *backBtn=[IconBtn buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(5, 20, kBtnWidth, kBtnHeight);
    [backBtn setImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    UIImageView *title=[[UIImageView alloc]init];
    title.bounds=CGRectMake(0, 0, 50, 20);
    title.center=CGPointMake(self.view.frame.size.width*0.5, 37);
    title.image=[UIImage imageNamed:@"login_bar_title@2x.png"];
    [self.view addSubview:title];
    
    UIImageView *iconView=[[UIImageView alloc]init];
    iconView.bounds=CGRectMake(0, 0, 100, 100);
    iconView.center=CGPointMake(self.view.frame.size.width*0.5, kIconY+kIconH*0.5);
    iconView.image=[UIImage imageNamed:@"LRicon@2x.png"];
    [self.view addSubview:iconView];
    [self addSubViewWithLbl];
    
    if ([AllAccManager sharedAllAccManager].teaAcc) {
        _account.text=[AllAccManager sharedAllAccManager].teaAcc.userName;
        _pw.text=[AllAccManager sharedAllAccManager].teaAcc.password;
    }
}
#pragma mark - 添加控件
-(void)addSubViewWithLbl
{
    //放置两个textField的view
    UIImageView *view=[[UIImageView alloc]initWithFrame:CGRectMake(10, kIconH+kIconY+15, self.view.frame.size.width-20, 100)];
    //view.image=[UIImage imageNamed:@"textField_bg@2x.png"];
    view.layer.borderWidth=1;
    view.layer.borderColor=kSetColor(0.55, 0.55, 0.55, 0.5).CGColor;
    view.layer.cornerRadius=3;
    view.userInteractionEnabled=YES;
    [self.view addSubview:view];

    //账号textField
    _account=[[UITextField alloc]init];
    _account.placeholder=@"账号:";
    _account.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _account.frame=CGRectMake(10, 0, view.frame.size.width-20, view.frame.size.height*0.5-0.5);
    _account.delegate=self;
    [view addSubview:_account];
//    //line
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, view.bounds.size.height*0.5, view.bounds.size.width-10, 1)];
    line.backgroundColor=kSetColor(0.55, 0.55, 0.55, 0.5);
    [view addSubview:line];
    //密码textField
    _pw=[[UITextField alloc]init];
    _pw.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _pw.placeholder=@"密码:";
    _pw.secureTextEntry=YES;
    _pw.delegate=self;
    _pw.frame=CGRectMake(10, CGRectGetMaxY(_account.frame)-0.5, view.frame.size.width-20, view.frame.size.height*0.5);
    [view addSubview:_pw];
    
    //登陆按钮
    UIButton *login=[UIButton buttonWithType:UIButtonTypeCustom];
    login.frame=CGRectMake(view.frame.origin.x, CGRectGetMaxY(view.frame)+15, view.frame.size.width, 50);
    [login setBackgroundImage:[UIImage imageNamed:@"login_btn@2x.png"] forState:UIControlStateNormal];
    [login setBackgroundImage:[UIImage imageNamed:@"login_btn_highlighted@2x.png"] forState:UIControlStateHighlighted];
    
    [login setTitle:@"登    陆" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [login addTarget:self action:@selector(loginAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
    
    //注册按钮
    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame=CGRectMake(self.view.frame.size.width-kBtnWidth-30, CGRectGetMaxY(login.frame)+10, 60, kBtnHeight);
    [registerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    registerBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [registerBtn addTarget:self action:@selector(registerAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    //微博账号登陆
    IconBtn *weibo=[IconBtn buttonWithType:UIButtonTypeCustom];
    
    [weibo setBackgroundImage:[UIImage imageNamed:@"weibologin@2x.png"] forState:UIControlStateNormal];
    [weibo setBackgroundImage:[UIImage imageNamed:@"weibologin_highlighted"] forState:UIControlStateHighlighted];
    weibo.frame=CGRectMake(10, CGRectGetMaxY(login.frame)+60, 140, 40);
    [self.view addSubview:weibo];
    weibo.hidden = YES;
    //qq账号登陆
    IconBtn *qq=[IconBtn buttonWithType:UIButtonTypeCustom];
    qq.frame=CGRectMake(CGRectGetMaxX(weibo.frame)+20, CGRectGetMaxY(login.frame)+60, 140, 40);
    [qq setBackgroundImage:[UIImage imageNamed:@"qqlogin@2x.png"] forState:UIControlStateNormal];
    [qq setBackgroundImage:[UIImage imageNamed:@"qqlogin_highlighted@2x.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:qq];
    qq.hidden = YES;
    
}
#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame=self.view.frame;
    frame.origin.y-=100;
    if (!_isEditing) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=frame;
        }];
    }
    _isEditing=YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //_isEditing=NO;
    CGRect frame=self.view.frame;
    frame.origin.y=0;
    if (!_isEditing) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=frame;
        }];
    }
    
}
#pragma mark - 返回按钮事件
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 注册按钮事件
-(void)registerAccount
{
    UIViewController *vc=[RegisterViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 登陆按钮事件
-(void)loginAccount
{
    _isEditing=NO;
    [self.view endEditing:YES];
    if ([_account.text isEqualToString:@""]||[_pw.text isEqualToString:@""]) {
        [self showAlert:@"登录失败！" msg:@"账号或密码有空" btnTitle:@[@"确定"] Id:kAlertTextNone];
    }else
    {
        [self showHUD];
        [RequestTool requesetLogin:_account.text andPassword:_pw.text success:^(CodeType codeType, TeacherUser *teacherUser) {
            if (teacherUser.teacherid) {
            [self hideHUD];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kLoginStatu];
            [[NSUserDefaults standardUserDefaults]synchronize];
            TeacherAccount *account=[[TeacherAccount alloc]init];
            account.userName=_account.text;
            account.password=_pw.text;
            //归档账号和密码
            [[AllAccManager sharedAllAccManager]addTeaAcc:account];
            //归档老师对象
            [[TeacherManager sharedTeacherManager]archiveTeacher:teacherUser];
            
            [[NSUserDefaults standardUserDefaults]setObject:teacherUser.teacherid forKey:kTeacherId];
            [[NSUserDefaults standardUserDefaults]synchronize];

            [UIApplication sharedApplication].keyWindow.rootViewController= [RootViewController new];
                
                
            } else if(!teacherUser.teacherid) {
                [self hideHUD];
                [self showAlert:@"登录失败！" msg:@"账号或密码错误" btnTitle:@[@"确定"] Id:kAlertServerErr];
            }

        } fail:^{
            [self showAlert:@"错误信息!" msg:@"亲! 请检查您的网络哦" btnTitle:@[@"确定"] Id:kAlertWebErr];
            [self hideHUD];
        }];
        
    }
    
}
-(void)showHUD
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"正在登陆...";
    hud.backgroundColor=kSetColor(0.3, 0.3, 0.3, 0.35);
    hud.labelFont=[UIFont boldSystemFontOfSize:14];
}
-(void)hideHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)showAlert:(NSString *)title msg:(NSString *)aMsg btnTitle:(NSArray *)titles Id:(AlertId )aId
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title  message:aMsg delegate:aId ==kAlertSuccess ? self:nil cancelButtonTitle:titles[0] otherButtonTitles:titles.count==1?nil:titles[1], nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (buttonIndex==0) {
        RootViewController *root=[RootViewController new];
        [UIApplication sharedApplication].keyWindow.rootViewController=root;
    }
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isEditing=NO;
    [self.view endEditing:YES];
}
@end
