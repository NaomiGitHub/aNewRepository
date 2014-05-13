//
//  TeacherManager.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-24.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "TeacherManager.h"
#define kTeacherFile @"teacher.data"
#define kPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:kTeacherFile]
@implementation TeacherManager
singleton_implementation(TeacherManager)
-(id)init
{
    if (self=[super init]) {
        self.teacher=[NSKeyedUnarchiver unarchiveObjectWithFile:kPath];
    }
    return self;
}
-(void)archiveTeacher:(TeacherUser *)teacher
{
    self.teacher=teacher;
    [NSKeyedArchiver archiveRootObject:self.teacher toFile:kPath];
}
@end
