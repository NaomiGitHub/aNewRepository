//
//  SinaAccount.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-11.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "SinaAccount.h"

@implementation SinaAccount
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.accessToken=[aDecoder decodeObjectForKey:kAccessToken];
        self.uid=[aDecoder decodeObjectForKey:kUid];
        self.screenName=[aDecoder decodeObjectForKey:@"screen_name"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.accessToken forKey:kAccessToken];
    [aCoder encodeObject:self.uid forKey:kUid];
    [aCoder encodeObject:self.screenName forKey:@"screen_name"];
}

@end
