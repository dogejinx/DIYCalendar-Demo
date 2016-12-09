//
//  DJCalendarConstants.h
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/7.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define DJCalendarWeekViewFillColor             UIColorFromRGB(0xf6f6f6)
#define DJCalendarTodayColor                    UIColorFromRGB(0xe9e9e9)
#define DJCalendarTitleTextColor                UIColorFromRGB(0x3f3f3f)
#define DJCalendarEventDotColor                 UIColorFromRGB(0xaeb4bc)
#define DJCalendarSelectFillColor               UIColorFromRGB(0x3897f0)

typedef NS_ENUM(NSUInteger, DJChooseType) {
    DJChooseTypeSingle,
    DJChooseTypeMuti
};

typedef NS_ENUM(NSUInteger, DJCalendarType) {
    DJCalendarTypeDay,
    DJCalendarTypeWeek,
    DJCalendarTypeMonth,
    DJCalendarTypeYear
};
