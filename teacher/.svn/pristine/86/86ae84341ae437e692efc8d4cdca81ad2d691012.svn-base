//
//  NSString+File.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-2-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "NSString+File.h"

@implementation NSString (File)
-(NSString *)appendFileName:(NSString *)append
{
    NSString *fileName=[self stringByDeletingPathExtension];
    fileName=[fileName stringByAppendingString:append];
    NSString *extension=[self pathExtension];
    NSString * newFileName=[fileName stringByAppendingString:[NSString stringWithFormat:@".%@",extension]];
    return newFileName;
}
@end
