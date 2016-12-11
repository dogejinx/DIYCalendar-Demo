//
//  DJCalendarObject.h
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/10.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJCalendarConstants.h"

/**
 日历控件，数据传递、存储模型
 */
@interface DJCalendarObject : NSObject

/**
 日历格式（按日，按周，按月，按年）
 */
@property (nonatomic, assign) DJCalendarType calendarType;

/**
 单选、多选模式
 */
@property (nonatomic, assign) DJChooseType chooseType;

/**
 选中的 起始时间
 */
@property (nonatomic, strong) NSDate *minDate;

/**
 选中的 结束时间
 */
@property (nonatomic, strong) NSDate *maxDate;



// Read Only

/**
 API请求所需的 起始时间 字符串
 */
@property (readonly, strong) NSString *minDateApiStr;

/**
 API请求所需的 结束时间 字符串
 */
@property (readonly, strong) NSString *maxDateApiStr;

/**
 本次数据对应的日期格式（日、周、月、年）
 */
@property (readonly, strong) NSString *calendarTypeStr;

/**
 本次数据对应的 Label需要显示的内容
 */
@property (readonly, strong) NSString *showInLabelStr;


- (NSString *)minDateApiStr;
- (NSString *)maxDateApiStr;
- (NSString *)calendarTypeStr;
- (NSString *)showInLabelStr;

@end
