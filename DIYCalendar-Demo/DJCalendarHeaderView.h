//
//  DJCalendarHeaderView.h
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/4.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DJCalendarHeaderView;


@protocol DJCalendarHeaderViewDelegate <NSObject>

@optional
// 当前点击了哪个Index
- (void)dj_calendar:(DJCalendarHeaderView *)calendarHeaderView didSelectPageAtIndex:(NSInteger)index;

@end


@interface DJCalendarHeaderView : UIView

@property (nonatomic, weak) id<DJCalendarHeaderViewDelegate> delegate;

- (void)updateLinePath:(CGFloat)offset;

@end
