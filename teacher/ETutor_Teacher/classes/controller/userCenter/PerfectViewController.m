//
//  PerfectViewController.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-6.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "PerfectViewController.h"
#import "SIAlertView.h"
#import "CYCustomMultiSelectPickerView.h"
#import "UserInfo.h"
#import "IconBtn.h"
#import "CityViewController.h"
#import "TimePicker.h"
#define kViewWidth (self.view.frame.size.width-10)
#define kViewHeight 44
#define kTitleHeight 30
#define kCellNameFont 14
#define kCellTextFont 14
@interface PerfectViewController ()<UITextFieldDelegate,UIActionSheetDelegate,CYCustomMultiSelectPickerViewDelegate>
{
    UITextField *_teaName;
    UITextField *_idNumber;
    UITextField *_telNumber;
    UITextField *_gender;
    UITextField *_address;
    UITextField *_degree;
    UITextField *_objectinfo;
    UITextField *_subjectinfo;
    UITextField *_time;
    
    UITextField *_email;
    UITextField *_qq;
    UITextField *_memo;
    BOOL isEditing;
    BOOL btnSelected;
    
    IconBtn *xiao;
    IconBtn *zhong;
    IconBtn *gao;
    SIAlertView *_alertView;
    CYCustomMultiSelectPickerView *_picker;
    CityViewController *_cityVC;
    
    UIDatePicker *_startTime;
    UIDatePicker *_endTime;
    UIView *_dateView;
    NSMutableArray *_entriesSelected;
    NSMutableArray *_selectionStates;
    
    NSString* _supportObj;
    
    UIScrollView *_scroll;
    
    double  _latitude;
    double  _longitude;
    
    CGFloat h;
    int k;
}

@end

@implementation PerfectViewController

-(id)init{
    if(self = [super init]){
        [self addSubView];
        self.title=@"填写资料";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)loadView
{
    [super loadView];
    
    _scroll=[[UIScrollView alloc]initWithFrame:self.view.frame];
    _scroll.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*1.3);
    _scroll.bounces=NO;
    self.view=_scroll;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitInfo)];
    self.navigationItem.rightBarButtonItem=right;
    self.view.backgroundColor=kSetColor(0.98, 0.98, 0.98, 1);
    
    UILabel *tishi=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, kViewWidth, kTitleHeight)];
    tishi.textColor=kSetColor(1, 0.5, 0.1, 1);
    tishi.font=[UIFont systemFontOfSize:12];
    tishi.numberOfLines=0;
    tishi.text=@"请认真填写以下内容,否则您将无法做其他操作";
    [self.view addSubview:tishi];
    
}

- (void)setTeacher:(TeacherUser *)teacher{
    _teacher = teacher;
    _teaName.text=self.teacher.name;
    _gender.text=self.teacher.gender;
    _idNumber.text=self.teacher.identity;
    _telNumber.text=self.teacher.telephone;
    _degree.text=self.teacher.degree;
    _address.text=self.teacher.majoraddress;
    _supportObj=self.teacher.objectinfo;
    if ([_supportObj isContainsStr:@"小学"]) {
        xiao.selected=YES;
    }
    if ([_supportObj isContainsStr:@"初中"]) {
        zhong.selected=YES;
    }
    if ([_supportObj isContainsStr:@"高中"]) {
        gao.selected=YES;
    }
    _subjectinfo.text=self.teacher.subjectinfo;
    _time.text=self.teacher.timepriod;

}
#pragma mark - 提交按钮事件
-(void)submitInfo
{
    [self.view endEditing:YES];
    TeacherUser *teacher=[[TeacherUser alloc]init];
        if ([_teaName.text isEqualToString:@""]||[_gender.text isEqualToString:@""]||[_idNumber.text isEqualToString:@""]||[_degree.text isEqualToString:@""]||[_address.text isEqualToString:@""]||[_subjectinfo.text isEqualToString:@""]||[_supportObj isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"补充信息有空" message:@"请完善您的信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![self validateNickname:_teaName.text])
    {
        [self showAlert:@"姓名输入有误" msg:@"请重新输入"];
    }else if (![self validateIdentityCard:_idNumber.text])
    {
        [self showAlert:@"身份证格式有误" msg:@"请重新输入"];
    }else if (![self validateMobile:_telNumber.text])
    {
        [self showAlert:@"手机号码格式有误" msg:@"请重新输入"];
    }else
    {
        teacher.teacherid=[[NSUserDefaults standardUserDefaults]objectForKey:kTeacherId];
        teacher.name=_teaName.text;
        teacher.gender=[self stringGenderWithIdNum:_idNumber.text];
        teacher.identity=_idNumber.text;
        teacher.telephone=_telNumber.text;
        teacher.degree=_degree.text;
        teacher.majoraddress=_address.text;
        teacher.objectinfo=_supportObj;
        teacher.subjectinfo=_subjectinfo.text;
        teacher.birthday=[self stringDateWithString:_idNumber.text];
        teacher.timepriod=_time.text;
        teacher.latitude=_latitude;
        teacher.longitude=_longitude;
        
        [RequestTool requestDetailInfo:teacher success:^(CodeType codeType) {
            if (codeType==kCode_success) {
                [self showAlert:@"提交成功" msg:@"感谢您的合作"];
                //self.editedBlock(teacher);
            }
        } fail:^{
            [self showAlert:@"服务器错误" msg:@"暂时不能提交信息"];
        }];
    }
}
-(NSString *)stringGenderWithIdNum:(NSString *)idnum
{
    int  num= [[idnum substringWithRange:NSMakeRange(idnum.length-2, 1)] integerValue];
    if (num%2==0) {
        return @"女";
    }else if(num%2==1)
    {
        return @"男";
    }else
    return @"身份证号错误";
}
#pragma 正则验证
//昵称
- (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{2,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}
//邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//手机号码验证
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
//身份证号
- (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
-(NSString *)stringDateWithString:(NSString *)idNum
{
     NSString *year= [idNum substringWithRange:NSMakeRange(6, 4)];
    NSString *month=[idNum substringWithRange:NSMakeRange(10, 2)];
    NSString *day=[idNum substringWithRange:NSMakeRange(12, 2)];
    return [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
}
#pragma mark- 添加控件
-(void)addSubView
{
     k=0;
    //姓名
    _teaName=[self addViewTitle:@"姓名" placeText:@"请输入姓名" index:k++ oHeight:kViewHeight];
    //身份证
    _idNumber=[self addViewTitle:@"身份证" placeText:@"请输入身份证" index:k++ oHeight:0];
    _idNumber.keyboardType=UIKeyboardTypeNumberPad;
    //电话
    _telNumber=[self addViewTitle:@"电话" placeText:@"请输入电话" index:k++ oHeight:0];
    _telNumber.keyboardType=UIKeyboardTypeNumberPad;
    //地址
    _address=[self addViewTitle:@"现住址" placeText:@"点击选择住址" index:k++ oHeight:0];
    _address.userInteractionEnabled=NO;
    UITapGestureRecognizer *addTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressChoose)];
    [_address.superview addGestureRecognizer:addTap];

    
    //生日
    _time=[self addViewTitle:@"辅导时间:" placeText:@"点击选择时间" index:k++ oHeight:0];
    _time.userInteractionEnabled=NO;
    UITapGestureRecognizer *birTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(birthdayChoose:)];
    [_time.superview addGestureRecognizer:birTap];
    
    //学历
    _degree=[self addViewTitle:@"学历" placeText:@"点击选择学历" index:k++ oHeight:0];
    _degree.userInteractionEnabled=NO;
    UITapGestureRecognizer *degreeTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(degreeChoose:)];
    [_degree.superview addGestureRecognizer:degreeTap];
    
    //辅导对象
    _objectinfo=[self addViewTitle:@"辅导对象" placeText:@"" index:k++ oHeight:0];
    [self supportObjBtn:_objectinfo.superview];
    [_objectinfo removeFromSuperview];

    //辅导科目
    _subjectinfo=[self addViewTitle:@"辅导科目" placeText:@"点击选择科目" index:k++ oHeight:0];
    _subjectinfo.userInteractionEnabled=NO;
    UITapGestureRecognizer *subjTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(subjectInfoChoose:)];
    [_subjectinfo.superview addGestureRecognizer:subjTap];
    
    //邮箱
    _email=[self addViewTitle:@"邮箱" placeText:@"请输入邮箱" index:k++ oHeight:0];
    _email.keyboardType=UIKeyboardTypeEmailAddress;
    _scroll.contentSize=CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(_email.superview.frame)+10);
}
#pragma mark - 地址选择
-(void)addressChoose
{
    
    _cityVC=[[CityViewController alloc]initWithBlock:^(NSString *addr,CLLocationCoordinate2D coordiate) {
        
        _address.text=addr;
        _latitude = coordiate.latitude;
        _longitude = coordiate.longitude;
    }];
    [self.navigationController pushViewController:_cityVC animated:YES];
}
#pragma mark - 辅导对象按钮
-(void)supportObjBtn:(UIView *)view
{
    CGFloat width=view.frame.size.width;
    CGFloat height=view.frame.size.height;
    //小学
    xiao=[IconBtn buttonWithType:UIButtonTypeCustom];
    xiao.bounds=CGRectMake(0, 0, view.frame.size.width/4, 40);
    xiao.center=CGPointMake(width*3/8, height*0.5);
    xiao.titleLabel.font=[UIFont systemFontOfSize:14];
    xiao.tag=1001;
    
    [xiao setTitle:@"小学" forState:UIControlStateNormal];
    [xiao setImage:[UIImage imageNamed:@"selected_false.png"] forState:UIControlStateNormal];
    [xiao setImage:[UIImage imageNamed:@"selected_true.png"] forState:UIControlStateSelected];
    [xiao addTarget:self action:@selector(objSelected:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:xiao];
    //初中
    zhong=[IconBtn buttonWithType:UIButtonTypeCustom];
    zhong.bounds=CGRectMake(0, 0, view.frame.size.width/4, 40);
    zhong.center=CGPointMake(width*5/8, height*0.5);
    zhong.titleLabel.font=[UIFont systemFontOfSize:14];
    zhong.tag=1002;
    
    [zhong setTitle:@"初中" forState:UIControlStateNormal];
    [zhong setImage:[UIImage imageNamed:@"selected_false.png"] forState:UIControlStateNormal];
    [zhong setImage:[UIImage imageNamed:@"selected_true.png"] forState:UIControlStateSelected];
    [zhong addTarget:self action:@selector(objSelected:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:zhong];
    //高中
    gao=[IconBtn buttonWithType:UIButtonTypeCustom];
    gao.bounds=CGRectMake(0, 0, view.frame.size.width/4, 40);
    gao.center=CGPointMake(width*7/8, height*0.5);
    gao.titleLabel.font=[UIFont systemFontOfSize:14];
    gao.tag=1003;
    
    [gao setTitle:@"高中" forState:UIControlStateNormal];
    [gao setImage:[UIImage imageNamed:@"selected_false.png"] forState:UIControlStateNormal];
    [gao setImage:[UIImage imageNamed:@"selected_true.png"] forState:UIControlStateSelected];
    [gao addTarget:self action:@selector(objSelected:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:gao];

}
#pragma mark - 辅导对象选择
-(void)objSelected:(IconBtn *)sender
{
    sender.selected=!sender.selected;
    static NSString *xiao;
    static NSString *zhong;
    static NSString *gao;
    if (sender.selected) {
        switch (sender.tag) {
            case 1001://小学
                xiao=@"小学";
                break;
            case 1002://初中
                zhong=@"初中";
                break;
            case 1003://高中
                gao=@"高中";
                break;
        }
    }else
    {
        switch (sender.tag) {
            case 1001://小学
                xiao=@"";
                break;
            case 1002://初中
                zhong=@"";
                break;
            case 1003://高中
                gao=@"";
                break;
        }

    }
    if (!xiao||!zhong||!gao) {
        if (!zhong&&!gao) {
            _supportObj=[NSString stringWithFormat:@"%@",xiao];
        }else if (!xiao&&!gao)
        {
            _supportObj=[NSString stringWithFormat:@"%@",zhong];
        }else if (!xiao&&!zhong)
        {
            _supportObj=[NSString stringWithFormat:@"%@",gao];
        }else if (!xiao)
        {
            _supportObj=[NSString stringWithFormat:@"%@ %@ ",zhong,gao];
        }else if (!zhong)
        {
            _supportObj=[NSString stringWithFormat:@"%@ %@ ",xiao,gao];
        }else if (!gao)
        {
            _supportObj=[NSString stringWithFormat:@"%@ %@ ",xiao,zhong];
        }
    }else
    _supportObj=[NSString stringWithFormat:@"%@ %@ %@",xiao,zhong,gao];

}
#pragma mark - 性别选择
//性别选择
-(void)genderChoose:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"女" otherButtonTitles:@"男", nil];
    [action showInView:self.view.window];
}
#pragma mark - 辅导时间选择
-(void)birthdayChoose:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    TimePicker *picker=[[TimePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-220, self.view.frame.size.width, 220)];
    [picker setTimeBlock:^(NSString *time) {
        if (time) {
            _time.text=time;
        }
        
    }];
    [self.view addSubview:picker];
        
}
#pragma mark - 学历选择
//学历选择
-(void)degreeChoose:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    if (!_alertView) {
        NSArray *arr=[NSArray arrayWithObjects:@"小学",@"初中",@"高中",@"大专",@"本科",@"研究生",@"博士",@"其他社会人士", nil];
         _alertView = [[SIAlertView alloc] initWithTitle:@"学历选择" andMessage:@"请选择您的学历"];
        
       __unsafe_unretained UITextField *degText=_degree;
        for (int i=0; i<arr.count; i++) {
            [_alertView addButtonWithTitle:arr[i] type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
                degText.text=arr[i];
            }];
        }
    }
    [_alertView show];
}
#pragma mark - 辅导科目选择
//辅导科目选择
-(void)subjectInfoChoose:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
        NSArray *subject=[NSArray arrayWithObjects:@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"地理",@"历史",@"政治",@"其他", nil];
        _entriesSelected=[NSMutableArray array];
        _selectionStates=[NSMutableArray array];
        
        _picker=[[CYCustomMultiSelectPickerView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height*0.5, 320, 220)];
        _picker.entriesArray=subject;
        _picker.entriesSelectedArray=_entriesSelected;
        _picker.multiPickerDelegate=self;
    [self.view.window addSubview:_picker];
    [_picker pickerShow];
}
//获取到选中的数据
-(void)returnChoosedPickerString:(NSMutableArray *)selectedEntriesArr
{
    NSString *dataStr = [selectedEntriesArr componentsJoinedByString:@","];
    if (![dataStr isEqualToString:@""]) {
        _subjectinfo.text=dataStr;
    }
    // 再次初始化选中的数据
    _entriesSelected =selectedEntriesArr;
}

#pragma mark - 添加每条view
/*
 ********************添加每条cellView**********************
 */

-(UITextField *)addViewTitle:(NSString *)aTitle placeText:(NSString *)pText index:(int)index oHeight:(CGFloat )oh
{
    h+=oh;
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(5, index*kViewHeight+h, kViewWidth, kViewHeight);
    view.backgroundColor=[UIColor clearColor];//kSetColor(0.95, 0.95, 0.95, 0.9);
    [self.view addSubview:view];
    
    UILabel *name=[[UILabel alloc]init];
    name.text=aTitle;
    name.textColor=[UIColor blackColor];
    name.textAlignment=NSTextAlignmentLeft;
    name.font=[UIFont systemFontOfSize:kCellNameFont];
    name.frame=CGRectMake(5, 0, view.frame.size.width/4, view.frame.size.height);
    [view addSubview:name];
    
    UIView *verline=[[UIView alloc]init];
    verline.backgroundColor=kSetColor(0.88, 0.88, 0.88, 0.7);
    verline.bounds=CGRectMake(0, 0, 1, view.frame.size.height*0.5);
    verline.center=CGPointMake(CGRectGetMaxX(name.frame), view.frame.size.height*0.5);
    [view addSubview:verline];
    
    UITextField *text=[[UITextField alloc]init];
    text.frame=CGRectMake(CGRectGetMaxX(name.frame)+10, 0, view.frame.size.width*3/4, view.frame.size.height);
    text.placeholder=pText;
    text.autocapitalizationType=UITextAutocapitalizationTypeNone;
    text.font=[UIFont systemFontOfSize:kCellTextFont];
    text.delegate=self;
    text.tag=100;
    
    UIView *bar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    bar.backgroundColor=kSetColor(0.2, 0.2, 0.2, 1);
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"收起" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(shouqi:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame=CGRectMake(bar.frame.size.width-50, 0, 50, bar.frame.size.height);
    [bar addSubview:btn];
    text.inputAccessoryView=bar;
    [view addSubview:text];
    
    
    UIView *vorline=[[UIView alloc]init];
    vorline.backgroundColor=kSetColor(0.88, 0.88, 0.88, 0.5);
    vorline.frame=CGRectMake(5, view.frame.size.height-1, view.frame.size.width-10, 1);
    [view addSubview:vorline];
    
    return text;
    
}
-(void)showAlert:(NSString *)title msg:(NSString *)aMsg
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title  message:aMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.superview.frame.origin.y>self.view.frame.size.height*0.5) {
        textField.superview.layer.borderWidth=1;
        textField.superview.layer.borderColor=kSetColor(1, 0.6, 0.2, 1).CGColor;
        textField.superview.layer.cornerRadius=3;
        CGRect frame=self.view.frame;
        CGRect sender=textField.superview.frame;
        frame.origin.y-=100-(frame.size.width-CGRectGetMaxY(sender));
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=frame;
        }];
        }
    }
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.superview.layer.borderWidth=0;
    //textField.layer.cornerRadius=3;
    CGRect frame=self.view.frame;
    frame.origin.y=64;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=frame;
    }];
}

#pragma mark - actionCheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        _gender.text=@"女";
    }else if(buttonIndex ==1)
    {
        _gender.text=@"男";
    }
}
-(void)shouqi:(UIButton *)sender
{
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end
