//
//  UserInfo.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-6.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.layer.cornerRadius=3;
        //self.layer.borderWidth=0.5;
        //self.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.backgroundColor=kSetColor(0.95, 0.95, 0.95, 0.9);
    }
    return self;
}
-(id)initWithTitle:(NSString *)aTitle placeText:(NSString *)pText
{
    if (self=[super init]) {
        UILabel *name=[[UILabel alloc]init];
        name.text=aTitle;
        name.textColor=[UIColor blackColor];
        name.textAlignment=NSTextAlignmentRight;
        name.font=[UIFont systemFontOfSize:16];
        _name=name;
        [self addSubview:name];
        
        
        UITextField *text=[[UITextField alloc]init];
        //text.backgroundColor=kSetColor(0.9, 0.9, 0.9, 1);
        _text=text;
        text.placeholder=pText;
        [self addSubview:text];
        
        
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _name.frame=CGRectMake(0, 0, self.frame.size.width/4, self.frame.size.height);
    _text.frame=CGRectMake(CGRectGetMaxX(_name.frame)+10, 0, self.frame.size.width*3/4, self.frame.size.height);
    
    UIView *verline=[[UIView alloc]init];
    verline.backgroundColor=kSetColor(0.95, 0.95, 0.95, 1);
   // verline.frame=CGRectMake(CGRectGetMaxX(_name.frame)+5, 0, 0.5, frame.size.height);
    verline.frame=CGRectMake(0, 0, frame.size.width, 1);
    [self addSubview:verline];
    
    UIView *vorline=[[UIView alloc]init];
    vorline.backgroundColor=kSetColor(0.8, 0.8, 0.8, 1);
    vorline.frame=CGRectMake(0, frame.size.height-1, frame.size.width, 1);
    [self addSubview:vorline];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
