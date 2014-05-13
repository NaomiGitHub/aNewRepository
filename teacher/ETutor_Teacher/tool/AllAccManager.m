//
//  AllAccManager.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-17.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "AllAccManager.h"
#define kSinaFileName       @"sinaAccount.data"     //微博账号归档
#define kTeaFileName        @"teaAccount.data"
#define kAccountPath(fileName)   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:fileName]

@implementation AllAccManager
singleton_implementation(AllAccManager)
-(id)init
{
    if (self=[super init]) {
        self.sinaAcc=[NSKeyedUnarchiver unarchiveObjectWithFile:kAccountPath(kSinaFileName)];
        self.teaAcc=[NSKeyedUnarchiver unarchiveObjectWithFile:kAccountPath(kTeaFileName)];
    }
    return self;
}
-(void)addSinaAcc:(SinaAccount *)account
{
    
    self.sinaAcc=account;
    //归档
    [NSKeyedArchiver   archiveRootObject:self.sinaAcc toFile:kAccountPath(kSinaFileName)];
}
-(void)addTeaAcc:(TeacherAccount *)account
{
    self.teaAcc=account;
    [NSKeyedArchiver archiveRootObject:self.teaAcc toFile:kAccountPath(kTeaFileName)];
}
@end
