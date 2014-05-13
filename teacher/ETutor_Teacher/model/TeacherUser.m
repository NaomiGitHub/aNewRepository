//
//  TeacherUser.m
//  ETutor_Teacher
//
//  Created by fengpengfei on 14-2-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "TeacherUser.h"
#import "MapViewController.h"
#import "MapTool.h"

@implementation TeacherUser
-(TeacherUser *)initWithDict:(NSDictionary *)dic;
{
    if (self == [super init]) {
        self.icon=[dic objectForKey:@"teachericon"];
        self.teacherid = [dic objectForKey:@"teacherid"];
        self.name = [dic objectForKey:@"name"];
        self.birthday = [dic objectForKey:@"birthday"];
        self.gender = [dic objectForKey:@"gender"];
        self.identity = [dic objectForKey:@"identity"];
        self.qq = [dic objectForKey:@"qq"];
        self.sinaweibo = [dic objectForKey:@"sinaweibo"];
        self.telephone = [dic objectForKey:@"telephone"];
        self.degree = [dic objectForKey:@"degree"];
        self.timepriod = [dic objectForKey:@"timeperiod"];
        self.objectinfo = [dic objectForKey:@"objectinfo"];
        self.subjectinfo = [dic objectForKey:@"subjectinfo"];
        self.memo = [dic objectForKey:@"memo"];
        self.majoraddress = [dic objectForKey:@"majoraddress"];
        self.latitude = [[dic objectForKey:@"latitude"] doubleValue];
        self.longitude = [[dic objectForKey:@"longitude"] doubleValue];
     }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.teacherid =[aDecoder decodeObjectForKey:@"teacherid"];
        self.name =[aDecoder decodeObjectForKey:@"name"];
        self.birthday =[aDecoder decodeObjectForKey:@"birthday"];
        self.gender =[aDecoder decodeObjectForKey:@"gender"];
        self.identity =[aDecoder decodeObjectForKey:@"identity"];
        self.qq =[aDecoder decodeObjectForKey:@"qq"];
        self.sinaweibo =[aDecoder decodeObjectForKey:@"sinaweibo"];
        self.telephone =[aDecoder decodeObjectForKey:@"telephone"];
        self.degree =[aDecoder decodeObjectForKey:@"degree"];
        self.timepriod =[aDecoder decodeObjectForKey:@"timepriod"];
        self.objectinfo =[aDecoder decodeObjectForKey:@"objectinfo"];
        self.subjectinfo =[aDecoder decodeObjectForKey:@"subjectinfo"];
        self.memo =[aDecoder decodeObjectForKey:@"memo"];
        self.majoraddress=[aDecoder decodeObjectForKey:@"majoraddress"];
        self.latitude =[[aDecoder decodeObjectForKey:@"latitude"]doubleValue];
        self.longitude =[[aDecoder decodeObjectForKey:@"longitude"]doubleValue];
        
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.teacherid forKey:@"teacherid"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.identity forKey:@"identity"];
    [aCoder encodeObject:self.qq forKey:@"qq"];
    [aCoder encodeObject:self.sinaweibo forKey:@"sinaweibo"];
    [aCoder encodeObject:self.telephone forKey:@"telephone"];
    [aCoder encodeObject:self.degree forKey:@"degree"];
    [aCoder encodeObject:self.timepriod forKey:@"timepriod"];
    [aCoder encodeObject:self.objectinfo forKey:@"objectinfo"];
    [aCoder encodeObject:self.subjectinfo forKey:@"subjectinfo"];
    [aCoder encodeObject:self.memo forKey:@"memo"];
    [aCoder encodeObject:self.majoraddress forKey:@"majoraddress"];
    [aCoder encodeDouble:self.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.longitude forKey:@"longitude"];
}
//重写注册地址的setter方法，在这里面添加反地理编码，求出坐标；
//-(void)setMajoraddress:(NSString *)majoraddress
//{
//    _majoraddress = majoraddress;
//    MapTool *tool=[[MapTool alloc]init];
//    [tool geocodingWithAddress:majoraddress];
//    tool.returnCoordinate=^(CLLocationCoordinate2D location){
//    
//        self.latitude=location.latitude;
//        self.longitude=location.longitude;
//    };
//}
//
@end
