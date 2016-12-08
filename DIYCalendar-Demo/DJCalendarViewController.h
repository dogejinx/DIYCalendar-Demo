//
//  DJCalendarViewController.h
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/4.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCalendarHeaderView.h"

typedef void(^CallBackBlock) (NSString *text);

@interface DJCalendarViewController : UIViewController

@property (nonatomic, copy) CallBackBlock callBackBlock;
@property (nonatomic, strong) NSDate *calendarStartDate;
@property (nonatomic, strong) NSDate *calendarEndDate;

@end
