//
//  NSString+Date.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-15.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)
#pragma mark 获取当前时间字符串
+ (NSString *)stringWithNowDate{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:now];
}

+ (NSString *)dateStringWithFormatterWithNSString:(NSString *)dateStr{
    NSArray *array = [dateStr componentsSeparatedByString:@"-"];
    if(array.count==0){
        return @"";
    }
    return [NSString stringWithFormat:@"%@年 %@月 %@日",array[0],array[1],array[2]];
}
#pragma mark - 判断字符串包含
-(BOOL)isContainsStr:(NSString *)str
{
    NSRange range=[self rangeOfString:str];
    if (range.location==NSNotFound) {
        return NO;
    }else
        return YES;
}
@end
