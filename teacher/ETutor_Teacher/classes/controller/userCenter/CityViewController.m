//
//  CityViewController.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-25.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "CityViewController.h"
#import "HZAreaPickerView.h"
#import "PerfectViewController.h"
#import "MapViewController.h"
#import "PXAlertView.h"
#import "MapTool.h"
#define kBorder 10
#define kTextH  44
#define kFont 16
@interface CityViewController ()<HZAreaPickerDelegate,UITextFieldDelegate>
{
    NSArray *_provinces,*_cities,*_areas;
    NSString *_state,*_aCity,*_district;
    HZAreaPickerView *_areaPicker;
    PerfectViewController *_perfect;
    MapTool *_tool;
    BOOL isPOI;
}
@end

@implementation CityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithBlock:(addressBlock)block
{
    if (self=[super init]) {
        self.block=block;
        self.title=@"请选择/填写地址";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submitInfo)];
    self.navigationItem.rightBarButtonItem=right;
    self.view.backgroundColor=kSetColor(0.98, 0.98, 0.98, 1);
    [self addSubView];
}
-(void)addSubView
{
    self.city=[self createText:@"城市" isEdit:NO index:0];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseCity:)];
    [self.city.superview addGestureRecognizer:tap];
    
    self.street=[self createText:@"街道" isEdit:YES index:1];
}
-(UITextField *)createText:(NSString *)title isEdit:(BOOL)edit index:(int)index
{
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(kBorder, kBorder*2+index*kTextH, self.view.frame.size.width-2*kBorder, kTextH);
    [self.view addSubview:view];
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width*0.2, view.frame.size.height)];
    lbl.text=title;
    lbl.font=[UIFont systemFontOfSize:kFont];
    lbl.textColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    [view addSubview:lbl];
    
    UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbl.frame), 0, view.frame.size.width*0.8, kTextH)];
    text.userInteractionEnabled=edit;
    text.delegate=self;
    text.font=[UIFont systemFontOfSize:kFont];
    text.placeholder= index==0?@"点击选择城市":@"请输入街道地址";
    [view addSubview:text];
    
    UIImageView *line=[[UIImageView alloc]init];
    line.frame=CGRectMake(0, view.frame.size.height-2, view.frame.size.width, 2);
    line.image=[UIImage imageNamed:@"line.png"];
    [view addSubview:line];
    return text;
}
-(void)chooseCity:(UITapGestureRecognizer *)sender
{
    _areaPicker=[[HZAreaPickerView alloc]initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
    [_areaPicker showInView:self.view];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [_areaPicker cancelPicker];
    _areaPicker.delegate=nil;
    _areaPicker=nil;
}
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    self.city.text=[NSString stringWithFormat:@"%@ %@ %@",picker.locate.state,picker.locate.city,picker.locate.district];
}
-(void)submitInfo
{
    if ([self.city.text isEqualToString:@""]||[self.street.text isEqualToString:@""]) {
        return;
    }
    NSString *address=[NSString stringWithFormat:@"%@%@" , self.city.text,self.street.text];
    if(isPOI){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    MapViewController *mapVC = [[MapViewController alloc]init];
    [mapVC poiSearchWithAddress:address];
    mapVC.returnPOIResultAddress = ^(NSString *addressed,CLLocationCoordinate2D coordinate){
        if(coordinate.latitude == 0 || coordinate.longitude == 0){
            [PXAlertView showAlertWithTitle:@"检索失败，请输入正确街道地址"];
            return ;
        }
        NSArray *array = [address componentsSeparatedByString:@" "];
        NSString *newAddress = [NSString stringWithFormat:@"%@ %@ %@",array[0],array[1],addressed];
        self.street.text = addressed;
        self.block(newAddress,coordinate);
        isPOI = YES;
        return;
    };
    [self.navigationController pushViewController:mapVC animated:YES];

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_areaPicker cancelPicker];
    _areaPicker.delegate=nil;
    _areaPicker=nil;
}
@end
