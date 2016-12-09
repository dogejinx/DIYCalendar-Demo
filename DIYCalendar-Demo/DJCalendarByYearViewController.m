//
//  DJCalendarByYearViewController.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/7.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DJCalendarByYearViewController.h"
#import "DJCalendarSubTableViewCell.h"

@interface DJCalendarByYearViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSDate *> *yearArr;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *selectArr;

@property (nonatomic, strong) NSCalendar *gregorian;

@end

@implementation DJCalendarByYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initYearArr];
    [_tableView reloadData];
}

- (void)loadView
{
    [self initDefaultValues];
    
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[DJCalendarSubTableViewCell class] forCellReuseIdentifier:@"DJCalendarSubTableViewCell"];
    
    [view addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)viewDidLayoutSubviews
{
    _tableView.frame = self.view.bounds;
}

- (void)initDefaultValues
{
    self.selectArr = [NSMutableArray array];
    self.yearArr = [NSMutableArray array];
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _gregorian.firstWeekday = 2;
    _gregorian.minimumDaysInFirstWeek = 4;
    
}

#pragma mark - UItableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _yearArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DJCalendarSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJCalendarSubTableViewCell" forIndexPath:indexPath];
    
    NSDate *date = _yearArr[indexPath.row];
    NSInteger yearInt = [_gregorian component:NSCalendarUnitYear fromDate:date];
    cell.calendarLabel.text = [NSString stringWithFormat:@"%zd年", yearInt];
    if ([_selectArr containsObject:indexPath]) {
        cell.choose = YES;
    }
    else {
        cell.choose = NO;
    }
    
    return cell;
}

#pragma mark - UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self clickAction:indexPath];
    
    [tableView reloadData];
}

#pragma mark -
- (void)initYearArr
{
    if (_calendarStartDate && _calendarEndDate) {
        NSDate *startDate = _calendarStartDate;
        NSDate *endDate = _calendarEndDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _calendarEndDate;
            endDate = _calendarStartDate;
        }
    
        NSInteger startDateYear = [_gregorian component:NSCalendarUnitYear fromDate:startDate];
        NSInteger endDateYear = [_gregorian component:NSCalendarUnitYear fromDate:endDate];
        
        NSMutableArray *yearArr = [NSMutableArray array];
        for (NSInteger i=endDateYear; i>=startDateYear; i--) {
            NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
            [dateComponentsForDate setDay:1];
            [dateComponentsForDate setMonth:1];
            [dateComponentsForDate setYear:i];
            NSDate *dateFromDateComponentsForDate = [_gregorian dateFromComponents:dateComponentsForDate];
            [yearArr addObject:dateFromDateComponentsForDate];
        }
        _yearArr = yearArr;
    }
}

- (void)clickAction:(NSIndexPath *)indexPath {
    if (_chooseType == DJChooseTypeSingle) {
        if (_selectArr.count >= 1) {
            return;
        }
        
        [_selectArr addObject:indexPath];
        [self submitDate];
    }
    else {
        if (_selectArr.count >= 2) {
            return;
        }
        
        if (![_selectArr containsObject:indexPath]) {
            [_selectArr addObject:indexPath];
        }
        else {
            [_selectArr removeObject:indexPath];
        }
        if (_selectArr.count >=2) {
            [self submitDate];
        }
    }
}


- (void)submitDate
{
    if (_chooseType == DJChooseTypeSingle) {
        NSIndexPath *indexPath = _selectArr.firstObject;
        
        NSDate *date = _yearArr[indexPath.row];
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear fromDate:date];
        
        NSString *startDateString = [NSString stringWithFormat:@"%zd",startComponents.year];
        NSString *endDateString = startDateString;
        NSString *labelString = [NSString stringWithFormat:@"%zd年", startComponents.year];
        _fatherVC.callBackBlock(_chooseType, DJCalendarTypeYear, startDateString, endDateString, labelString);
        
    }
    else if (_chooseType == DJChooseTypeMuti) {
        NSIndexPath *startIndexPath = _selectArr.firstObject;
        NSIndexPath *endIndexPath = _selectArr.lastObject;
        
        NSDate *startDate = _yearArr[startIndexPath.row];
        NSDate *endDate = _yearArr[endIndexPath.row];
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _yearArr[endIndexPath.row];
            endDate = _yearArr[startIndexPath.row];
        }
        
        NSDateComponents *startComponents = [_gregorian components:NSCalendarUnitYear fromDate:startDate];
        NSDateComponents *endComponents = [_gregorian components:NSCalendarUnitYear fromDate:endDate];
        
        NSString *startDateString = [NSString stringWithFormat:@"%zd", startComponents.year];
        NSString *endDateString = [NSString stringWithFormat:@"%zd", endComponents.year];
        NSString *labelString = [NSString stringWithFormat:@"%zd年-%zd年", startComponents.year, endComponents.year];
        
        _fatherVC.callBackBlock(_chooseType, DJCalendarTypeYear, startDateString, endDateString, labelString);
        [_fatherVC dismissViewControllerAnimated:YES completion:nil];
        
    }
}

@end
