//
//  UIImage+Size.m
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-3.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "UIImage+Size.h"
#define MAX_IMAGEPIX 200          // max pix 200.0px
#define MAX_IMAGEDATA_LEN 100     // max data length 5K

@implementation UIImage (Size)
#pragma mark 压缩图片
+ (UIImage *)compressWithImageName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width <= MAX_IMAGEPIX && height <= MAX_IMAGEPIX) {
        // no need to compress.
        return image;
    }
    if (width == 0 || height == 0) {
        // void zero exception
        return image;
    }
    UIImage *newImage = nil;
    CGFloat widthFactor = MAX_IMAGEPIX / width;
    CGFloat heightFactor = MAX_IMAGEPIX / height;
    CGFloat scaleFactor = 0.0;
    if (widthFactor > heightFactor)
        scaleFactor = heightFactor; // scale to fit height
    else
        scaleFactor = widthFactor; // scale to fit width
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [image drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 拉伸图片
+ (UIImage *)resizableImageWithIcon:(NSString *)icon{
    UIImage *image = [UIImage imageWithContentsOfFile:icon];
    CGSize size = image.size;
    image = [image stretchableImageWithLeftCapWidth:size.width*0.5 topCapHeight:size.height*0.5];
    return image;
}
@end
