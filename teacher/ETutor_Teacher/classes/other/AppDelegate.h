//
//  AppDelegate.h
//  ETutor_Teacher
//
//  Created by 张鼎辉 on 14-2-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKMapManager.h"
#import "BMKGeneralDelegate.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>{
    BMKMapManager *_manager;
}

@property (strong, nonatomic) UIWindow *window;

@end
