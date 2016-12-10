//
//  DJCalendarSubTableViewCell.h
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/7.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CellSelectionType) {
    CellSelectionTypeNone,
    CellSelectionTypeSingle,
    CellSelectionTypeMutiBorder,
    CellSelectionTypeMutiMiddle
};

@interface DJCalendarSubTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *calendarLabel;
@property (nonatomic, assign) CellSelectionType cellSelectionType;
@property (nonatomic, assign) CGFloat labelMargin;

@end
