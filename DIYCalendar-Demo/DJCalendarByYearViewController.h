//
//  DJCalendarByYearViewController.h
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/7.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCalendarConstants.h"

@interface DJCalendarByYearViewController : UIViewController

@property (nonatomic, strong) NSDate *calendarStartDate;
@property (nonatomic, strong) NSDate *calendarEndDate;

@property (nonatomic, assign) ChooseType chooseType;
@end
