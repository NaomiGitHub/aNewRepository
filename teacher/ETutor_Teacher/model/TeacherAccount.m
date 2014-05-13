//
//  TeacherAccount.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-17.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "TeacherAccount.h"
#define kUserName @"userName"
#define kPassword @"password"
@implementation TeacherAccount
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.userName=[aDecoder decodeObjectForKey:kUserName];
        self.password=[aDecoder decodeObjectForKey:kPassword];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userName forKey:kUserName];
    [aCoder encodeObject:self.password forKey:kPassword];
}

@end
