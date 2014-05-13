//
//  TeacherManager.h
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-24.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "TeacherUser.h"

@interface TeacherManager : NSObject
singleton_interface(TeacherManager)
@property(nonatomic,strong)TeacherUser *teacher;
-(void)archiveTeacher:(TeacherUser *)teacher;
@end
