//
//  MainBtn.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-14.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "MainBtn.h"
#define kImageRatio 0.6

@implementation MainBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //文字居中,大小
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font=[UIFont systemFontOfSize:14];
        [self setTitleColor:kSetColor(0.2, 0.2, 0.2, 1) forState:UIControlStateNormal];
        //imageView按图片的宽高比显示
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return self;
}
#pragma mark 返回按钮内部label的位置及大小
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY=contentRect.size.height*kImageRatio-5;
    CGFloat titleHeight=contentRect.size.height-titleY;
    return CGRectMake(0,titleY , contentRect.size.width, titleHeight);
}
#pragma mark 返回按钮内部imageView的位置及大小
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.height*kImageRatio);
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
