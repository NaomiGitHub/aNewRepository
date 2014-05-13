//
//  UserStatus.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-20.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "UserStatus.h"
//#import "User.h"
@implementation UserStatus
#pragma mark 判断是否登陆
+ (BOOL)isLogin{
    NSString *customerid =[[NSUserDefaults standardUserDefaults]objectForKey:kTeacherId];
    
    if(!customerid){
        return NO;
    }
    return YES;
}
#pragma mark 判断是否有地址信息
+ (BOOL)isPerfectAddress{
//    if([[User sharedUser].majoraddress isEqualToString:@""] || ![User sharedUser].majoraddress){
//        return NO;
//    }
    return YES;
}


@end
