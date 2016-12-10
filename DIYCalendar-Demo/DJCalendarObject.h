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
@property (nonatomic, assign) DJChooseType chooseType;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;

// Read Only
@property (readonly, strong) NSString *minDateApiStr;
@property (readonly, strong) NSString *maxDateApiStr;
@property (readonly, strong) NSString *calendarTypeStr;
@property (readonly, strong) NSString *showInLabelStr;


- (NSString *)minDateApiStr;
- (NSString *)maxDateApiStr;
- (NSString *)calendarTypeStr;
- (NSString *)showInLabelStr;

@end
