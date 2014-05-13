//
//  MoreSetupCell.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-2-27.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "MoreSetupCell.h"
@implementation MoreSetupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.layer.shadowColor=[UIColor blackColor].CGColor;
//        self.layer.shadowOffset=CGSizeMake(3, 3);
//        self.layer.shadowOpacity=0.3;
//        self.layer.cornerRadius=5;
        
//        UIView *view=[[UIView alloc]initWithFrame:self.frame];
//        view.backgroundColor=[UIColor clearColor];
//        self.backgroundView=view;
//        self.selectedBackgroundView=view;
//        self.highlighted=YES;
    }
    return self;
}
#pragma mark - 重写setFrame设置边框距离
-(void)setFrame:(CGRect)frame
{
    frame.origin.x=10;
    frame.size.width-=20;
    
    frame.origin.y +=1;
    frame.size.height-=1;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
