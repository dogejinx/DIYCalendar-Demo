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
#import "DIYCalendarCell.h"
#import "DJCalendarWeekView.h"
#import "DJToastView.h"

@interface DJCalendarByDateViewController ()<FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance>

@property (nonatomic, strong) DJCalendarWeekView *weekView;
@property (nonatomic, strong) FSCalendar *calendar;

@property (nonatomic, strong) NSCalendar *gregorian;

@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

@property (nonatomic, strong) DJToastView *middleToast;
@property (nonatomic, strong) DJToastView *bottomToast;


@end

@implementation DJCalendarByDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateUI];
}

- (void)updateUI
{
    [_bottomToast updateTitleText:@"请选择日期"];
    
    if (_chooseType == DJChooseTypeMuti) {
        NSArray *arr = _calendar.selectedDates;
        if (arr.count>0) {
            for (NSDate *date in arr) {
                [_calendar deselectDate:date];
            }
        }
    }
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
    if (_chooseType == DJChooseTypeSingle) {
        calendar.allowsMultipleSelection = NO;
    }
    else if (_chooseType == DJChooseTypeMuti) {
        calendar.allowsMultipleSelection = YES;
    }
    
    {
        calendar.appearance.adjustsFontSizeToFitContentSize = NO;
        calendar.appearance.headerDateFormat = @"yyyy年M月";
        calendar.appearance.headerTitleFont = [UIFont boldSystemFontOfSize:16.f];
        calendar.appearance.headerTitleColor = UIColorFromRGB(0x79828f);
        
        calendar.appearance.weekdayFont = [UIFont boldSystemFontOfSize:0.f];
        [calendar registerClass:[DIYCalendarCell class] forCellReuseIdentifier:@"DIYCalendarCell"];
        
    }
    
    [view addSubview:calendar];
    self.calendar = calendar;
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    self.minimumDate = _calendarStartDate;
    self.maximumDate = _calendarEndDate;
    
    [self addToastView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _weekView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    _calendar.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 40);
    _middleToast.frame = CGRectMake(0, 0, 150, 40);
    _middleToast.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    _bottomToast.frame = CGRectMake(0, 0, 150, 40);
    _bottomToast.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - 60);
}

- (void)addToastView
{
    DJToastView *mToast = [[DJToastView alloc] initWithFrame:CGRectZero];
    mToast.titlelabel.text = @"最多可选30天";
    [self.view addSubview:mToast];
    mToast.alpha = 0.0;
    self.middleToast = mToast;
    
    DJToastView *bToast = [[DJToastView alloc] initWithFrame:CGRectZero];
    bToast.titlelabel.text = @"请选择日期";
    [self.view addSubview:bToast];
    self.bottomToast = bToast;
    
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

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date
{
    if ([date compare:_calendar.minimumDate] >= 0 && [date compare:_calendar.maximumDate] <= 0) {
        if ([self isBetweenRangeOfSelected:date]) {
            return [UIColor whiteColor];
        }
        
        if ([self.gregorian isDateInToday:date]) {
            return UIColorFromRGB(0xf54242);
        }
        
        NSDateComponents *dateComponents = [_gregorian components:NSCalendarUnitWeekday fromDate:date];
        if (dateComponents.weekday == 1 || dateComponents.weekday == 7) {
            return UIColorFromRGB(0x3897f0);
        }
        return _calendar.appearance.titleDefaultColor;
    }
    else {
        return _calendar.appearance.titlePlaceholderColor;
    }
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    DIYCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"DIYCalendarCell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    if (_calendar.selectedDates.count >= 2) {
        NSArray *arr = _calendar.selectedDates;
        if (arr.count>0) {
            for (NSDate *date in arr) {
                [_calendar deselectDate:date];
            }
        }
    }
    
    if (![self isValidRangeOfDay:_calendar.selectedDates.firstObject date:date]) {
        [UIView animateWithDuration:0.15f animations:^{
            _middleToast.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.f animations:^{
                _middleToast.alpha = 0.3;
            } completion:^(BOOL finished) {
                _middleToast.alpha = 0.0;
            }];
        }];
        return NO;
    }
    return YES;
}

//- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
//{
//    if (_calendar.selectedDates.count >= 2) {
//        NSArray *arr = _calendar.selectedDates;
//        if (arr.count>0) {
//            for (NSDate *date in arr) {
//                [_calendar deselectDate:date];
//            }
//        }
//    }
//
//}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    [self clickAction:date];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    [self clickAction:date];
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
    [_calendar reloadData];
}

- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    DIYCalendarCell *diyCell = (DIYCalendarCell *)cell;
    
    diyCell.todayView.hidden = YES;
    
    // Configure selection layer
    if (monthPosition == FSCalendarMonthPositionCurrent || self.calendar.scope == FSCalendarScopeWeek) {
        diyCell.eventIndicator.hidden = YES;
        
        SelectionType selectionType = SelectionTypeNone;
        
        if ([self.calendar.selectedDates containsObject:date]) {
            selectionType = SelectionTypeSingle;
        } else {
            if ([self isBetweenRangeOfSelected:date]) {
                selectionType = SelectionTypeMiddle;
            }
        }
        
        if (selectionType == SelectionTypeNone) {
            diyCell.selectionLayer.hidden = YES;
            return;
        }
        
        diyCell.selectionLayer.hidden = NO;
        diyCell.selectionType = selectionType;
    
    } else if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        
        diyCell.todayView.hidden = YES;
        diyCell.selectionLayer.hidden = YES;
        diyCell.eventIndicator.hidden = YES; // Hide default event indicator
        if ([self.calendar.selectedDates containsObject:date]) {
            diyCell.titleLabel.textColor = self.calendar.appearance.titlePlaceholderColor; // Prevent placeholders from changing text color
        }
    }
}

- (void)clickAction:(NSDate *)date {
    if (_chooseType == DJChooseTypeSingle) {
        if (_calendar.selectedDates.count > 1) {
            return;
        }
        
        [self configureVisibleCells];
        [self submitDate];
    }
    else {
        if (_calendar.selectedDates.count > 2) {
            return;
        }
        
        
        if (_calendar.selectedDates.count == 0) {
            [self configureVisibleCells];
            [_bottomToast updateTitleText:@"请选择日期"];
        }
        else if (_calendar.selectedDates.count == 1) {
            [self configureVisibleCells];
            [_bottomToast updateTitleText:@"请再选择一个日期"];
        }
        else if (_calendar.selectedDates.count == 2) {
            [self configureVisibleCells];
            [self submitDate];
        }
    }
}

- (void)submitDate
{
    if (_chooseType == DJChooseTypeSingle) {
        if (_calendar.selectedDate) {
            NSDate *date = _calendar.selectedDate;
            
            DJCalendarObject *obj = [[DJCalendarObject alloc] init];
            obj.calendarType = DJCalendarTypeDay;
            obj.chooseType = _chooseType;
            obj.minDate = date;
            obj.maxDate = date;
            
            _fatherVC.callBackBlock(obj);
            [_fatherVC dismissViewController];
        }
    }
    else if (_chooseType == DJChooseTypeMuti) {
        NSDate *startDate = _calendar.selectedDates.firstObject;
        NSDate *endDate = _calendar.selectedDates.lastObject;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _calendar.selectedDates.lastObject;
            endDate = _calendar.selectedDates.firstObject;
        }
        
        DJCalendarObject *obj = [[DJCalendarObject alloc] init];
        obj.calendarType = DJCalendarTypeDay;
        obj.chooseType = _chooseType;
        obj.minDate = startDate;
        obj.maxDate = endDate;
        
        _fatherVC.callBackBlock(obj);
        [_fatherVC dismissViewController];
    }
}

- (BOOL)isValidRangeOfDay:(NSDate *)dateX date:(NSDate *)dateY
{
    if (dateX == nil) {
        return YES;
    }
    
    NSDate *startDate = dateX;
    NSDate *endDate = dateY;
    
    NSDateComponents *resultComponents = [_gregorian components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:0];
    
    NSInteger result = labs(resultComponents.day);
    // 限制单日跨度30天
    if (result <= 30) {
        return  YES;
    }
    return NO;
}

- (BOOL)isBetweenRangeOfSelected:(NSDate *)date
{
    if (_calendar.selectedDates.count < 2) {
        return NO;
    }
    
    NSDate *dateX = _calendar.selectedDates.firstObject;
    NSDate *dateY = _calendar.selectedDates.lastObject;
    
    NSDateComponents *dateFromX = [_gregorian components:NSCalendarUnitDay fromDate:date toDate:dateX options:0];
    NSDateComponents *dateFromY = [_gregorian components:NSCalendarUnitDay fromDate:date toDate:dateY options:0];
    NSDateComponents *xFromY = [_gregorian components:NSCalendarUnitDay fromDate:dateX toDate:dateY options:0];
    
    NSInteger d_X = labs(dateFromX.day);
    NSInteger d_Y = labs(dateFromY.day);
    NSInteger x_Y = labs(xFromY.day);
    
    if (d_X + d_Y == x_Y) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)forceClearData
{
    NSArray *arr = _calendar.selectedDates;
    if (arr.count>0) {
        for (NSDate *date in arr) {
            [_calendar deselectDate:date];
        }
    }
    [self configureVisibleCells];
}

@end
