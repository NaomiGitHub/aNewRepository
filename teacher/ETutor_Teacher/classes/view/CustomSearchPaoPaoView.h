//
//  CustomSearchPaoPaoView.h
//  ETutor_Customer
//
//  Created by 张鼎辉 on 14-3-5.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "BMKAnnotationView.h"

@interface CustomSearchPaoPaoView : UIImageView
@property (nonatomic , copy)NSString *cityAddress;
@property (nonatomic , copy)NSString *otherAddress;
@property (nonatomic , copy)void (^changeAddress)(NSString *address);

@end
