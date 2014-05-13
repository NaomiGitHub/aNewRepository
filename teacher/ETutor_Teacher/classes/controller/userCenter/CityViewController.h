//
//  CityViewController.h
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-25.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^addressBlock)(NSString *addr,CLLocationCoordinate2D coordinate);

@interface CityViewController : UIViewController

@property(nonatomic,strong)UITextField *street;
@property(nonatomic,strong)UITextField *city;
@property(strong,nonatomic)addressBlock block;;

-(id)initWithBlock:(addressBlock)block;
@end
