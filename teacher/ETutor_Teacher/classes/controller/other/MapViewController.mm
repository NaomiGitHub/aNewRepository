//
//  MapViewController.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-2-28.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "MapViewController.h"

#import "CustomPaoPaoView.h"
#import "SwitchMapTypeView.h"
#import "LineSearchView.h"
#import "MapTool.h"
#import "UIImage+Size.h"
#import "PXAlertView.h"

#define kSwitchButWidth 70
#define kSwitchButHeight 25
#define kSwitchMapViewWidth (self.view.frame.size.width * 0.5)
#define kSwitchMapViewHeight frame.size.height
#define kLineSearchViewWidth 320
#define kLineSearchViewHeight 130

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface MapViewController (){
    BMKMapView *_mapView;
    BOOL _isReload;
    SwitchMapTypeView *_switchTypeView;
    BOOL _isOpenListView;
    BOOL _isOpenSearchView;
   
    LineSearchView *_lineSearchView; //路线查询view
    
    int _type;  //  -1:无类型  路径类型 <0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点 6：poi检索
    
    MapTool *_maptool;
    UIStepper *stepper;
    
    int stepperCount;
    double currentCount;
}


@end

@implementation MapViewController
- (id)init
{
    self = [super init];
    if (self) {
        
        //取消导航栏遮盖
        kNavigationBarFit(self);
        //_mapView的基本设置
        _mapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
        _mapView.delegate = self;
        //设置为3D效果
        _mapView.rotation = 90;
        _mapView.overlooking = -30;
        [self createStepper];
        [self.view addSubview:_mapView];
    }
    return self;
}

#pragma mark 初始化地图，中心点已经显示区域
- (id)initWithLatitude:(float)latitude longitude:(float)longitude distance:(int)distance{
    if (self = [super init]) {
        // Custom initialization
       
        //取消导航栏遮盖
        kNavigationBarFit(self);
        self.navigationItem.title = @"地 图 展 示";
        //_mapView的基本设置
        _mapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
        _mapView.delegate = self;
        //设置为3D效果
        _mapView.rotation = 90;
        _mapView.overlooking = -30;

       
        self.latitude = latitude;
        self.longitude = longitude;
        
        [self.view addSubview:_mapView];
        
        //默认type类型为-1，不搜索线路
        self.type=-1;
        
//        [self addControl];
    }
    return self;
}

#pragma mark 创建strpper
- (void)createStepper{
    stepper = [[UIStepper  alloc]init];
    stepper.frame = CGRectMake(10, self.view.frame.size.height*0.65, 60,120);
    stepper.backgroundColor =kSetColor(44, 181, 255 , 1);
    [stepper addTarget:self action:@selector(changeMapSize:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:stepper];
    
    stepperCount = 0;
}

- (void)changeMapSize:(UIStepper *)ste{
    double value = 0;
    if(!currentCount){
        value  = _mapView.region.span.latitudeDelta;
        currentCount = value;
    }else{
        value = currentCount;
    }
    
    if(ste.value>stepperCount){
        if(value <= 0)return;
        value-=0.005;
    }else{
        value+=0.005;
    }
    currentCount = value;
   
    //指定地图显示区域(范围)
    BMKCoordinateSpan span = {value,value};
    BMKCoordinateRegion regin = {_mapView.centerCoordinate , span};
    [_mapView setRegion:regin animated:YES];

    stepperCount = ste.value;
}
//#pragma mark 添加控件
//- (void)addControl{
//    CGRect frame = self.view.frame;
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回列表" style:UIBarButtonItemStyleBordered target:self action:@selector(switchListView)];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"功能" style:UIBarButtonItemStyleBordered target:self action:@selector(opinitonList)];
//
//    
//    //切换地图类型view
//    SwitchMapTypeView *switchTypeView = [[SwitchMapTypeView alloc]initWithFrame:CGRectMake(frame.size.width-kSwitchMapViewWidth, -kNavBarHeight , kSwitchMapViewWidth, kSwitchMapViewHeight)];
//    switchTypeView.switchMapType = ^(MapType maptype){
//        [self switchMapType:maptype];
//    };
//    _switchTypeView = switchTypeView;
//    [self.view addSubview:_switchTypeView];
//    
//    //默认不推出
//    CGRect switchViewframe = _switchTypeView.frame;
//    switchViewframe.origin.x += kSwitchMapViewWidth;
//    _switchTypeView.frame = switchViewframe;
//    _isOpenListView = NO;
//    
//    
//    //实例化路线查询view
//    LineSearchView *lineSearchView = [[LineSearchView alloc]initWithFrame:CGRectMake(frame.size.width/2 - kLineSearchViewWidth/2, -kLineSearchViewHeight-10 , kLineSearchViewWidth, kLineSearchViewHeight)];
//    //监听代码快的回掉执行路线查询
//    lineSearchView.searchLine = ^(LineSearchType searchType,Teacher *teacher){
//        //关闭选择框
//        [self closeSearch];
//        [self searchLineWithSearchType:searchType toTeacher:teacher];
//    };
//    _lineSearchView = lineSearchView;
//    [self.view addSubview:_lineSearchView];
//    //默认不打开
//    _isOpenSearchView = NO;
//    
//    //创建地图工具
//    MapTool *maptool = [[MapTool alloc]init];
//    //通过代码快接受用户选择的地理位置为起始点
//    maptool.returnSearchStartAddress = ^(NSString *startAddress){
//        _lineSearchView.startAddress = startAddress;
//    };
//    
//    //通过代码快回掉进入教师详情界面
//    maptool.returnSelectTeacher = ^(Teacher *selectTeacher){
//        [self openTeacherDetail:selectTeacher];
//        
//    };
//    _maptool = maptool;
//    
//    [self createStepper];
//}

#pragma mark 显示单个位置
- (void)showOrderWithAddress:(NSString *)address latitude:(float)latitude longitude:(float)longitude{
    // Custom initialization
    MapTool *maptool = [[MapTool alloc]init];
    //取消导航栏遮盖
    kNavigationBarFit(self);
    self.navigationItem.title = @"授 课 地 址";
    //_mapView的基本设置
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
    _mapView.delegate = self;
    //设置为3D效果
    _mapView.rotation = 90;
    _mapView.overlooking = -30;
    
    
    self.latitude = latitude;
    self.longitude = longitude;
    
    [self.view addSubview:_mapView];
    //构建coorinate
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    [maptool showAloneWithAddress:address coordinate:coordinate inMapView:_mapView];
}

#pragma mark 查询路线
- (void)searchLineWithSearchType:(LineSearchType)searchType toTeacher:(Teacher *)teacher{
    [_maptool lineSearchWithSerrchType:searchType customer:self.user toTeacher:teacher inMapView:_mapView];
}

#pragma mark -列表的推出与收回
- (void)opinitonList{
    if(_isOpenListView){
        [self closeListView];
    }else{
        [self openListView];
    }
    if(_lineSearchView.isOpenAddressList){
        _lineSearchView.isOpenAddressList = NO;
    }
    _isOpenListView = !_isOpenListView;
}

#pragma mark 列表的收回
- (void)closeListView{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect switchViewframe = _switchTypeView.frame;
        switchViewframe.origin.x += kSwitchMapViewWidth;
        _switchTypeView.frame = switchViewframe;
        
        CGRect frame = _mapView.frame;
        frame.origin.x += kSwitchMapViewWidth;
        _mapView.frame = frame;
        
        
        CGRect searchFrame = _lineSearchView.frame;
        searchFrame.origin.x += kSwitchMapViewWidth;
        //判断搜索框是否需要打开
        if(_isOpenSearchView){
             searchFrame.origin.y += kLineSearchViewHeight;
            _isOpenSearchView = YES;
        }
        _lineSearchView.frame = searchFrame;
        
        CGRect barFrame = self.navigationController.navigationBar.frame;
        barFrame.origin.x += kSwitchMapViewWidth;
        self.navigationController.navigationBar.frame =barFrame;

    }];
}
#pragma mark 列表的推出
- (void)openListView{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect switchViewframe = _switchTypeView.frame;
        switchViewframe.origin.x -= kSwitchMapViewWidth;
        _switchTypeView.frame = switchViewframe;
        
        CGRect searchFrame = _lineSearchView.frame;
        searchFrame.origin.x -= kSwitchMapViewWidth;
        //判断搜索框是否需要收回
        if(_isOpenSearchView){
            searchFrame.origin.y -= kLineSearchViewHeight;
            _isOpenSearchView = NO;
        }
        _lineSearchView.frame = searchFrame;

        
        CGRect frame = _mapView.frame;
        frame.origin.x -= kSwitchMapViewWidth;
        _mapView.frame = frame;
        
        CGRect barFrame = self.navigationController.navigationBar.frame;
        barFrame.origin.x -= kSwitchMapViewWidth;
        self.navigationController.navigationBar.frame =barFrame;
    } ];
}

#pragma mark 搜索框的弹出
- (void)openSearch{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _lineSearchView.frame;
        frame.origin.y += kLineSearchViewHeight;
        _lineSearchView.frame = frame;
    }];
    _isOpenSearchView = YES;
}
#pragma mark 搜索框的收回
- (void)closeSearch{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _lineSearchView.frame;
        frame.origin.y -= kLineSearchViewHeight;
        _lineSearchView.frame = frame;
    }];
    _isOpenSearchView = NO;
}

#pragma mark 切换地图样式
- (void)switchMapType:(MapType)maptype{
    switch (maptype) {
        case kMapStandard:
            [_mapView setMapType:BMKMapTypeStandard];
            break;
        case kMapSatellite:
            [_mapView setMapType:BMKMapTypeSatellite];
            break;
        case kMapTrafficOn:
            [_mapView setMapType:BMKMapTypeTrafficOn];
            break;
        case kMapBusLines:{
            _isOpenSearchView = YES;
            //显示提示框，提示用户选择最近位置标注
//            [self showHint];
        }
            break;
        case kNormal:
            //重写调用setTeacher显示正常教师位置
            self.teachers = self.teachers;
            break;
        default:
            break;
    }
    //回收view
    [self closeListView];
    _isOpenListView = NO;
}

#pragma mark 显示提示框，提示用户选择最近位置标注并进行poi检索获取附近详细地理位置
//- (void)showHint{
//    //判断用户是否又地址信息
//    //显示地址
//    _lineSearchView.startAddress = self.user.majoraddress;
//}

#pragma mark 切换试图为列表
- (void)switchListView{
   [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

//#pragma mark 显示教师多个地理位置
//- (void)setTeachers:(NSArray *)teachers{
//    _lineSearchView.teacherAddressList.teachers = teachers;
//    _teachers = teachers;
//    [_maptool showLocalTeachers:teachers inMapView:_mapView];
//   
//}

#pragma mark 进行poi检索

- (void)poiSearchWithAddress:(NSString *)address{
   
    self.navigationItem.title = @"选择您的地址";
    MapTool *tool = [[MapTool alloc]init];
    [tool searchPOIWithAddress:address inMapView:_mapView];
    tool.returnPOISelectedAddress = ^(NSString *searchAddress , CLLocationCoordinate2D coorinate ){
        if(!searchAddress || [searchAddress isEqualToString:@""]){
            [PXAlertView showAlertWithTitle:@"提示" message:@"地址检索失败，请输入正确地地址" cancelTitle:@"知道了" completion:^(BOOL cancelled) {
                if(cancelled){
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
          
            return ;
        }
        [self.navigationController popViewControllerAnimated:YES];
         self.returnPOIResultAddress(searchAddress,coorinate);
    };
    _maptool = tool;
}

/**
 *点中底图标注后会回调此接口
 *@param mapview 地图View
 *@param mapPoi 标注点信息
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi{
    NSLog(@"%@",mapPoi.text);
    _lineSearchView.endAddress = mapPoi.text;
}


//
//#pragma mark 进入详情
//- (void)openTeacherDetail:(Teacher *)teacher{
//    TeacherDetailViewController *detail = [[TeacherDetailViewController alloc]init];
//    detail.teacherid = teacher.teacherId;
//    [self presentViewController:detail animated:YES completion:nil];
//    
//}
@end
