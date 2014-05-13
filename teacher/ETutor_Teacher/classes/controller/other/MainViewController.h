//
//  MainViewController.h
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-14.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property(copy,nonatomic)void (^btnClickBlock)(int tag);

@end
