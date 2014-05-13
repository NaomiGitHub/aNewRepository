//
//  NSString+Address.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-2-28.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "NSString+Address.h"
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
@implementation NSString (Address)
#pragma mark 根据地址反悔省，市，区/街道的字典
+ (NSDictionary *)stringWithAddress:(NSString *)address{
    NSArray *array = [address componentsSeparatedByString:@" "];
    
    if(!array)return nil;
    
    NSDictionary *dict = @{kProvinceAddress : array[0] , kCityAddress : array[1] , kOtherAddress : array[2]};
    
    return  dict;
}

#pragma mark 解析连续地址
+ (NSDictionary *)stringWithContinuousAddress:(NSString *)address{
    //判断是否有省
    NSRange range = [address rangeOfString:@"省"];
    NSString *province = @"";
    NSString *other = address;
    if(range.length != 0){
        //取出省
        province = [address componentsSeparatedByString:@"省"][0];
        province = [province stringByAppendingString:@"省"];
        other = [address componentsSeparatedByString:@"省"][1];
    }
    //判断是否有市区
    NSRange rangeCity = [address rangeOfString:@"市"];
    NSString *city = @"";
    NSString *otherAddress = @"";
    if(rangeCity.length != 0){
        //取出市
        city = [other componentsSeparatedByString:@"市"][0];
        city = [city stringByAppendingString:@"市"];
        //取出其他地址
        otherAddress = [other componentsSeparatedByString:@"市"][1];
    }else{
        otherAddress = other;
    }
    
    return @{kProvinceAddress : province  , kCityAddress:city  ,kOtherAddress : otherAddress};
}

#pragma mark 获取Bundle路径
+ (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}

#pragma mark 拼接标准地址字符串
+ (NSString *)jointNormAddressWithProvince:(NSString *)province city:(NSString *)cit other:(NSString *)other{
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@",province,cit,other];
    return address;
}
@end
