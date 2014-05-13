//
//  IconBtn.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-10.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "IconBtn.h"

@implementation IconBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel.font=[UIFont systemFontOfSize:16];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return self;
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width*0.25+5, 5, contentRect.size.width*0.75, contentRect.size.height-10);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(5, 5, contentRect.size.width*0.25, contentRect.size.height-10);
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
