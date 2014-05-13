//
//  MapTool.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-2-28.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "MapTool.h"
#import "NSString+Address.h"
#import "CustomSearchPaoPaoView.h"
#import "CustomPaoPaoView.h"
@implementation MapTool{
    BOOL isGeoSearch;
    BMKMapView *_mapView;
    
    NSString *_start; //起点
    NSString *_end;  //终点
    NSString *_startCity;
    NSString *_endCity;
    
    LineSearchType _lineSearchType; //查询类型
    
    //需要查询路线的用户
    User *_currentUser;
    //查询指定的教师线路
    Teacher *_currentTeacher;
    
    //地图上显示的所有教师
    NSArray *_teachers;
    
    int _type; //路径类型 <0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点 6：poi检索 7:教师 8:单独只显示位置  9：路线
    //保存路线经过的点
    CLLocationCoordinate2D lins[20];
    int linsLenght;
}


- (id)init{
    if(self = [super init]){
        _search = [[BMKSearch alloc]init];
        _search.delegate = self;
        isGeoSearch = YES;
    }
    return  self;
}


#pragma mark 移除地图上所有标注
- (void)removeAllAnnatotionFromMapView:(BMKMapView *)mapview{
    NSArray* array = [NSArray arrayWithArray:mapview.annotations];
	[mapview removeAnnotations:array];
	array = [NSArray arrayWithArray:mapview.overlays];
	[mapview removeOverlays:array];

}

//#pragma mark 显示教师位置
//- (void)showLocalTeachers:(NSArray *)teachers inMapView:(BMKMapView *)mapview{
//    [self removeAllAnnatotionFromMapView:mapview];
//    mapview.delegate = self;
//    _mapView = mapview;
//    
//    Teacher *firstTeacher = [teachers firstObject];
//    CLLocation *cll = [[CLLocation alloc]initWithLatitude:firstTeacher.latitude longitude:firstTeacher.longitude];
//    _mapView.centerCoordinate= cll.coordinate;
//    //指定地图显示区域(范围)
//    BMKCoordinateSpan span = {0.01,0.01};
//    BMKCoordinateRegion regin = {cll.coordinate, span};
//    [_mapView setRegion:regin animated:YES];
//    
//    _teachers = teachers;
//    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:42];
//    for(Teacher *teacher in _teachers){
//        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//        CLLocationCoordinate2D coor;
//        coor.latitude = teacher.latitude;
//        coor.longitude = teacher.longitude;
//        annotation.coordinate = coor;
//        annotation.title = teacher.majoraddress;
//        [annotations addObject:annotation];
//    }
//    _type = 7;
//    [_mapView addAnnotations:annotations];
//    
//    //设置默认选中
//    [_mapView selectAnnotation:[annotations firstObject] animated:YES];
//
//}	

#pragma mark 显示单个位置
- (void)showAloneWithAddress:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate inMapView:(BMKMapView *)mapview{
    [self removeAllAnnatotionFromMapView:mapview];
    mapview.delegate = self;
    _mapView = mapview;
    
    
    CLLocation *cll = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    _mapView.centerCoordinate= cll.coordinate;
    //指定地图显示区域(范围)
    BMKCoordinateSpan span = {0.003,0.003};
    BMKCoordinateRegion regin = {cll.coordinate, span};
    [_mapView setRegion:regin animated:YES];
    
    //添加标注
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = coordinate;
    annotation.title = address;
    _type = 8;
    [_mapView addAnnotation:annotation];
    [_mapView selectAnnotation:annotation animated:YES];
}

#pragma mark 根据经纬度地理编码计算出地理位置
- (void)geocodingWithAddress:(NSString *)address{
    isGeoSearch = YES; //设定为反向地理编码
    NSDictionary *dict = [NSString stringWithAddress:address];
    [_search geocode:dict[kOtherAddress] withCity:dict[kCityAddress]];
}

#pragma mark Search的回调，通过result得到编码后的结果
- (void)onGetAddrResult:(BMKAddrInfo *)result errorCode:(int)error{
    if (error == 0) {
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = result.geoPt;
		item.title = result.strAddr;
        NSString* titleStr;
        
       
        titleStr = @"正向地理编码";
        //回掉经纬度结果
        self.returnCoordinate(item.coordinate);
        
    }
}

#pragma mark 绘制图标
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    BMKAnnotationView* view = nil;
	switch (_type) {
		case 0://起点
		{
			view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"start_node"];
				view.image = [UIImage imageWithContentsOfFile:[NSString getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
            }
			view.annotation = annotation;
     
            
		}
			break;
		case 1://终点
		{
			
			
				view = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"end_node"] ;
				view.image = [UIImage imageWithContentsOfFile:[NSString getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
                //自定义教师气泡
                CustomPaoPaoView *view1 = [[CustomPaoPaoView alloc]init];
//                view1.teacher = _currentTeacher;
//                //回掉进入详情按钮
//                view1.openDetailView = ^(Teacher *teacher){
//                    self.returnSelectTeacher(teacher);
//                };
                BMKActionPaopaoView *customView = [[BMKActionPaopaoView alloc]initWithCustomView:view1];
                view.paopaoView = customView;
                view.annotation = annotation;
        }
			break;
		case 2:
		{
            static int count = 0;
			view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"bus_node"] ;
				view.image = [UIImage imageWithContentsOfFile:[NSString getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = annotation;
            count ++;
            
        }
			break;
		case 3:
		{
            static int count = 0;
			view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"rail_node"];
				view.image = [UIImage imageWithContentsOfFile:[NSString getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = annotation;
            count ++;
		}
			break;
		case 4:
		{
        
			view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"route_node"] ;
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[NSString getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = image ;
			view.annotation = annotation;
        }
			break;
        case 5:
        {
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"waypoint_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[NSString getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
			view.image =image;
			view.annotation = annotation;
        }
            break;
        case 6:
        {
            view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"waypoint_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageNamed:@"pin_normal"];
			view.image =image;
			view.annotation = annotation;
            
            //自定义气泡
            CustomSearchPaoPaoView *searchPaoPao = [[CustomSearchPaoPaoView alloc]initWithFrame:CGRectMake(0, 0, 100, 80)];
            searchPaoPao.otherAddress = [annotation title];
            searchPaoPao.cityAddress = _startCity;
            //通过回掉获取选中的位置
            searchPaoPao.changeAddress = ^(NSString *address){
                self.returnPOISelectedAddress([NSString stringWithAddress:address][kOtherAddress],[annotation coordinate]);
            };
            BMKActionPaopaoView *customView = [[BMKActionPaopaoView alloc]initWithCustomView:searchPaoPao];
            view.paopaoView = customView;
            
        }
            break;
        case 7:{
            static int i=0;
            if(i == _teachers.count){
                i = 0;
            }
            if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
                BMKPinAnnotationView *newAnnotationView= [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[NSString stringWithFormat:@"myAnnotation"]];
                
                newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
                newAnnotationView.enabled3D = YES;
                newAnnotationView.image = [UIImage imageNamed:@"pin_normal"];
                
                //自定义气泡
                CustomPaoPaoView *view1 = [[CustomPaoPaoView alloc]init];
//                view1.teacher = _teachers[i];
//                //回掉进入详情按钮
//                view1.openDetailView = ^(Teacher *detailTeacher){
//                    self.returnSelectTeacher(detailTeacher);
//                };
                BMKActionPaopaoView *customView = [[BMKActionPaopaoView alloc]initWithCustomView:view1];
                CGRect customViewRect = customView.frame;
                customViewRect.origin.x += 40;
                customView.frame = customViewRect;
                newAnnotationView.paopaoView = customView;
                i++;
                return newAnnotationView;
            }
            return nil;
        }
        case 8:{
           if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
                BMKPinAnnotationView *newAnnotationView= [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[NSString stringWithFormat:@"myAnnotation"]];
                
                newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
                newAnnotationView.enabled3D = YES;
                newAnnotationView.image = [UIImage imageNamed:@"pin_normal"];
                return newAnnotationView;
            }
            return nil;
        }

		default:
			break;
	}
	
	return view;

}

#pragma mark 绘制遮盖物
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark 进行POI检索
- (void)searchPOIWithAddress:(NSString *)address inMapView:(BMKMapView *)mapView{
    
     mapView.delegate = self;
    _mapView = mapView;
    _search.delegate = self;
    _startCity = [NSString stringWithAddress:address][kCityAddress];
   
    [_search poiSearchInCity:_startCity withKey:[NSString stringWithAddress:address][kOtherAddress] pageIndex:0];
}

//#pragma mark 查询线路
//- (void)lineSearchWithSerrchType:(LineSearchType)lineSearchType customer:(User *)customer toTeacher:(Teacher *)teacher inMapView:(BMKMapView *)mapView{
//    //调整地图显示比例
//    CLLocation *cll = [[CLLocation alloc]initWithLatitude:customer.latitude longitude:customer.longitude];
//    _mapView.centerCoordinate= cll.coordinate;
//    //指定地图显示区域(范围)
//    BMKCoordinateSpan span = {0.03,0.03};
//    BMKCoordinateRegion regin = {cll.coordinate, span};
//    [_mapView setRegion:regin animated:YES];
//
//    [self removeAllAnnatotionFromMapView:mapView];
//    _mapView = mapView;
//    _mapView.delegate = self;
//    _lineSearchType = lineSearchType;
//    _currentTeacher = teacher;
//    _currentUser = customer;
//    
//    //将地址信息解析成为单独信息
//    NSDictionary *startAddress = [NSString stringWithAddress:_currentUser.majoraddress];
//    NSDictionary *endAddress = [NSString stringWithAddress:_currentTeacher.majoraddress];
//    _startCity = [NSString stringWithFormat:@"%@",startAddress[kCityAddress]];
//    _start = startAddress[kOtherAddress];
//    _endCity = _startCity;
//    _end = endAddress[kOtherAddress];
//    
//    switch (lineSearchType) {
//        case kWalkSearch:{ //步行线路查询
//            [self walkSearch];
//        }
//            break;
//            
//        case kBusLineSearch:{ //公交线路查询
//            [self busSearch];
//        }
//            break;
//        default:
//            break;
//    }
//}

#pragma mark 步行路线查询
- (void)walkSearch{
    
    _search.delegate = self;
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
	start.name = _start;
	BMKPlanNode* end = [[BMKPlanNode alloc]init] ;
	end.name = _end;
	BOOL flag = [_search walkingSearch:_startCity startNode:start endCity:_endCity endNode:end];
    if (flag) {
		NSLog(@"步行路线查询失败");
	}
    else{
        NSLog(@"步行路线查询成功");
    }
}

#pragma mark 公交路线查询
- (void)busSearch{
    _search.delegate = self;
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
	start.name = _start;
	BMKPlanNode* end = [[BMKPlanNode alloc]init] ;
	end.name = _end;
    
	BOOL flag = [_search transitSearch:_startCity startNode:start endNode:end];
	if (flag) {
		NSLog(@"search success.");
	}
    else{
        NSLog(@"search failed!");
    }

}

#pragma mark poi检索结果
- (void)onGetPoiResult:(BMKSearch *)searcher result:(NSArray *)poiResultList searchType:(int)type errorCode:(int)error{
    if (error == BMKErrorOk) {
        _mapView.delegate = self;
        BMKPoiResult* result = [poiResultList objectAtIndex:0];
        //设置地图属性
        BMKPoiInfo *info = result.poiInfoList[0];
        
        CLLocation *cll = [[CLLocation alloc]initWithLatitude:info.pt.latitude longitude:info.pt.longitude];
        _mapView.centerCoordinate= cll.coordinate;
        //指定地图显示区域(范围)
        BMKCoordinateSpan span = {0.003,0.003};
        BMKCoordinateRegion regin = {cll.coordinate, span};
        [_mapView setRegion:regin animated:YES];
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            _type = 6;
            [_mapView addAnnotation:item];
        }
    }else{
        CLLocationCoordinate2D coordinate;
        self.returnPOISelectedAddress(nil,coordinate);
    }

}
//- (void)onGetPoiResult:(NSArray *)poiResultList searchType:(int)type errorCode:(int)error{
//    }

#pragma mark 步行路线查询结果
- (void)onGetWalkingRouteResult:(BMKPlanResult *)result errorCode:(int)error{
    
    if (error == BMKErrorOk) {
        //实例化路线经过点数组
        lins[20] = {0};
        
        BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
        
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = result.startNode.pt;
       
		item.title = @"起点";
        _type = 0;
		[_mapView addAnnotation:item];
		
		
		int index = 0;
		int size = [plan.routes count];
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				index += len;
			}
		}
		
		BMKMapPoint* points = new BMKMapPoint[index];
        index = 0;
		
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
				index += len;
			}
			size = route.steps.count;
			for (int j = 0; j < size; j++) {
				BMKStep* step = [route.steps objectAtIndex:j];
				item = [[BMKPointAnnotation alloc]init];
				item.coordinate = step.pt;
             
				item.title = step.content;
				_type = 4;
                [_mapView addAnnotation:item];
               
			}
        }
		
		item = [[BMKPointAnnotation alloc]init];
		item.coordinate = result.endNode.pt;
   
        _type = 1;
		item.title = @"终点";
		[_mapView addAnnotation:item];
	
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
		[_mapView addOverlay:polyLine];
		delete []points;
        [_mapView setCenterCoordinate:result.startNode.pt animated:YES];
  
    }
}


#pragma mark 公交路线查询结果
- (void)onGetTransitRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
    if (error == BMKErrorOk) {
		
        //实例化路线经过点数组
        lins[20] = {0};
        
        BMKTransitRoutePlan* plan = (BMKTransitRoutePlan*)[result.plans objectAtIndex:0];
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = plan.startPt;
		item.title = @"起点";
		_type = 0;
		[_mapView addAnnotation:item]; // 添加起点标注
		
        
		item = [[BMKPointAnnotation alloc]init];
		item.coordinate = plan.endPt;
		_type = 1;
		item.title = @"终点";
		[_mapView addAnnotation:item]; // 终点标注
		
		
        // 计算路线方案中的点数
		int size = [plan.lines count];
		int planPointCounts = 0;
		for (int i = 0; i < size; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				planPointCounts += len;
			}
			BMKLine* line = [plan.lines objectAtIndex:i];
			planPointCounts += line.pointsCount;
			if (i == size - 1) {
				i++;
				route = [plan.routes objectAtIndex:i];
				for (int j = 0; j < route.pointsCount; j++) {
					int len = [route getPointsNum:j];
					planPointCounts += len;
				}
				break;
			}
		}
		
        // 构造方案中点的数组，用户构建BMKPolyline
		BMKMapPoint* points = new BMKMapPoint[planPointCounts];
		planPointCounts = 0;
		
        // 查询队列中的元素，构建points数组，并添加公交标注
		for (int i = 0; i < size; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + planPointCounts, pointArray, len * sizeof(BMKMapPoint));
				planPointCounts += len;
			}
			BMKLine* line = [plan.lines objectAtIndex:i];
			memcpy(points + planPointCounts, line.points, line.pointsCount * sizeof(BMKMapPoint));
			planPointCounts += line.pointsCount;
			
			item = [[BMKPointAnnotation alloc]init];
			item.coordinate = line.getOnStopPoiInfo.pt;
			item.title = line.tip;
			if (_type == 0) {
				_type = 2;
			} else {
				_type = 3;
			}
			
			[_mapView addAnnotation:item]; // 上车标注
			
			route = [plan.routes objectAtIndex:i+1];
			item = [[BMKPointAnnotation alloc]init];
			item.coordinate = line.getOffStopPoiInfo.pt;
			item.title = route.tip;
			if (_type == 0) {
				_type = 2;
			} else {
				_type = 3;
			}
			[_mapView addAnnotation:item]; // 下车标注
			
			if (i == size - 1) {
				i++;
				route = [plan.routes objectAtIndex:i];
				for (int j = 0; j < route.pointsCount; j++) {
					int len = [route getPointsNum:j];
					BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
					memcpy(points + planPointCounts, pointArray, len * sizeof(BMKMapPoint));
					planPointCounts += len;
				}
				break;
			}
		}
        
        // 通过points构建BMKPolyline
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:planPointCounts];
		[_mapView addOverlay:polyLine]; // 添加路线overlay
		delete []points;
        
        [_mapView setCenterCoordinate:result.startNode.pt animated:YES];
	}
}

#pragma mark 添加自定义遮盖
- (void)addCutomerLine:(CLLocationCoordinate2D )coordinate{
    
}

-(void)dealloc{
    _search.delegate = nil;
    _mapView.delegate = nil;
}

@end
