//
//  TeaInfoCell.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-18.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "TeaInfoCell.h"
#define kTitleFont 14
#define kInfoFont  13
#define kTitleWidthScale 1/4
@implementation TeaInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.title=[[UILabel alloc]init];
        self.title.frame=CGRectMake(10, 0, self.frame.size.width*kTitleWidthScale, self.frame.size.height);
        self.title.textColor=[UIColor blackColor];
        self.title.font=[UIFont systemFontOfSize:kTitleFont];
        [self.contentView addSubview:self.title];
        
        
        self.info=[[UILabel alloc]init];
        self.info.frame=CGRectMake(CGRectGetMaxX(self.title.frame)+40, 0, self.frame.size.width*(1-kTitleWidthScale)-50, self.frame.size.height);
        self.info.font=[UIFont systemFontOfSize:kInfoFont];
        self.info.textAlignment=NSTextAlignmentLeft;
        self.info.textColor=kSetColor(0.1, 0.1, 0.1, 1);
        self.info.numberOfLines=0;
        [self.contentView addSubview:self.info];
    }
    return self;
}
-(void)setTeaInfo:(NSDictionary *)teaInfo
{
    self.title.text=[teaInfo allKeys][0];
    self.info.text=[teaInfo allValues][0];
}
-(void)setFrame:(CGRect)frame
{
    frame.origin.x+=2.5;
    frame.size.width-=5;
    
    frame.origin.y-=0.5;
    frame.origin.y-=1;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
