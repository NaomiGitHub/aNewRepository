//
//  TeacherUser.h
//  ETutor_Teacher
//
//  Created by fengpengfei on 14-2-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TeacherUser : NSObject<NSCoding>
@property (copy,nonatomic)NSString *icon;
@property (copy, nonatomic) NSString *teacherid;//教师id；
@property (copy, nonatomic) NSString *username; //用户名
@property (copy, nonatomic) NSString *name;     //教师姓名；
@property (copy, nonatomic) NSString *birthday;//生日；
@property (copy, nonatomic) NSString *gender;  //性别；
@property (copy, nonatomic) NSString *identity;//身份证号；
@property (copy, nonatomic) NSString *qq;      //QQ;
@property (copy, nonatomic) NSString *sinaweibo;//新浪微博；
@property (copy, nonatomic) NSString *telephone;//电话；
@property (copy, nonatomic) NSString *degree;   //学历；
@property (copy, nonatomic) NSString *timepriod;//辅导时间；
@property (copy, nonatomic) NSString *objectinfo;//辅导对象信息；
@property (copy, nonatomic) NSString *subjectinfo;//科目信息；
@property (copy, nonatomic) NSString *memo;       //备注信息；
@property (copy, nonatomic) NSString *majoraddress;//注册地址；
@property (nonatomic) double latitude;    //经度；
@property (nonatomic) double longitude;   //维度；
@property (nonatomic) int rank;
-(TeacherUser *)initWithDict:(NSDictionary *)dic;
@end
