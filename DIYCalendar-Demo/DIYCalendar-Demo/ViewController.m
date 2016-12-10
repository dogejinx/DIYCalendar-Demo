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

@property (nonatomic, strong) DJCalendarViewController *calendarVC;
@property (nonatomic, strong) DJCalendarObject *calendarObject;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.9];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 2;
    components.month = 2;
    components.year = 2;
    NSDate *minDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    {
        DJCalendarViewController *calendarVC = [[DJCalendarViewController alloc] init];
        self.calendarVC = calendarVC;
        
        DJCalendarObject *obj = [[DJCalendarObject alloc] init];
        obj.calendarType = DJCalendarTypeDay;
        obj.minDate = minDate;
        obj.maxDate = [NSDate date];
        self.calendarObject = obj;
    }
}


- (IBAction)btnHandler:(UIButton *)sender {
    
    [_calendarVC setup:DJChooseTypeMuti object:_calendarObject minDate:@"2011-01-05" maxDate:@"2016-12-11" block:^(DJChooseType chooseType, DJCalendarObject *calendarObj, NSString *labelStr) {
        
        NSLog(@"DJChooseType: %zd, DJCalendarType: %zd, startDate: %@, endDate: %@, labelStr: %@", chooseType, calendarObj.calendarType, calendarObj.minDateStr, calendarObj.maxDateStr, labelStr);
    
    }];
    
    
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:_calendarVC];
    [self presentViewController:navi animated:YES completion:nil];
    
}


@end
