//
//  NewFeatureViewController.h
//  ETutor_Teacher
//
//  Created by ibokan on 14-2-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFeatureViewController : UIViewController
@property(strong,nonatomic)void (^start)();
@property(nonatomic)int pageCount;
@end
