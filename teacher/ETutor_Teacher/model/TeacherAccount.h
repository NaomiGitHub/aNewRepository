//
//  TeacherAccount.h
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-17.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherAccount : NSObject<NSCoding>
@property(copy,nonatomic)NSString *userName;
@property(copy,nonatomic)NSString *password;
@end
