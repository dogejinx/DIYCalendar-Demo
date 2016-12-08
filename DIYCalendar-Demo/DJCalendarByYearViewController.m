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

@property (nonatomic, strong) NSCalendar *calendar;

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
    
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _calendar.firstWeekday = 2;
    
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
    NSInteger yearInt = [_calendar component:NSCalendarUnitYear fromDate:date];
    cell.calendarLabel.text = [NSString stringWithFormat:@"%zd年", yearInt];
    if ([_selectArr containsObject:indexPath]) {
        cell.choose = YES;
    }
    else {
        cell.choose = NO;
    }
    NSLog(@"indexPath - %zd:%@",indexPath.row ,cell.selected?@"YES":@"NO");
    
    return cell;
}

#pragma mark - UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_selectArr containsObject:indexPath]) {
        [_selectArr addObject:indexPath];
    }
    else {
        [_selectArr removeObject:indexPath];
    }
    
    [tableView reloadData];
}

- (void)initYearArr
{
    if (_calendarStartDate && _calendarEndDate) {
        NSDate *startDate = _calendarStartDate;
        NSDate *endDate = _calendarEndDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _calendarEndDate;
            endDate = _calendarStartDate;
        }
    
        NSInteger startDateYear = [_calendar component:NSCalendarUnitYear fromDate:startDate];
        NSInteger endDateYear = [_calendar component:NSCalendarUnitYear fromDate:endDate];
        
        NSMutableArray *yearArr = [NSMutableArray array];
        for (NSInteger i=endDateYear; i>=startDateYear; i--) {
            NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
            [dateComponentsForDate setDay:1];
            [dateComponentsForDate setMonth:1];
            [dateComponentsForDate setYear:i];
            NSDate *dateFromDateComponentsForDate = [_calendar dateFromComponents:dateComponentsForDate];
            [yearArr addObject:dateFromDateComponentsForDate];
        }
        _yearArr = yearArr;
    }
}


@end
