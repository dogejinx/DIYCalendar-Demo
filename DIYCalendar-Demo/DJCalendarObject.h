//
//  DJCalendarObject.h
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/10.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJCalendarConstants.h"
@interface DJCalendarObject : NSObject

@property (nonatomic, assign) DJCalendarType calendarType;
@property (nonatomic, strong) NSString *minDateStr;
@property (nonatomic, strong) NSString *maxDateStr;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;

@end
