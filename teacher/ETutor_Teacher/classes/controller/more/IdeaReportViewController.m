//
//  IdeaReportViewController.m
//  金种子工程
//
//  Created by Ibokan on 14-2-13.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "IdeaReportViewController.h"
#define kBorderWidth 5
#define kFooterText  12

@interface IdeaReportViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    UITextView *_contentView;
    UITextField *_emailField;
    
    NSMutableArray *_textField;
    BOOL _isEndEdit;
    
}
@end

@implementation IdeaReportViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = @"cube";
    transition.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:transition forKey:@"animation"];
    self.view.backgroundColor=kSetColor(0.9, 0.9, 0.9, 0.9);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"意见反馈";
    [self addSubView];
}

#pragma mark -添加控件
-(void)addSubView
{
    //  内容label
    CGFloat lblHeight=40;
    UILabel *contentLbl=[[UILabel alloc]initWithFrame:CGRectMake(kBorderWidth, kBorderWidth, 60, lblHeight)];
    contentLbl.font=[UIFont systemFontOfSize:18];
    contentLbl.text=@"内容";
    [self.view addSubview:contentLbl];
    
    //  内容textView
    _contentView=[[UITextView alloc]init];
    _contentView.backgroundColor=kTextBgColor;
    _contentView.frame=CGRectMake(kBorderWidth, CGRectGetMaxY(contentLbl.frame), self.view.frame.size.width-kBorderWidth*2, 120);
    _contentView.delegate=self;
    [self.view addSubview:_contentView];
    
    //内容提示信息
    UILabel *contentFooter=[[UILabel alloc]init];
    NSString *footerText=@"您的意见是我们宝贵的财富,我们会努力完善自身,谢谢您的支持";
    CGRect rect=[footerText boundingRectWithSize:CGSizeMake(self.view.frame.size.width-kBorderWidth*4, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kFooterText]} context:nil];
    contentFooter.frame=(CGRect){{kBorderWidth*2,CGRectGetMaxY(_contentView.frame)},rect.size};
    contentFooter.textColor=kSetColor(0.9, 0.1, 0.1, 0.8);
    contentFooter.font=[UIFont systemFontOfSize:kFooterText];
    contentFooter.numberOfLines=0;
    contentFooter.text=footerText;
    [self.view addSubview:contentFooter];

    //邮箱
    _emailField=[[UITextField alloc]initWithFrame:CGRectMake(kBorderWidth, CGRectGetMaxY(contentFooter.frame), self.view.frame.size.width-kBorderWidth*2, lblHeight)];
    _emailField.borderStyle=UITextBorderStyleRoundedRect;
    _emailField.placeholder=@"请输入您的邮箱";
    _emailField.delegate=self;
    [self.view addSubview:_emailField];
    //提示
    UILabel *contactFooter=[[UILabel alloc]init];
    contactFooter.frame=CGRectMake(kBorderWidth,CGRectGetMaxY(_emailField.frame), self.view.frame.size.width-kBorderWidth*4, 40);
    contactFooter.font=[UIFont systemFontOfSize:kFooterText];
    contactFooter.textColor=[UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1];
    contactFooter.numberOfLines=0;
    contactFooter.text=@"请填写您的联系方式,方便我们联系您";
    [self.view addSubview:contactFooter];
    //提交按钮
    UIButton *submitBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submitBtn setTitle:@"提  交" forState:UIControlStateNormal];
    submitBtn.bounds=CGRectMake(0, 0, _emailField.frame.size.width, 40);
    submitBtn.layer.borderColor=kSetColor(0, 0, 0.5, 0.8).CGColor;
    submitBtn.layer.borderWidth=1;
    submitBtn.layer.cornerRadius=3;
    submitBtn.center=CGPointMake(self.view.center.x, CGRectGetMaxY(contactFooter.frame)+kBorderWidth*4);
    [submitBtn addTarget:self action:@selector(submitInformation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];

}

#pragma mark -提交按钮事件
-(void)submitInformation
{
    _isEndEdit=NO;
    [self.view endEditing:YES];
    
    BOOL content=[_contentView.text isEqualToString:@""];
    BOOL email=[_emailField.text isEqualToString:@""];
    
    //判断邮箱格式
    NSString *patternEmail=@"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}";
    NSPredicate *emailPre=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",patternEmail];
    BOOL res=[emailPre evaluateWithObject:_emailField.text];
    
    //判断输入类容是否有空
    if (content||email) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误提示！" message:@"提交内容有空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }else if(!res)//如果有想格式不对就弹出alertView提示
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误提示！" message:@"邮箱格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }else//如果都没问题就发送提交请求
    {
        //[self requestSubmit];
    }
}

#pragma mark - textField delegate
#pragma mark 编辑开始
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _isEndEdit=YES;
    //设置边框
    textField.layer.borderColor=[UIColor colorWithRed:0.95 green:0.4 blue:0.1 alpha:0.95].CGColor;
    textField.layer.cornerRadius=5;
    textField.layer.borderWidth=2;
    //根着键盘往上走
    CGRect frame=self.view.frame;
    
        frame.origin.y=-20;
        [UIView animateWithDuration:0.4 animations:^{
            if (_isEndEdit) {
                self.view.frame=frame;
            }

        }];
}
#pragma mark 编辑结束
-(void)textFieldDidEndEditing:(UITextView *)textField
{
    //取消边框
    textField.layer.borderColor=[UIColor clearColor].CGColor;
    textField.layer.borderWidth=0;
    //跟着键盘往下走
    CGRect frame=self.view.frame;
    frame.origin.y=64;
    [UIView animateWithDuration:0.4 animations:^{
        if (!_isEndEdit) {
            self.view.frame=frame;
        }
        
    }];}


#pragma mark - textView delegate
#pragma mark  编辑开始
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    //设置边框
    _isEndEdit=NO;
    CGRect frame=self.view.frame;

    frame.origin.y=64;
    [UIView animateWithDuration:0.4 animations:^{
        if (!_isEndEdit) {
            self.view.frame=frame;
        }
        
    }];

    textView.layer.borderColor=[UIColor colorWithRed:0.95 green:0.4 blue:0.1 alpha:0.95].CGColor;
    textView.layer.borderWidth=2;

}
#pragma mark  编辑结束
-(void)textViewDidEndEditing:(UITextView *)textView
{//取消边框
        textView.layer.borderColor=[UIColor clearColor].CGColor;
    textView.layer.borderWidth=0;

}
#pragma mark - 点击背景view时结束编辑

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isEndEdit=NO;

    [self.view endEditing:YES];

}

@end
