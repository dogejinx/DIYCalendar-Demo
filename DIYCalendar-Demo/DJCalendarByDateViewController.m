//
//  DJCalendarByDateViewController.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/7.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DJCalendarByDateViewController.h"
#import "DJCalendarHeaderView.h"
#import <EventKit/EventKit.h>
#import "FSCalendar.h"
#import "DJCalendarWeekView.h"
#import "DJCalendarByMonthViewController.h"
#import "DJCalendarByYearViewController.h"

@interface DJCalendarByDateViewController ()<FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance>

@property (nonatomic, strong) DJCalendarWeekView *weekView;
@property (nonatomic, strong) FSCalendar *calendar;

@property (strong, nonatomic) NSCalendar *gregorian;

@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;

@end

@implementation DJCalendarByDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_calendar reloadData];
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    //星期控件
    DJCalendarWeekView *weekView = [[DJCalendarWeekView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 44)];
    [view addSubview:weekView];
    self.weekView = weekView;
    
    // TODO:
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(1, 40, view.bounds.size.width-1, view.bounds.size.height - 40)];
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.pagingEnabled = NO; // important
    calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    calendar.headerHeight = 34;
    calendar.weekdayHeight = 6;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;// 隐藏非本月的日子
    calendar.allowsMultipleSelection = YES;
    {
        calendar.appearance.adjustsFontSizeToFitContentSize = NO;
        calendar.appearance.headerDateFormat = @"yyyy年M月";
        calendar.appearance.headerTitleFont = [UIFont boldSystemFontOfSize:16.f];
        calendar.appearance.headerTitleColor = UIColorFromRGB(0x79828f);
        
        calendar.appearance.weekdayFont = [UIFont boldSystemFontOfSize:0.f];
        
    }
    calendar.firstWeekday = 2;
    
    [view addSubview:calendar];
    self.calendar = calendar;
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    self.minimumDate = _calendarStartDate;
    self.maximumDate = _calendarEndDate;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _weekView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    _calendar.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 40);
}

#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return self.minimumDate;
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return self.maximumDate;
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @"今天";
    }
    NSString *numberStr = [NSString stringWithFormat:@"%zd", [self.gregorian component:NSCalendarUnitDay fromDate:date]];
    return numberStr;
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
//    NSLog(@"did select %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
//    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
//    NSLog(@"did change page %@",[self.dateFormatter stringFromDate:calendar.currentPage]);
}


#pragma mark - FSCalendarDelegateAppearance
- (CGFloat)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderRadiusForDate:(NSDate *)date
{
    return 0;
}

#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}

- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    // Configure selection layer
    if (monthPosition == FSCalendarMonthPositionCurrent || self.calendar.scope == FSCalendarScopeWeek) {
        
        SelectionType selectionType = SelectionTypeNone;
        if ([self.calendar.selectedDates containsObject:date]) {
            NSDate *previousDate = [self.gregorian dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:date options:0];
            NSDate *nextDate = [self.gregorian dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0];
            if ([self.calendar.selectedDates containsObject:date]) {
                if ([self.calendar.selectedDates containsObject:previousDate] && [self.calendar.selectedDates containsObject:nextDate]) {
                    selectionType = SelectionTypeMiddle;
                } else if ([self.calendar.selectedDates containsObject:previousDate] && [self.calendar.selectedDates containsObject:date]) {
                    selectionType = SelectionTypeRightBorder;
                } else if ([self.calendar.selectedDates containsObject:nextDate]) {
                    selectionType = SelectionTypeLeftBorder;
                } else {
                    selectionType = SelectionTypeSingle;
                }
            }
        } else {
            selectionType = SelectionTypeNone;
        }
    
        cell.selectionType = selectionType;
        
        
    } else if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        
        if ([self.calendar.selectedDates containsObject:date]) {
            cell.titleLabel.textColor = self.calendar.appearance.titlePlaceholderColor; // Prevent placeholders from changing text color
        }
    }
}

@end
