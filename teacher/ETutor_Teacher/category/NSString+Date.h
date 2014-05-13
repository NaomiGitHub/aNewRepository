//
//  NSString+Date.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-15.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

//转换时间为字符串
+ (NSString *)stringWithNowDate;
//将字符串转换成 yyyy年mm月dd日的形式
+ (NSString *)dateStringWithFormatterWithNSString:(NSString *)dateStr;
//
-(BOOL)isContainsStr:(NSString *)str;
@end
