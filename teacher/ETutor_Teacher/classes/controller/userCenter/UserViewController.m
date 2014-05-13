//
//  UserViewController.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-2-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UserViewController.h"
#import "LoginViewController.h"
#import "PerfectViewController.h"
#import "TeaInfoCell.h"
#import "TeacherManager.h"

#define kPhotoHeight 90
#define kNameFont   18
#define kAccFont 12
#define kOperationH  60
#define kJumpBtnId  @"btnId"
#define kHeanderH self.tableView.frame.size.height*0.35
#define kPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"icon.jpg"]

#define kStarCount 5
#define kRankViewWidth 120
@interface UserViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *_photo;//头像
    UILabel *_nameLbl;//姓名
    UILabel *_accLbl;//账号
    UIView *_rankV;//评分
    UIButton *_editInfo;//修改资料
    UIImageView *_gender;//性别
    UIImageView  *_operation;//
    
    BOOL _statu;
    NSMutableArray *_teaInfoArr;//教师信息数组
    
    TeacherUser *_teacher;
    PerfectViewController *_perfectVC;
    UIImageView *_headerImg;
    CGFloat _starY;
    UIImagePickerController *_imgPickerController;
}
@end

@implementation UserViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryTeacherInfo];
}


#pragma mark -viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"个人中心";
    _teaInfoArr=[NSMutableArray array];
    self.tableView.backgroundColor=kSetColor(0.95, 0.95, 0.95, 1);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.bounces=NO;
    [self addTableHeaderView];
}

#pragma mark - 添加用户信息头部视图
-(void)addTableHeaderView
{
    //头部根view
    UIImageView *view=[[UIImageView alloc]init];
    view.image=[UIImage imageNamed:@"header_page_7.jpg"];
    view.frame=CGRectMake(0, 0, 0, kHeanderH);
    view.userInteractionEnabled=YES;
    self.tableView.tableHeaderView=view;
    
    //操作条view
    _operation=[[UIImageView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-kOperationH, view.frame.size.width, kOperationH)];
    _operation.backgroundColor=[UIColor whiteColor];
    [view addSubview:_operation];

    //操作条底部水平线
    UIView *horline=[[UIView alloc]initWithFrame:CGRectMake(0, _operation.frame.size.height-2, _operation.frame.size.width, 2)];
    horline.backgroundColor=[UIColor lightGrayColor];
    [_operation addSubview:horline];
    
    //头像
    _photo=[[UIImageView alloc]init];
    _photo.frame=CGRectMake(10,_operation.frame.origin.y-kPhotoHeight*0.5, kPhotoHeight, kPhotoHeight);
    _photo.backgroundColor=[UIColor whiteColor];
    _photo.contentMode=UIViewContentModeScaleAspectFill;
    _photo.layer.cornerRadius=5;
    _photo.layer.masksToBounds=YES;
    _photo.userInteractionEnabled=YES;
    [view addSubview:_photo];

    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImage:)];
    [_photo addGestureRecognizer:tap];
    
    //姓名标签
    _nameLbl=[[UILabel alloc]init];
    _nameLbl.font=[UIFont systemFontOfSize:kNameFont];
    _nameLbl.textColor=[UIColor blackColor];
    [view addSubview:_nameLbl];
    
    //性别
    _gender=[[UIImageView alloc]init];
    [view addSubview:_gender];
    
    //账号标签
    _accLbl=[[UILabel alloc]init];
    _accLbl.font=[UIFont systemFontOfSize:kAccFont];
    _accLbl.textColor=[UIColor blackColor];
    [view addSubview:_accLbl];
    
    //评分
    _rankV=[[UIView alloc]init];
    [view addSubview:_rankV];
    
    //修改资料
    _editInfo=[UIButton buttonWithType:UIButtonTypeCustom];
    [_editInfo setTitle:@"修改资料" forState:UIControlStateNormal];
    [_editInfo setTitleColor:kSetColor(0, 0, 0.8, 0.8) forState:UIControlStateNormal];
    _editInfo.titleLabel.font=[UIFont systemFontOfSize:12];
    [_editInfo setBackgroundImage:[UIImage stretchImageWithName:@"userinfo_button@2x"] forState:UIControlStateNormal];
    [_editInfo addTarget:self action:@selector(editInfo) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_editInfo];
}
-(void)editInfo
{
    if (!_perfectVC) {
        _perfectVC= [PerfectViewController new];
    }
    _perfectVC.teacher=_teacher;
    [self.navigationController pushViewController:_perfectVC animated:YES];
}
-(void)uploadImage:(UITapGestureRecognizer *)sender
{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"请选择上传方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"本地上传" otherButtonTitles:@"拍照", nil];
    [sheet showInView:self.view.window];
}
#pragma mark - 计算header控件frame
-(void)labelFrameText:(TeacherUser *)teacher
{
    [_photo setImageWithURL:[NSURL URLWithString:kDowlondIconURL(teacher.icon)] placeholderImage:[UIImage imageNamed:@"Userplaceholder_icon@2x.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    NSString *nameText=[NSString stringWithFormat:@"姓名: %@",teacher.name];
    CGSize  namesize=[nameText sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kNameFont]}];
    
    NSString *acc=[AllAccManager sharedAllAccManager].teaAcc.userName;
    NSString *accText=[NSString stringWithFormat:@"账号: %@",acc];
    CGSize  accsize=[accText sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kAccFont]}];
    
    _nameLbl.text=nameText;
    _nameLbl.frame= CGRectMake(CGRectGetMaxX(_photo.frame)+15,_operation.frame.origin.y-namesize.height, namesize.width, namesize.height);
    _nameLbl.font=[UIFont boldSystemFontOfSize:kNameFont];
    _accLbl.text=accText;
    _accLbl.frame= CGRectMake(_nameLbl.frame.origin.x, _operation.frame.origin.y, accsize.width, accsize.height);
    
    _gender.frame=CGRectMake(CGRectGetMaxX(_nameLbl.frame), _nameLbl.frame.origin.y, namesize.height, namesize.height);
    if ([teacher.gender isEqualToString:@"女"]) {
        _gender.image=[UIImage imageNamed:@"userinfo_gender_female.png"];
    }else if ([teacher.gender isEqualToString:@"男"])
    {
        _gender.image=[UIImage imageNamed:@"userinfo_gender_male.png"];
    }

    _rankV.frame=CGRectMake(_nameLbl.frame.origin.x, CGRectGetMaxY(_accLbl.frame), kRankViewWidth, kRankViewWidth/kStarCount);
    for (int i=0; i<kStarCount; i++) {
        UIImageView *star=[[UIImageView alloc]init];
        star.frame=CGRectMake(i*kRankViewWidth/kStarCount, 0, kRankViewWidth/kStarCount, kRankViewWidth/kStarCount);
        
        star.image=[UIImage imageNamed:@"rank_star.png"];
        [_rankV addSubview:star];
    }
    _editInfo.frame=CGRectMake(CGRectGetMaxX(_rankV.frame)+5, _rankV.frame.origin.y, 59, _rankV.frame.size.height);
}
-(void)showHUD
{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"加载信息中...";
    hud.backgroundColor=kSetColor(0.3, 0.3, 0.3, 0.35);
    hud.labelFont=[UIFont boldSystemFontOfSize:14];
}
-(void)hidenHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark - 查询教师信息
-(void)queryTeacherInfo
{
    NSString *teaId=[[NSUserDefaults standardUserDefaults]objectForKey:kTeacherId];
    [self showHUD];
    
    [RequestTool requestQueryTeacherId:[teaId intValue] accessed:^(CodeType codeType, TeacherUser *teacher) {
        _teacher=teacher;
        [self hidenHUD];
        if(!teacher.identity||[teacher.identity isEqualToString:@""])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示！" message:@"您的个人信息没有完善,是否现在完善?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
            [alert show];
            
            return ;
        }else
        {
            [self setDataSource:teacher];
            [[TeacherManager sharedTeacherManager]archiveTeacher:teacher];
            [self.tableView reloadData];
        }
    } fail:^{
        [self hidenHUD];
    }];
}
-(void)setDataSource:(TeacherUser *)teacher
{
    [_teaInfoArr removeAllObjects];
    [self labelFrameText:teacher];
    /*
     *qq;          //QQ;
     *sinaweibo;   //新浪微博；
     *memo;        //备注信息；
     */

    NSString *iden=[teacher.identity stringByReplacingCharactersInRange:NSMakeRange(6, 8) withString:@"***"];
    NSArray *arr1=@[@{@"姓名": teacher.name},@{@"身份证": iden}];
    [_teaInfoArr addObject:arr1];
    
    NSArray *arr2=@[@{@"性别": teacher.gender},@{@"年龄":[self ageWithIdentity:teacher.identity]},@{@"电话": teacher.telephone},@{@"学历": teacher.degree}];
    [_teaInfoArr addObject:arr2];
    
    NSArray *arr3=@[@{@"辅导科目": teacher.subjectinfo},@{@"辅导对象": teacher.objectinfo},@{@"辅导时间": teacher.timepriod}];
    [_teaInfoArr addObject:arr3];
    
    NSArray *arr4=@[@{@"注册地址": teacher.majoraddress}];
    [_teaInfoArr addObject:arr4];

}
-(NSString *)ageWithIdentity:(NSString *)identity
{
    
    NSInteger birY=[[identity substringWithRange:NSMakeRange(6, 4)] integerValue];
    NSInteger birM=[[identity substringWithRange:NSMakeRange(10, 2)] integerValue];
    NSInteger birD=[[identity substringWithRange:NSMakeRange(12, 2)] integerValue];
    
    NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
    formatter1.dateFormat=@"yyyy";
    NSInteger currY=[[formatter1 stringFromDate:[NSDate date]] integerValue];
    
    NSDateFormatter *formatter2=[[NSDateFormatter alloc]init];
    formatter2.dateFormat=@"MM";
    NSInteger currM=[[formatter2 stringFromDate:[NSDate date]] integerValue];
    
    NSDateFormatter *formatter3=[[NSDateFormatter alloc]init];
    formatter3.dateFormat=@"dd";
    NSInteger currD=[[formatter3 stringFromDate:[NSDate date]] integerValue];
    
    NSInteger age=currY-birY;
    
    if (birM>currM) {
        age-=1;
    }else if (birM==currM)
    {
        if (birD>currD) {
            age-=1;
        }
    }
    
    return [NSString stringWithFormat:@"%d",age];
}
#pragma mark - alertView delagate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        PerfectViewController *perfect=[PerfectViewController new];
        [self.navigationController pushViewController:perfect animated:YES];
    }
}
#pragma mark - actionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        //检查是否有图片库（图片选取器的isSourceTypeAvailable类方法）
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"警告!" message:@"设备不存在照片" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
        //检查图片选取器是否存在，不存在创建并指定委托
        
        if (!_imgPickerController) {
            _imgPickerController=[[UIImagePickerController alloc]init];
            _imgPickerController.delegate=self;
        }
        
        //设定照相机可以获取那些类型的媒体（图片选取器的mediaTypes属性kUTTypeMovie和kUTTypeImage）
        _imgPickerController.mediaTypes=@[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
        
        //设定图片的来源为图片库（图片选取器的sourceType属性UIImagePickerControllerSourceTypePhotoLibrary）
        _imgPickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        
        //打开图片选取器视图控制器（模态视图方式）
        [self presentViewController:_imgPickerController animated:YES completion:nil];

    }else if (buttonIndex ==1)
    {
        
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //从info字典参数中获取媒体类型
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断媒体类型是否为图片
    if ([mediaType isEqualToString:(NSString *) kUTTypeImage]){
        //如果是则从info字典参数中获取源图片
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //将源图片显示在界面上
        _photo.image = image;
        //如果图片选取器的源类型为摄像头
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //将照片存入系统相册
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
        [self statUpLoad:image];
        [picker dismissViewControllerAnimated:YES completion:nil];

    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //关闭图片选取器控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)statUpLoad:(UIImage *)image
{
    NSData *data=UIImagePNGRepresentation(image);
    [data writeToFile:kPath atomically:YES];
    [RequestTool requestIconUpload:kPath andTeacherid:_teacher.teacherid success:^(CodeType codeType) {
        
    } fail:^{
        
    }];
}
#pragma mark - tableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  _teaInfoArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_teaInfoArr[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier=@"cell";
    TeaInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
         cell=[[TeaInfoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.highlightedTextColor=cell.textLabel.textColor;
        
        UIImageView *bg=[[UIImageView alloc]init];
        cell.backgroundView=bg;
        
        UIImageView *selectedBg=[[UIImageView alloc]init];
        cell.selectedBackgroundView=selectedBg;
    }
    cell.teaInfo=_teaInfoArr[indexPath.section][indexPath.row];
    /*
     设置背景
     */
    UIImageView *bg=(UIImageView *)cell.backgroundView;
    UIImageView *selectedBg=(UIImageView *)cell.selectedBackgroundView;
    int count=[_teaInfoArr[indexPath.section] count];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
@end
