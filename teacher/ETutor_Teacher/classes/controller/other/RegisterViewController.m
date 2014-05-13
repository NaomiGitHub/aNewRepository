//
//  RegisterViewController.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-2-28.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "RegisterViewController.h"
#import "RootViewController.h"
#import "RequestTool.h"
#import "TeacherAccount.h"
#import "AllAccManager.h"
typedef enum {
    kAlertSuccess =0,
    kAlertTextNone = 1,
    kAlertUserNameEqual = 2,
    kAlertServerErr =3,
    kAlertWebErr
    
    
}AlertId;
#define kIconY 100
#define kIconH 100

@interface RegisterViewController ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    UITextField *_account;
    UITextField *_pw;
    AlertId  alertId;
}
@end

@implementation RegisterViewController
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
    UIImageView *bg=[[UIImageView alloc]init];
    bg.frame=self.view.frame;
    bg.image=[UIImage imageNamed:@"register_bg@2x.png"];
    bg.userInteractionEnabled=YES;
    self.view=bg;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   

    IconBtn *backBtn=[IconBtn buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(5, 20, kBtnWidth, kBtnHeight);
    [backBtn setImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    UIImageView *title=[[UIImageView alloc]init];
    title.bounds=CGRectMake(0, 0, 60, 22);
    title.center=CGPointMake(self.view.frame.size.width*0.5, 37);
    title.image=[UIImage imageNamed:@"register_title@2x.png"];
    [self.view addSubview:title];

    UIImageView *iconView=[[UIImageView alloc]init];
    iconView.bounds=CGRectMake(0, 0, 100, 100);
    iconView.center=CGPointMake(self.view.frame.size.width*0.5, kIconY+kIconH*0.5);
    iconView.image=[UIImage imageNamed:@"LRicon@2x.png"];
    [self.view addSubview:iconView];
    [self addSubView];
}
#pragma mark - 返回按钮事件
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 添加控件
-(void)addSubView
{
    //放置两个textField的view 方便移动
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, kIconH+kIconY+15, self.view.frame.size.width-20, 100)];
    [self.view addSubview:view];

    //账号textField
    _account=[[UITextField alloc]init];
    _account.borderStyle=UITextBorderStyleRoundedRect;
    _account.keyboardType=UIKeyboardTypeEmailAddress;
    _account.placeholder=@"账号:";
    _account.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _account.layer.cornerRadius=2;
    _account.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height*0.5);
    [view addSubview:_account];
    //密码textField
    _pw=[[UITextField alloc]init];
    _pw.borderStyle=UITextBorderStyleRoundedRect;
    _pw.placeholder=@"密码:";
    _pw.layer.cornerRadius=2;
    _pw.secureTextEntry=YES;
    _pw.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _pw.frame=CGRectMake(0, CGRectGetMaxY(_account.frame), view.frame.size.width, view.frame.size.height*0.5);
    [view addSubview:_pw];
    
    _account.delegate = self;
    _pw.delegate = self;
    
    //注册按钮
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(view.frame.origin.x, CGRectGetMaxY(view.frame)+30, view.frame.size.width, 50);
    [button addTarget:self action:@selector(registerAccount) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"register_btn_bg@2x.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"register_btn_bg_highlighted@2x.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    //微博账号登陆

}
#pragma mark - 注册按钮事件
-(void)registerAccount
{
    [self.view endEditing:YES];
    
    if ([_account.text isEqualToString:@""]||[_pw.text isEqualToString:@""]) {
        
        [self showAlert:@"注册失败！" msg:@"账号或密码有空" btnTitle:@[@"确定"] Id:kAlertTextNone];
    }else
    {
        
        [self showHUD];
        [RequestTool requestRegister:_account.text andPassword:_pw.text success:^(CodeType codeType, NSString *teacherid) {
            
            [self hideHUD];
            NSLog(@"%@",teacherid);
            if (teacherid!=nil &&codeType==kCode_success) {
                [self showAlert:@"注册成功！" msg:@"是否现在登录？"btnTitle:@[@"是",@"否"] Id:kAlertSuccess];
                [[NSUserDefaults standardUserDefaults]setObject:teacherid forKey:kTeacherId];
                TeacherAccount *account=[[TeacherAccount alloc]init];
                account.userName=_account.text;
                account.password=_pw.text;
                [[AllAccManager sharedAllAccManager]addTeaAcc:account];
                
            }if (codeType==kCode_equal) {
                
                [self showAlert:@"注册失败！" msg:@"用户名重复" btnTitle:@[@"确定"] Id:kAlertUserNameEqual];
            } else if(codeType==kCode_fail){
                [self showAlert:@"注册失败！" msg:@"服务器错误" btnTitle:@[@"确定"] Id:kAlertServerErr];
            }
            
        } fail:^{
            [self hideHUD];
            [self showAlert:@"错误信息!" msg:@"亲! 您的网络不给力哦" btnTitle:@[@"确定"] Id:kAlertWebErr];
        }];
    }
    
    
}
-(void)showHUD
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"正在注册...";
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
    //[self dismissViewControllerAnimated:YES completion:nil];

    if (buttonIndex==0) {
        [UIApplication sharedApplication].statusBarHidden=NO;
        RootViewController *root=[RootViewController new];
        [UIApplication sharedApplication].keyWindow.rootViewController=root;
    }
    
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
@end
