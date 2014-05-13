//
//  NSString+Address.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-2-28.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kCityAddress @"CITY"
#define kProvinceAddress @"PROVINCE"
#define kOtherAddress @"OTHERADDRESS"
@interface NSString (Address)

//解析地址为字典
+ (NSDictionary *)stringWithAddress:(NSString *)address;
//解析连续地址为独立的
+ (NSDictionary *)stringWithContinuousAddress:(NSString *)address;
//获取Boundle路径
+ (NSString *)getMyBundlePath1:(NSString *)filename;
+ (NSString *)jointNormAddressWithProvince:(NSString *)province city:(NSString *)cit other:(NSString *)other;
@end
