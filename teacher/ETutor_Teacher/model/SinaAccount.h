//
//  SinaAccount.h
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-11.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SinaAccount : NSObject<NSCoding>
@property(nonatomic,copy)NSString *accessToken;//access_token
@property(nonatomic,copy)NSString *uid; //uid
@property(nonatomic,copy)NSString *screenName;//昵称
@end
