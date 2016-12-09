//
//  DJCalendarViewController.h
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/4.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCalendarHeaderView.h"
#import "DJCalendarConstants.h"

typedef void(^CallBackBlock)(DJChooseType, DJCalendarType, NSString *startDate, NSString *endDate, NSString *labelStr);

@interface DJCalendarViewController : UIViewController

@property (nonatomic, copy) CallBackBlock callBackBlock;
@property (nonatomic, strong) NSDate *calendarStartDate;
@property (nonatomic, strong) NSDate *calendarEndDate;
@property (nonatomic, assign) DJChooseType choosetype;

- (void)setup:(DJChooseType)chooseType minDate:(NSString *)minDate maxDate:(NSString *)maxDate block:(CallBackBlock)block;

@end
