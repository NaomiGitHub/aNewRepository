//
//  NavViewController.m
//  ETutor_Teacher
//
//  Created by ibokan on 14-3-3.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBar_bg.jpg"] forBarMetrics:UIBarMetricsDefault];
        kNavigationBarFit(self);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
