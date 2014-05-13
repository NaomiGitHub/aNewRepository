//
//  SysSettingViewController.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-12.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "SysSettingViewController.h"
#define kBorderWidth 10
#define kCellHeight 49
@interface SysSettingViewController ()
{
    CGFloat otherHeight;
    
    UISwitch *_msgNoti;
    UISwitch *_telRec;
    UISwitch *_mapLoc;
    UISwitch *_wifiUse;
    UISwitch *_clearCatch;
    int k;
}
@end

@implementation SysSettingViewController


- (void)viewDidLoad
{
    self.title=@"系统设置";
    [super viewDidLoad];
    self.view.backgroundColor=kSetColor(0.9, 0.9, 0.9, 1);
    // Do any additional setup after loading the view from its nib.
    _msgNoti=[self cellViewWithTitle:@"消息提醒" index:k++ otherHeight:20];
    _msgNoti.on=[[NSUserDefaults standardUserDefaults]boolForKey:kMsgNoti];
    _telRec=[self cellViewWithTitle:@"电话接听" index:k++ otherHeight:0];
    _telRec.on=[[NSUserDefaults standardUserDefaults]boolForKey:kTelRec];
    _mapLoc=[self cellViewWithTitle:@"开启定位"index:k++ otherHeight:20];
    _mapLoc.on=[[NSUserDefaults standardUserDefaults]boolForKey:kMapLoc];
    _wifiUse=[self cellViewWithTitle:@"仅在WiFi下使用地图" index:k++ otherHeight:0];
    _wifiUse.on=[[NSUserDefaults standardUserDefaults]boolForKey:kWifiUse];
    _clearCatch=[self cellViewWithTitle:@"手动清理缓存" index:k++ otherHeight:20];
    _clearCatch.on=[[NSUserDefaults standardUserDefaults]boolForKey:kClearCatch];
}
-(UISwitch *)cellViewWithTitle:(NSString *)title index:(int)index otherHeight:(CGFloat)oh
{
    otherHeight+=oh;
    UIView  *cell=[[UIView alloc]init];
    cell.backgroundColor=kSetColor(0.98, 0.98, 0.98, 1);
    cell.frame=CGRectMake(kBorderWidth, index*kCellHeight+otherHeight, self.view.frame.size.width-kBorderWidth*2, kCellHeight);
    cell.layer.borderWidth=0.5;
    cell.layer.cornerRadius=3;
    cell.layer.borderColor=kSetColor(0.8, 0.8, 0.8, 1).CGColor;
    [self.view addSubview:cell];
    UILabel *lbl=[[UILabel alloc]init];
    lbl.bounds=CGRectMake(0, 0, cell.frame.size.width*3/4, cell.frame.size.height);
    lbl.center=CGPointMake(cell.frame.size.width*3/8+5, cell.frame.size.height*0.5);
    lbl.text=title;
    [cell addSubview:lbl];
    
    UISwitch *sw=[[UISwitch alloc]init];
    sw.bounds=CGRectMake(0, 0, cell.frame.size.width/4, cell.frame.size.height);
    sw.center=CGPointMake(cell.frame.size.width*7/8, cell.frame.size.height*0.5+5);
    [sw addTarget:self action:@selector(setting:) forControlEvents:UIControlEventValueChanged];
    
    [cell addSubview:sw];
    return sw;
}
-(void)setting:(UISwitch *)sender
{
    if (sender==_msgNoti) {
        [[NSUserDefaults standardUserDefaults] setBool:_msgNoti.on forKey:kMsgNoti];
    }else if (sender==_telRec)
    {
        [[NSUserDefaults standardUserDefaults] setBool:_telRec.on forKey:kTelRec];
    }else if (sender==_mapLoc)
    {
        [[NSUserDefaults standardUserDefaults] setBool:_mapLoc.on forKey:kMapLoc];
    }else if (sender==_wifiUse)
    {
        [[NSUserDefaults standardUserDefaults] setBool:_wifiUse.on forKey:kWifiUse];

    }else if (sender==_clearCatch)
    {
        [[NSUserDefaults standardUserDefaults] setBool:_clearCatch.on forKey:kClearCatch];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
