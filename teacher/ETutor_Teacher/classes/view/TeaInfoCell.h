//
//  TeaInfoCell.h
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-18.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TeaInfoCell : UITableViewCell
@property(strong,nonatomic)UILabel *title;
@property(strong,nonatomic)UILabel *info;
@property(strong,nonatomic)NSDictionary *teaInfo;
@end
