//
//  PerfectViewController.h
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-6.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherUser.h"

@interface PerfectViewController : UIViewController
@property(strong,nonatomic)TeacherUser *teacher;
@property(copy,nonatomic)NSString  *addr;

@end
