//
//  DJCalendarSubTableViewCell.h
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/7.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJCalendarSubTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *calendarLabel;

@property (nonatomic, assign) CGFloat labelMargin;
@property (nonatomic, assign) BOOL choose;

@end
