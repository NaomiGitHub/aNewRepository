//
//  QuickViewController.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-3.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "QuickViewController.h"

@interface QuickViewController ()

@end

@implementation QuickViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(10, 20, kBtnWidth, kBtnHeight);
    backBtn.backgroundColor=kSetColor(0.4, 0.2, 0.4, 0.5);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
