//
//  SwitchMapTypeView.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-4.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchMapTypeView : UIImageView
@property (nonatomic , copy)void (^switchMapType)(MapType maptype);
@end
