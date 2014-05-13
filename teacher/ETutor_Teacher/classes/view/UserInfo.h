//
//  UserInfo.h
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-6.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfo : UIView
{
    UILabel *_name;
    UITextField *_text;
}
-(id)initWithTitle:(NSString *)aTitle placeText:(NSString *)pText;
@end
