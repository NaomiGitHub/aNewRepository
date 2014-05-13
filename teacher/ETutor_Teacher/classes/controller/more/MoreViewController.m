//
//  MoreViewController.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-2-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreSetupCell.h"
#import "IdeaReportViewController.h"
#import "StrapViewController.h"
#import "SysSettingViewController.h"
#import "LoginViewController.h"
#define kCellHeight 49
#define kSectionHeight 13
@interface MoreViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>
{
    NSArray *_setupContent;
    UILabel *_weibo;
    UILabel *_qq;
    UIAlertView *_loginAlert;
    UIAlertView *_clearCache;
    UIAlertView *_strapWeibo;
}
@end

@implementation MoreViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"更 多";
    self.tableView.backgroundColor=kGlobalBgColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.bounces=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    
    _setupContent=[NSArray arrayWithObjects:
                   @[@"订单历史",@"系统设置",@"清除缓存"],
                   @[@"微博账号绑定",@"QQ账号绑定"],
                   @[@"意见反馈",@"关于我们",@"检查更新"], nil];
    
    [self addExitBtn];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    label.textAlignment=NSTextAlignmentRight;
    _weibo=label;

}
#pragma mark - 最后退出按钮
-(void)addExitBtn
{
    UIView *foot=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 70)];
    UIButton *exitbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    exitbtn.frame=CGRectMake(10, 10, 300, 50);
    [exitbtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    
    UIImage * normal=[UIImage stretchImageWithName:@"button_big_red"];
    [exitbtn setBackgroundImage:normal forState:UIControlStateNormal];
    
    UIImage * highlight=[UIImage stretchImageWithName:@"button_big_red_highlighted"];
    [exitbtn setBackgroundImage:highlight forState:UIControlStateHighlighted];

    [exitbtn addTarget:self action:@selector(exitAccount) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:exitbtn];
     self.tableView.tableFooterView=foot;
    
}
#pragma mark - 退出账号
-(void)exitAccount
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"您确定要退出账号吗" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view.window];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [[NSUserDefaults standardUserDefaults]setObject:NO forKey:kLoginStatu];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kTeacherId];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        LoginViewController *login=[LoginViewController new];
        [self presentViewController:login animated:YES completion:nil];
    }
}
#pragma mark - tableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _setupContent.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_setupContent[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MoreSetupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[MoreSetupCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.highlightedTextColor=cell.textLabel.textColor;
        
        UIImageView *bg=[[UIImageView alloc]init];
        cell.backgroundView=bg;
        
        UIImageView *selectedBg=[[UIImageView alloc]init];
        cell.selectedBackgroundView=selectedBg;
    }
    cell.textLabel.text=_setupContent[indexPath.section][indexPath.row];
    
    if (indexPath.section==0&&indexPath.row==2) {
        cell.detailTextLabel.text=@"包括:图片,数据等";
    }else if (indexPath.section==1&&indexPath.row==0)
    {

        cell.detailTextLabel.text=[[NSUserDefaults standardUserDefaults]objectForKey:kWeiboName];
    }
    
    /* 
     设置背景
     */
    UIImageView *bg=(UIImageView *)cell.backgroundView;
    UIImageView *selectedBg=(UIImageView *)cell.selectedBackgroundView;
    int count=[_setupContent[indexPath.section] count];
    NSString *imgName=nil;
    if (count==1) {
        imgName=@"card_background.png";
    }else if (indexPath.row==0)
    {
        imgName=@"card_top_background.png";
    }else if(indexPath.row==count-1)
    {
        imgName=@"card_bottom_background.png";
    }else
    {
        imgName=@"card_middle_background.png";
    }
    bg.image=[UIImage stretchImageWithName:imgName];
    selectedBg.image=[UIImage stretchImageWithName:[imgName appendFileName:@"_highlighted"]];
    
    
    return cell;
}
#pragma mark - tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
    /*第一组*/
        case 0:
            if (indexPath.row==0) {
                //第一行   订单历史
                
            }else if (indexPath.row==1)
            {
                //第二行   系统设置
                [self.navigationController pushViewController:[SysSettingViewController new] animated:YES];
            }else if (indexPath.row==2)
            {
                //第三行   清空缓存
                _clearCache=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要清空缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [_clearCache show];
            }
            break;
    /*第二组*/
        case 1:
            if (indexPath.row==0) {
                //第一行   绑定微博账号
                if (![[NSUserDefaults standardUserDefaults]boolForKey:kLoginStatu]) {
                    _loginAlert=[[UIAlertView alloc]initWithTitle:@"亲，请先登录!" message:@"是否现在登录?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
                    [_loginAlert show];
                    return;
                }
                if ([AllAccManager sharedAllAccManager].sinaAcc) {
                    _strapWeibo=[[UIAlertView alloc]initWithTitle:@"提示!" message:@"您已经绑定账号,是否更换账号?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
                    [_strapWeibo show];
                }else
                {
                    StrapViewController *strap=[StrapViewController new];
                    [self presentViewController:strap animated:YES completion:nil];
                }
            }else if (indexPath.row==1)
            {
                //第二行   绑定QQ账号
                
            }
            
            break;
    /*第三组*/
        case 2:
            if (indexPath.row==0) {
                //第一行   意见反馈
                IdeaReportViewController *idea=[IdeaReportViewController new];
                [self.navigationController pushViewController:idea animated:YES];
            }else if (indexPath.row==1)
            {
                //第二行   关于我们
            }else if (indexPath.row==2)
            {
                //第三行   检查更新
                
            }
            break;
        }
    
    
}
#pragma mark - cell height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, kSectionHeight)];
    return view;
}
#pragma mark -  alertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==_loginAlert &&buttonIndex==0) {
            [self presentViewController:[LoginViewController new] animated:YES completion:nil];
    }else if (alertView==_strapWeibo &&buttonIndex==0) {
        StrapViewController *strap=[StrapViewController new];
        [self presentViewController:strap animated:YES completion:nil];
    }else if (alertView==_clearCache &&buttonIndex==0)
    {
        
    }
}
@end
