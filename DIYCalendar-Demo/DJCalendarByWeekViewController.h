//
//  DJCalendarByWeekViewController.h
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/7.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCalendarConstants.h"
#import "DJCalendarViewController.h"

@interface DJCalendarByWeekViewController : UIViewController
@property (nonatomic, weak) DJCalendarViewController *fatherVC;
@property (nonatomic, strong) NSDate *calendarStartDate;
@property (nonatomic, strong) NSDate *calendarEndDate;

@property (nonatomic, assign) DJChooseType chooseType;


@end
