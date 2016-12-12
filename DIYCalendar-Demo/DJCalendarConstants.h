//
//  DJCalendarConstants.h
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/7.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define DJMinimumDaysInFirstWeek    4

typedef NS_ENUM(NSUInteger, DJChooseType) {
    DJChooseTypeSingle      = 0,
    DJChooseTypeMuti        = 1
};

typedef NS_ENUM(NSUInteger, DJCalendarType) {
    DJCalendarTypeDay       = 0,
    DJCalendarTypeWeek      = 1,
    DJCalendarTypeMonth     = 2,
    DJCalendarTypeYear      = 3
};
