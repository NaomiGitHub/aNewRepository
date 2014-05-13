//
//  UIImage+Img.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-2-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "UIImage+Img.h"

@implementation UIImage (Img)
#pragma mark 根据屏幕大小设置图片
+(UIImage *)fullScreenImageWithName:(NSString *)name
{
    if (iphone5) {
        name=[name appendFileName:@"-568h@2x"];
    }
    
    return [UIImage imageNamed:name];
}

+(UIImage *)stretchImageWithName:(NSString *)image
{
    UIImage *img=[UIImage imageNamed:image];
    return [img stretchableImageWithLeftCapWidth:img.size.width*0.5 topCapHeight:img.size.height*0.5];
}
@end
