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
    [calendarVC setup:DJChooseTypeMuti minDate:@"2011-01-05" maxDate:@"2016-12-09" block:^(DJChooseType chooseType, DJCalendarType calendarType, NSString *startDate, NSString *endDate, NSString *labelStr) {
        NSLog(@"DJChooseType: %zd, DJCalendarType: %zd, startDate: %@, endDate: %@, labelStr: %@", chooseType, calendarType, startDate, endDate, labelStr);
    }];
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:calendarVC];
    [self presentViewController:navi animated:YES completion:nil];
    
}


@end
