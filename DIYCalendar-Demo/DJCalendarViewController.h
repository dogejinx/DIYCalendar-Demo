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
#import "DJCalendarObject.h"

typedef void(^CallBackBlock)(DJCalendarObject *obj);

@interface DJCalendarViewController : UIViewController

/**
    单选，多选模式
 */
@property (nonatomic, assign) DJChooseType chooseType;

/**
    选择结束的回调
 */
@property (nonatomic, copy) CallBackBlock callBackBlock;

/**
    控件日期范围的最小日期
 */
@property (nonatomic, strong) NSDate *calendarStartDate;

/**
    控件日期范围的最大日期
 */
@property (nonatomic, strong) NSDate *calendarEndDate;

/**
    需要显示的历史记录
 */
@property (nonatomic, strong) DJCalendarObject *calendarObject;

/**
    使用前的配置方法
 */
- (void)setup:(DJCalendarObject *)obj minDate:(NSString *)minDate maxDate:(NSString *)maxDate block:(CallBackBlock)block;

/**
    子控制器通过调用它，退出日历选择控件（内部实现可自己实现Pop还是Dismiss）
 */
- (void)dismissViewController;
@end
