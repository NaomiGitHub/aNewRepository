//
//  UIImage+Size.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-3.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Size)

//压缩图片
+ (UIImage *)compressWithImageName:(NSString *)imageName;
+ (UIImage *)resizableImageWithIcon:(NSString *)icon;
@end
