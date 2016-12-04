//
//  ViewController.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/4.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "ViewController.h"
#import "DJCalendarViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.9];
    
    
}


- (IBAction)btnHandler:(UIButton *)sender {
    
    DJCalendarViewController *calendarVC = [[DJCalendarViewController alloc] init];
    
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:calendarVC];
    
    [self presentViewController:navi animated:YES completion:^{
        NSLog(@"Present.Complete");
    }];
    
}


@end
