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

@property (nonatomic, strong) DJCalendarObject *calendarObject;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.9];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 7;
    components.month = 12;
    components.year = 2016;
    NSDate *minDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    {
        DJCalendarObject *obj = [[DJCalendarObject alloc] init];
        obj.calendarType = DJCalendarTypeDay;
        obj.chooseType = DJChooseTypeMuti;
        obj.minDate = minDate;
        obj.maxDate = [NSDate date];
        self.calendarObject = obj;
    }
    
    [self updateBtnTitle];
    [self updateModeBtnTitle];
}


- (IBAction)btnHandler:(UIButton *)sender {
    
    DJCalendarViewController *calendarVC = [[DJCalendarViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    [calendarVC setup:_calendarObject block:^(DJCalendarObject *calendarObj) {
        __strong typeof(self) strongSelf = weakSelf;
        
        NSLog(@"DJChooseType: %zd, DJCalendarType: %zd, startDate: %@, endDate: %@, labelStr: %@", calendarObj.chooseType, calendarObj.calendarType, calendarObj.minDateApiStr, calendarObj.maxDateApiStr, calendarObj.showInLabelStr);
    
        strongSelf.calendarObject = calendarObj;
        [strongSelf updateBtnTitle];
        [strongSelf updateModeBtnTitle];
    }];
    
    
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:calendarVC];
    [self presentViewController:navi animated:YES completion:nil];
    
}
- (IBAction)modeBtnHandler:(UIButton *)sender {
    if (_calendarObject.chooseType == DJChooseTypeSingle) {
        _calendarObject.chooseType = DJChooseTypeMuti;
    }
    else if (_calendarObject.chooseType == DJChooseTypeMuti) {
        _calendarObject.chooseType = DJChooseTypeSingle;
    }
    _calendarObject.minDate = nil;
    _calendarObject.maxDate = nil;
    _calendarObject.calendarType = DJCalendarTypeDay;
    
    [self updateModeBtnTitle];
}

- (void)updateBtnTitle
{
    NSString *btnTitle = [NSString stringWithFormat:@"%@ %@", _calendarObject.calendarTypeStr, _calendarObject.showInLabelStr];
    [_btn setTitle:btnTitle forState:UIControlStateNormal];
}

- (void)updateModeBtnTitle
{
    NSString *modeBtnTitle = [NSString stringWithFormat:@"%@", (_calendarObject.chooseType==DJChooseTypeSingle) ? @"单选模式" : @"多选模式"];
    [_modeBtn setTitle:modeBtnTitle forState:UIControlStateNormal];
}

@end
