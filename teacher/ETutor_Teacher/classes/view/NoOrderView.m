//
//  NoOrderView.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-20.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "NoOrderView.h"
#define kDefineMargin 10
@implementation NoOrderView{
    UILabel *hintText;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置自身属性
       
        self.userInteractionEnabled = YES;
        self.alpha = 0.8;
        //添加控件
        [self addControl];
    }
    return self;
}

- (void)addControl{
    UILabel *title = [[UILabel alloc]init];
    title.text = @"提 示";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:24];
    title.textColor = [UIColor brownColor];
    title.frame = CGRectMake(self.frame.size.width/2-100/2, self.frame.size.width*0.3, 100, 30);
    [self addSubview:title];
    
    hintText = [[UILabel alloc]init];
    hintText.textAlignment = NSTextAlignmentCenter;
    hintText.font = [UIFont boldSystemFontOfSize:20];
    hintText.textColor = [UIColor brownColor];
    hintText.frame = CGRectMake(self.frame.size.width/2-200/2, CGRectGetMaxY(title.frame)+kDefineMargin, 200, 20);
    [self addSubview:hintText];
}

- (void)setHint:(NSString *)hint{
    _hint = hint;
    hintText.text = hint;
}

@end
