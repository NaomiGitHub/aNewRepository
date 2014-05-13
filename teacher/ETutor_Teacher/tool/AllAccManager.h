//
//  AllAccManager.h
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-17.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "SinaAccount.h"
#import "TeacherAccount.h"

@interface AllAccManager : NSObject
singleton_interface(AllAccManager)
@property(strong,nonatomic)TeacherAccount *teaAcc;
@property(strong,nonatomic)SinaAccount *sinaAcc;
-(void)addSinaAcc:(SinaAccount*)account;
-(void)addTeaAcc:(TeacherAccount *)account;
@end
