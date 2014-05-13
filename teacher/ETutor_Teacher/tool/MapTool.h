//
//  MapTool.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-2-28.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//  地图有关信息的工具类

#import <Foundation/Foundation.h>
@class  Teacher,User;
@interface MapTool : NSObject<BMKSearchDelegate,BMKMapViewDelegate>{
    BMKSearch* _search;
}
//使用代码快回掉经纬度结果
@property (nonatomic , copy)void (^returnCoordinate)(CLLocationCoordinate2D);
//使用代码快回调地址信息结果
@property (nonatomic , copy)void (^returnAddress)(NSString *);
//使用代码块回调选中搜索启示点
@property (nonatomic , copy)void (^returnSearchStartAddress)(NSString *);
//使用代码快回掉选中的教师
@property (nonatomic , copy)void (^returnSelectTeacher)(Teacher *teacher);
//使用代码快回电poi选中的位置
@property (nonatomic , copy)void (^returnPOISelectedAddress)(NSString *,CLLocationCoordinate2D);


//地理编码
- (void)geocodingWithAddress:(NSString *)address;

//查询指定线路，并显示到指定view中
- (void)	lineSearchWithSerrchType:(LineSearchType)lineSearchType customer:(User *)customer toTeacher:(Teacher *)teacher inMapView:(BMKMapView *)mapView;

//进行poi检索
- (void)searchPOIWithAddress:(NSString *)address inMapView:(BMKMapView *)mapView;

//显示多个教师位置
- (void)showLocalTeachers:(NSArray *)teachers inMapView:(BMKMapView *)mapview;

//显示单个位置
- (void)showAloneWithAddress:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate inMapView:(BMKMapView *)mapview;
@end
