//
//  StrapViewController.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-11.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "StrapViewController.h"
#import "SinaAccount.h"
#import "AllAccManager.h"
#import "MoreViewController.h"
#define kBorderWidth 10

@interface StrapViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    NSString   *_screenName;
}
@end

@implementation StrapViewController

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
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_webView];

    IconBtn *backBtn=[IconBtn buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(5, 20, kBtnWidth, kBtnHeight);
    [backBtn setImage:[UIImage imageNamed:@"backward@2x.png"] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
	// Do any additional setup after loading the view.
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:kOauthURL]];
    [_webView loadRequest:request];
    _webView.delegate=self;
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:webView animated:YES];
    hud.labelText=@"加载中...";
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:webView animated:YES];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *backURLString = request.URL.absoluteString;
    //判断是否是授权调用返回的URL
    if([backURLString hasPrefix:kRedirectURL]){
    /*
     1.获取code值
    */
        //找到code=的range
        NSRange rangeOne = [backURLString rangeOfString:@"code="];
        //根据code=的rang确定code参数值的range
        int len_loacl = rangeOne.length + rangeOne.location;
        NSRange range = NSMakeRange(len_loacl, backURLString.length-len_loacl);
        //获取code值
        NSString *codeString = [backURLString substringWithRange:range];
    /*
     2.获取access_token
    */
        //access_token调用URL的string
        NSMutableString *muString = [[NSMutableString alloc]initWithFormat:@"https://api.weibo.com/oauth2/access_token?client_id=%@&client_secret=%@&grant_type=authorization_code&code=%@&redirect_uri=%@",kAppKey,kAppSecret,codeString,kRedirectURL];
        //第一步: 创建URL
        NSURL *urlString = [NSURL URLWithString:muString];
        //第二部：创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:urlString cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *str = @"type=focus-c";//设置参数
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        
        //第三部：连接服务器
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        
        //从str1中获取access_token
        
        NSData *jsonData = [str1 dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSString *access_token = [json objectForKey:@"access_token"];
        NSString *uid = [json objectForKey:@"uid"];
        
        
        SinaAccount *account = [[SinaAccount alloc]init];
        if(access_token != nil){
            account.accessToken = access_token;
            account.uid          = uid;
            //发送请求获取用户得昵称
            //初始化请求对象
            NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",access_token,uid];
            NSURL *url = [NSURL URLWithString:urlString];
            __weak ASIHTTPRequest *req=[ASIHTTPRequest requestWithURL:url];
            [req startAsynchronous];
            [req setCompletionBlock:^{
                NSData *data=[req responseData];
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                //获取用户名称
                _screenName=dict[@"screen_name"];
                [[NSUserDefaults standardUserDefaults] setObject:_screenName forKey:kWeiboName];
                [[NSUserDefaults standardUserDefaults]synchronize];
                account.screenName = _screenName;
                //进行归档
                [[AllAccManager sharedAllAccManager]addSinaAcc:account];
                [MBProgressHUD hideHUDForView:_webView animated:YES];
                [self back];

            }];
            return NO;
        }
    }
    
    return YES;
    

}

@end
