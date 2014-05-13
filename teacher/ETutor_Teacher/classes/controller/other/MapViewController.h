//
//  MapViewController.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-2-28.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKMapView.h"
#import "BMKPointAnnotation.h"
#import "BMKPinAnnotationView.h"
@class  User;
@interface MapViewController : UIViewController<BMKMapViewDelegate>

//显示教师多个地理位置


@property (nonatomic , assign)float latitude;
@property (nonatomic , assign)float longitude;
@property (nonatomic , assign)User *user;
@property (nonatomic ,strong)NSArray *teachers;
@property (nonatomic , assign)int type;
@property (nonatomic , copy)void (^returnPOIResultAddress)(NSString *resultAddress,CLLocationCoordinate2D coordinate);
//以自己为中心点显示地图
- (id)initWithLatitude:(float)latitude longitude:(float)longitude distance:(int)distance;
////根据位置进行poi检索
- (void)poiSearchWithAddress:(NSString *)address;
//显示指定一点的位置
- (void)showOrderWithAddress:(NSString *)address latitude:(float)latitude longitude:(float)longitude;
@end
