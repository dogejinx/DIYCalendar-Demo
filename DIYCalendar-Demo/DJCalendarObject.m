//
//  DJCalendarObject.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/10.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DJCalendarObject.h"

@interface DJCalendarObject ()
{
    NSString *_minDateApiStr;
    NSString *_maxDateApiStr;
    NSString *_calendarTypeStr;
    NSString *_showInLabelStr;
    
    NSCalendar *_gregorian;
}
@end

@implementation DJCalendarObject

- (NSString *)calendarTypeStr
{
    _calendarTypeStr = @"";
    if (_calendarType == DJCalendarTypeDay) {
        _calendarTypeStr = @"日票房";
    }
    else if (_calendarType == DJCalendarTypeWeek) {
        _calendarTypeStr = @"周票房";
    }
    else if (_calendarType == DJCalendarTypeMonth) {
        _calendarTypeStr = @"月票房";
    }
    else if (_calendarType == DJCalendarTypeYear) {
        _calendarTypeStr = @"年票房";
    }
    
    return _calendarTypeStr;
}

- (NSString *)minDateApiStr
{
    _minDateApiStr = @"";
    if (_minDate && _maxDate) {
        if (_calendarType == DJCalendarTypeDay) {
            _minDateApiStr = [self minDateApiStrForTypeDay];
        }
        else if (_calendarType == DJCalendarTypeWeek) {
            _minDateApiStr = [self minDateApiStrForTypeWeek];
        }
        else if (_calendarType == DJCalendarTypeMonth) {
            _minDateApiStr = [self minDateApiStrForTypeMonth];
        }
        else if (_calendarType == DJCalendarTypeYear) {
            _minDateApiStr = [self minDateApiStrForTypeYear];
        }
    }
    
    return _minDateApiStr;
}

- (NSString *)maxDateApiStr
{
    _maxDateApiStr = @"";
    if (_minDate && _maxDate) {
        if (_calendarType == DJCalendarTypeDay) {
            _maxDateApiStr = [self maxDateApiStrForTypeDay];
        }
        else if (_calendarType == DJCalendarTypeWeek) {
            _maxDateApiStr = [self maxDateApiStrForTypeWeek];
        }
        else if (_calendarType == DJCalendarTypeMonth) {
            _maxDateApiStr = [self maxDateApiStrForTypeMonth];
        }
        else if (_calendarType == DJCalendarTypeYear) {
            _maxDateApiStr = [self maxDateApiStrForTypeYear];
        }
    }
    
    return _maxDateApiStr;
}

- (NSString *)showInLabelStr
{
    _showInLabelStr = @"";
    if (_minDate && _maxDate) {
        if (_calendarType == DJCalendarTypeDay) {
            _showInLabelStr = [self showInLabelStrForTypeDay];
        }
        else if (_calendarType == DJCalendarTypeWeek) {
            _showInLabelStr = [self showInLabelStrForTypeWeek];
        }
        else if (_calendarType == DJCalendarTypeMonth) {
            _showInLabelStr = [self showInLabelStrForTypeMonth];
        }
        else if (_calendarType == DJCalendarTypeYear) {
            _showInLabelStr = [self showInLabelStrForTypeYear];
        }
    }
    
    return _showInLabelStr;
}

#pragma mark - Private Func
#pragma mark - DJCalendarTypeDay
- (NSString *)minDateApiStrForTypeDay
{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _gregorian.minimumDaysInFirstWeek = DJMinimumDaysInFirstWeek;
    }
    
    if (_chooseType == DJChooseTypeSingle) {
        NSDate *date = _minDate;
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        
        NSString *startDateString = [NSString stringWithFormat:@"%zd%02zd%02zd",startComponents.year, startComponents.month, startComponents.day];
        
        return startDateString;
    }
    else if (_chooseType == DJChooseTypeMuti) {
        NSDate *startDate = _minDate;
        NSDate *endDate = _maxDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _maxDate;
            endDate = _minDate;
        }
        
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:startDate];
        
        NSString *startDateString = [NSString stringWithFormat:@"%zd%02zd%02zd",startComponents.year, startComponents.month, startComponents.day];
        
        return startDateString;
    }
    return @"";
}

- (NSString *)maxDateApiStrForTypeDay
{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _gregorian.minimumDaysInFirstWeek = DJMinimumDaysInFirstWeek;
    }
    
    if (_chooseType == DJChooseTypeSingle) {
        NSDate *date = _minDate;
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        
        NSString *startDateString = [NSString stringWithFormat:@"%zd%02zd%02zd",startComponents.year, startComponents.month, startComponents.day];
        NSString *endDateString = startDateString;
        
        return endDateString;
    }
    else if (_chooseType == DJChooseTypeMuti) {
        NSDate *startDate = _minDate;
        NSDate *endDate = _maxDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _maxDate;
            endDate = _minDate;
        }
        
        NSDateComponents *endComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:endDate];
        
        NSString *endDateString = [NSString stringWithFormat:@"%zd%02zd%02zd",endComponents.year, endComponents.month, endComponents.day];
        
        return endDateString;
    }
    return @"";
}

- (NSString *)showInLabelStrForTypeDay
{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _gregorian.minimumDaysInFirstWeek = DJMinimumDaysInFirstWeek;
    }
    
    if (_chooseType == DJChooseTypeSingle) {
        NSDate *date = _minDate;
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        
        NSString *labelString = [NSString stringWithFormat:@"%zd年%zd月%zd日", startComponents.year, startComponents.month, startComponents.day];
        
        return labelString;
    }
    else if (_chooseType == DJChooseTypeMuti) {
        NSDate *startDate = _minDate;
        NSDate *endDate = _maxDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _maxDate;
            endDate = _minDate;
        }
        
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:startDate];
        NSDateComponents *endComponents = [_gregorian components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:endDate];
        
        NSString *labelString = [NSString stringWithFormat:@"%zd月%zd日-%zd月%zd日", startComponents.month,startComponents.day, endComponents.month, endComponents.day];
        
        return labelString;
    }
    return @"";
}


#pragma mark - DJCalendarTypeWeek
- (NSString *)minDateApiStrForTypeWeek
{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _gregorian.minimumDaysInFirstWeek = DJMinimumDaysInFirstWeek;
    }
    
    if (_chooseType == DJChooseTypeSingle) {
        
        NSDate *date = _minDate;
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        
        NSString *startDateString = [NSString stringWithFormat:@"%zd%02zd%02zd",startComponents.year, startComponents.month, startComponents.day];
        
        return startDateString;
        
    }
    else if (_chooseType == DJChooseTypeMuti) {
        
        NSDate *startDate = _minDate;
        NSDate *endDate = _maxDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _maxDate;
            endDate = _minDate;
        }
        
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear fromDate:startDate];
        
        NSString *startDateString = [NSString stringWithFormat:@"%zd%02zd%02zd",startComponents.year, startComponents.month, startComponents.day];
        
        return startDateString;
    }
    return @"";
}

- (NSString *)maxDateApiStrForTypeWeek
{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _gregorian.minimumDaysInFirstWeek = DJMinimumDaysInFirstWeek;
    }
    
    if (_chooseType == DJChooseTypeSingle) {
        
        NSDate *date = _minDate;
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        
        NSString *startDateString = [NSString stringWithFormat:@"%zd%02zd%02zd",startComponents.year, startComponents.month, startComponents.day];
        NSString *endDateString = startDateString;
        
        return endDateString;
        
    }
    else if (_chooseType == DJChooseTypeMuti) {
        
        NSDate *startDate = _minDate;
        NSDate *endDate = _maxDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _maxDate;
            endDate = _minDate;
        }
        
        NSDateComponents *endComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear fromDate:endDate];
        
        NSString *endDateString = [NSString stringWithFormat:@"%zd%02zd%02zd",endComponents.year, endComponents.month, endComponents.day];
        
        return endDateString;
    }
    return @"";
}

- (NSString *)showInLabelStrForTypeWeek
{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _gregorian.minimumDaysInFirstWeek = DJMinimumDaysInFirstWeek;
    }
    
    if (_chooseType == DJChooseTypeSingle) {
        
        NSDate *date = _minDate;
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:7];
        NSDate *dateAfterSeven = [_gregorian dateByAddingComponents:comps toDate:date options:0];
        NSDateComponents *endComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:dateAfterSeven];
        
        NSString *labelString = [NSString stringWithFormat:@"%zd月%zd号-%zd月%zd号/%zd年", startComponents.month, startComponents.day, endComponents.month, endComponents.day, startComponents.year];
        
        return labelString;
        
    }
    else if (_chooseType == DJChooseTypeMuti) {
        
        NSDate *startDate = _minDate;
        NSDate *endDate = _maxDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _maxDate;
            endDate = _minDate;
        }
        
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear fromDate:startDate];
        NSDateComponents *endComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear fromDate:endDate];
        
        NSString *labelString = [NSString stringWithFormat:@"第%zd周-第%zd周", startComponents.weekOfYear, endComponents.weekOfYear];
        
        return labelString;
    }
    return @"";
}


#pragma mark - DJCalendarTypeMonth
- (NSString *)minDateApiStrForTypeMonth
{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _gregorian.minimumDaysInFirstWeek = DJMinimumDaysInFirstWeek;
    }
    
    if (_chooseType == DJChooseTypeSingle) {
        
        NSDate *date = _minDate;
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
        
        NSString *startDateString = [NSString stringWithFormat:@"%zd%02zd",startComponents.year, startComponents.month];
        
        return startDateString;
    }
    else if (_chooseType == DJChooseTypeMuti) {
        
        NSDate *startDate = _minDate;
        NSDate *endDate = _maxDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _maxDate;
            endDate = _minDate;
        }
        
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:startDate];
        
        NSString *startDateString = [NSString stringWithFormat:@"%zd%02zd",startComponents.year, startComponents.month];
        
        return startDateString;
    }
    return @"";
}

- (NSString *)maxDateApiStrForTypeMonth
{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _gregorian.minimumDaysInFirstWeek = DJMinimumDaysInFirstWeek;
    }
    
    if (_chooseType == DJChooseTypeSingle) {
        
        NSDate *date = _minDate;
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
        
        NSString *startDateString = [NSString stringWithFormat:@"%zd%02zd",startComponents.year, startComponents.month];
        NSString *endDateString = startDateString;
        
        return endDateString;
    }
    else if (_chooseType == DJChooseTypeMuti) {
        
        NSDate *startDate = _minDate;
        NSDate *endDate = _maxDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _maxDate;
            endDate = _minDate;
        }
        
        NSDateComponents *endComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:endDate];
        
        NSString *endDateString = [NSString stringWithFormat:@"%zd%02zd",endComponents.year, endComponents.month];
        
        return endDateString;
    }
    return @"";
}

- (NSString *)showInLabelStrForTypeMonth
{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _gregorian.minimumDaysInFirstWeek = DJMinimumDaysInFirstWeek;
    }
    
    if (_chooseType == DJChooseTypeSingle) {
        
        NSDate *date = _minDate;
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];

        NSString *labelString = [NSString stringWithFormat:@"%zd年%zd月", startComponents.year, startComponents.month];
        
        return labelString;
    }
    else if (_chooseType == DJChooseTypeMuti) {
        
        NSDate *startDate = _minDate;
        NSDate *endDate = _maxDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _maxDate;
            endDate = _minDate;
        }
        
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:startDate];
        NSDateComponents *endComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:endDate];
        
        NSString *labelString = [NSString stringWithFormat:@"%zd月-%zd月", startComponents.month, endComponents.month];
        
        return labelString;
    }
    return @"";
}


#pragma mark - DJCalendarTypeYear
- (NSString *)minDateApiStrForTypeYear
{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _gregorian.minimumDaysInFirstWeek = DJMinimumDaysInFirstWeek;
    }
    
    if (_chooseType == DJChooseTypeSingle) {
        
        NSDate *date = _minDate;
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear fromDate:date];
        
        NSString *startDateString = [NSString stringWithFormat:@"%zd",startComponents.year];
        
        return startDateString;
        
    }
    else if (_chooseType == DJChooseTypeMuti) {
        
        NSDate *startDate = _minDate;
        NSDate *endDate = _maxDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _maxDate;
            endDate = _minDate;
        }
        
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear fromDate:startDate];
        
        NSString *startDateString = [NSString stringWithFormat:@"%zd", startComponents.year];
    
        return startDateString;
    }
    return @"";
}

- (NSString *)maxDateApiStrForTypeYear
{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _gregorian.minimumDaysInFirstWeek = DJMinimumDaysInFirstWeek;
    }
    
    if (_chooseType == DJChooseTypeSingle) {
        
        NSDate *date = _minDate;
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear fromDate:date];
        
        NSString *startDateString = [NSString stringWithFormat:@"%zd",startComponents.year];
        
        return startDateString;
        
    }
    else if (_chooseType == DJChooseTypeMuti) {
        
        NSDate *startDate = _minDate;
        NSDate *endDate = _maxDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _maxDate;
            endDate = _minDate;
        }
        
        NSDateComponents *endComponents = [_gregorian components:NSCalendarUnitYear fromDate:endDate];
        
        NSString *endDateString = [NSString stringWithFormat:@"%zd", endComponents.year];
        
        return endDateString;
    }
    return @"";
}

- (NSString *)showInLabelStrForTypeYear
{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _gregorian.minimumDaysInFirstWeek = DJMinimumDaysInFirstWeek;
    }
    
    if (_chooseType == DJChooseTypeSingle) {
        
        NSDate *date = _minDate;
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear fromDate:date];
        
        NSString *labelString = [NSString stringWithFormat:@"%zd年", startComponents.year];
        
        return labelString;
        
    }
    else if (_chooseType == DJChooseTypeMuti) {
        
        NSDate *startDate = _minDate;
        NSDate *endDate = _maxDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _maxDate;
            endDate = _minDate;
        }
        
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear fromDate:startDate];
        NSDateComponents *endComponents = [_gregorian components:NSCalendarUnitYear fromDate:endDate];
        
        NSString *labelString = [NSString stringWithFormat:@"%zd年-%zd年", startComponents.year, endComponents.year];
        
        return labelString;
    }
    return @"";
}




@end
