//
//  DJCalendarByWeekViewController.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/7.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DJCalendarByWeekViewController.h"
#import "DJCalendarMainTableViewCell.h"
#import "DJCalendarSubTableViewCell.h"
#import "DJTableViewHeader.h"

@interface DJCalendarWeekDataObject : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, strong) NSMutableArray<NSDate *> *weekArr;

@end

@implementation DJCalendarWeekDataObject

@end


@interface DJCalendarByWeekViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;// left tableview
@property (nonatomic, strong) UITableView *subTableView;// right tableview

@property (nonatomic, strong) NSMutableArray<DJCalendarWeekDataObject *> *weekDataArr;
@property (nonatomic, assign) NSInteger mainTableViewCurrentRow;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *selectArr;

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, assign) CGFloat headerHeight;

@end

@implementation DJCalendarByWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWeekDataArr];
    [_mainTableView reloadData];
    [_subTableView reloadData];
}

- (void)loadView
{
    [self setupDefaultValue];
    
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    {
        UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        mainTableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        mainTableView.tag = 11;
        mainTableView.rowHeight = 45.f;
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [mainTableView registerClass:[DJCalendarMainTableViewCell class] forCellReuseIdentifier:@"DJCalendarMainTableViewCell"];
        
        [view addSubview:mainTableView];
        self.mainTableView = mainTableView;
    }
    
    {
        UITableView *subTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        subTableView.backgroundColor = [UIColor whiteColor];
        subTableView.tag = 22;
        subTableView.rowHeight = 45.f;
        subTableView.delegate = self;
        subTableView.dataSource = self;
        subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [subTableView registerClass:[DJCalendarSubTableViewCell class] forCellReuseIdentifier:@"DJCalendarSubTableViewCell"];
        
        [view addSubview:subTableView];
        self.subTableView = subTableView;
    }
    
}

- (void)viewDidLayoutSubviews
{
    _mainTableView.frame = CGRectMake(0, 0, 100, self.view.bounds.size.height);
    _subTableView.frame = CGRectMake(_mainTableView.bounds.size.width, 0, self.view.bounds.size.width - _mainTableView.bounds.size.width, self.view.bounds.size.height);
}

- (void)setupDefaultValue
{
    self.selectArr = [NSMutableArray array];
    self.weekDataArr = [NSMutableArray array];
    
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _calendar.firstWeekday = 2;
    self.headerHeight = 30.f;
    self.mainTableViewCurrentRow = 0;
}

#pragma mark - UItableViewDateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 11) {
        return  1;
    }
    else {
        return _weekDataArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 11) {
        return _weekDataArr.count;
    }
    else {
        DJCalendarWeekDataObject *obj = _weekDataArr[section];
        return obj.weekArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 11) {
        DJCalendarMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJCalendarMainTableViewCell" forIndexPath:indexPath];
        
        DJCalendarWeekDataObject *obj = _weekDataArr[indexPath.row];
        cell.calendarLabel.text = [NSString stringWithFormat:@"%zd年", obj.year];
        
        
        if (_mainTableViewCurrentRow == indexPath.row) {
            cell.choose = YES;
        }
        else {
            cell.choose = NO;
        }
        
        return cell;
    }
    else {
        DJCalendarSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJCalendarSubTableViewCell" forIndexPath:indexPath];
        
        DJCalendarWeekDataObject *obj = _weekDataArr[indexPath.section];
        NSDate *firstDate = obj.weekArr[indexPath.row];
        
        NSDateComponents *dateComponentsAsTimeQantum = [[NSDateComponents alloc] init];
        [dateComponentsAsTimeQantum setDay:6];
        // 在当前历法下，获取6天后的时间点
        NSDate *secondDate = [_calendar dateByAddingComponents:dateComponentsAsTimeQantum toDate:firstDate options:0];
        
        NSDateComponents *fComponents = [_calendar components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear fromDate:firstDate];
        NSDateComponents *sComponents = [_calendar components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear fromDate:secondDate];
        
        NSString *firstStr = [NSString stringWithFormat:@"第%zd周", fComponents.weekOfYear];
        NSString *secondStr = [NSString stringWithFormat:@"(%zd月%zd日-%zd月%zd日)", fComponents.month, fComponents.day, sComponents.month, sComponents.day];
        
        cell.calendarLabel.text = [NSString stringWithFormat:@"%@%@", firstStr, secondStr];
        
        if ([_selectArr containsObject:indexPath]) {
            cell.choose = YES;
        }
        else {
            cell.choose = NO;
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 11) {
        return 0;
    }
    else {
        return _headerHeight;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 11) {
        return nil;
    }
    else {
        
        DJTableViewHeader * header = [[DJTableViewHeader alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, _headerHeight)];
        DJCalendarWeekDataObject *obj = _weekDataArr[section];
        header.titleLabel.text = [NSString stringWithFormat:@"%zd年", obj.year];
        
        return header;
    }
}


#pragma mark - UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 11) {
        
        _mainTableViewCurrentRow = indexPath.row;
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        [_subTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else {
        if (![_selectArr containsObject:indexPath]) {
            [_selectArr addObject:indexPath];
        }
        else {
            [_selectArr removeObject:indexPath];
        }
        
    }
    
    [tableView reloadData];
}

- (void)initWeekDataArr
{
    if (_calendarStartDate && _calendarEndDate) {
        NSDate *startDate = _calendarStartDate;
        NSDate *endDate = _calendarEndDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _calendarEndDate;
            endDate = _calendarStartDate;
        }
        
        NSDateComponents *startDateComponents = [_calendar components:NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear fromDate:startDate];
        NSDateComponents *endDateComponents = [_calendar components:NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear fromDate:endDate];
        
        NSMutableArray *yearArr = [NSMutableArray array];
        for (NSInteger i=endDateComponents.yearForWeekOfYear; i>=startDateComponents.yearForWeekOfYear; i--) {
            DJCalendarWeekDataObject *obj = [[DJCalendarWeekDataObject alloc] init];
            obj.year = i;
            obj.weekArr = [NSMutableArray array];
            
            NSInteger weekCountMax = endDateComponents.weekOfYear;
            if (i<endDateComponents.yearForWeekOfYear) {
                weekCountMax = 52;
            }
            NSInteger weekCountMin = endDateComponents.weekOfYear;
            if (i>startDateComponents.yearForWeekOfYear) {
                weekCountMin = 1;
            }
            
            for (NSInteger j=weekCountMax; j>=weekCountMin; j--) {
                NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
                [dateComponentsForDate setWeekday:2];
                [dateComponentsForDate setWeekOfYear:j];
                [dateComponentsForDate setYear:i];
                NSDate *dateFromDateComponentsForDate = [_calendar dateFromComponents:dateComponentsForDate];
                [obj.weekArr addObject:dateFromDateComponentsForDate];
                
            }
            [yearArr addObject:obj];
        }
        _weekDataArr = yearArr;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UITableView *tableView = (UITableView *)scrollView;
    if (tableView.tag == 22) {
        NSArray* indexPathArr = [tableView indexPathsForVisibleRows];
        NSIndexPath *path = indexPathArr.firstObject;
        _mainTableViewCurrentRow = path.section;
        NSLog(@"_mainTableViewCurrentRow: %zd", _mainTableViewCurrentRow);
        [_mainTableView reloadData];
    }
}


@end
