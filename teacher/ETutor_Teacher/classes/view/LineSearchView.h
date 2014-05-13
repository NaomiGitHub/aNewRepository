//
//  LineSearchView.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-4.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TeacherAddressTableView,Teacher;
@interface LineSearchView : UIImageView
//点击路线查询后通过代码快回掉给控制器,参数一：查询类型，参数二：查询教师
@property (nonatomic , copy)void (^searchLine)(LineSearchType lineType,Order *order);
@property (nonatomic , copy)NSString *startAddress;//起点
@property (nonatomic , copy)NSString  *endAddress; //终点

@property (nonatomic , assign)BOOL isOpenAddressList;
@end
