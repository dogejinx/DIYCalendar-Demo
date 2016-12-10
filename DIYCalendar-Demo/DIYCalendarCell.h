//
//  DIYCalendarCell.h
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/9.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "FSCalendarCell.h"
#import "FSCalendar.h"

typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeNone,
    SelectionTypeSingle,
    SelectionTypeMiddle
};


@interface DIYCalendarCell : FSCalendarCell
@property (weak, nonatomic) UIView *todayView;
@property (weak, nonatomic) CAShapeLayer *selectionLayer;

@property (assign, nonatomic) SelectionType selectionType;

@end
