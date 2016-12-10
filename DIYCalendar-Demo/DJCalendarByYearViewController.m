//
//  DJCalendarByYearViewController.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/7.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DJCalendarByYearViewController.h"
#import "DJCalendarSubTableViewCell.h"
#import "DJToastView.h"

@interface DJCalendarByYearViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSDate *> *yearArr;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *selectArr;

@property (nonatomic, strong) NSCalendar *gregorian;

@property (nonatomic, strong) DJToastView *middleToast;
@property (nonatomic, strong) DJToastView *bottomToast;

@end

@implementation DJCalendarByYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initYearDataArr];
    [_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateUI];
    [_tableView reloadData];
}

- (void)updateUI
{
    _bottomToast.titlelabel.text = @"请选择日期";
    
    if (_fatherVC.calendarObject.calendarType != DJCalendarTypeYear) {
        [self setupDefaultValue];
        [self initYearDataArr];
    }
}

- (void)loadView
{
    [self setupDefaultValue];
    
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
    
    [self addToastView];
    
}

- (void)viewWillLayoutSubviews
{
    _tableView.frame = self.view.bounds;
    _middleToast.frame = CGRectMake(0, 0, 150, 40);
    _middleToast.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    _bottomToast.frame = CGRectMake(0, 0, 150, 40);
    _bottomToast.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - 60);
}

- (void)addToastView
{
    DJToastView *mToast = [[DJToastView alloc] initWithFrame:CGRectZero];
    mToast.titlelabel.text = @"最多可选12年";
    [self.view addSubview:mToast];
    mToast.alpha = 0.0;
    self.middleToast = mToast;
    
    DJToastView *bToast = [[DJToastView alloc] initWithFrame:CGRectZero];
    bToast.titlelabel.text = @"请选择日期";
    [self.view addSubview:bToast];
    self.bottomToast = bToast;
    
}

- (void)setupDefaultValue
{
    self.selectArr = [NSMutableArray array];
    self.yearArr = [NSMutableArray array];
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
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
- (void)initYearDataArr
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
            [_selectArr removeAllObjects];
        }
        
        [_selectArr addObject:indexPath];
        [self submitDate];
    }
    else {
        
        if (_selectArr.count >= 2) {
            [_selectArr removeAllObjects];
        }
        
        if (![_selectArr containsObject:indexPath]) {
            if (![self isValidRangeOfYear:_selectArr.firstObject indexPath:indexPath]) {
                [UIView animateWithDuration:0.15f animations:^{
                    _middleToast.alpha = 1;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:1.f animations:^{
                        _middleToast.alpha = 0.3;
                    } completion:^(BOOL finished) {
                        _middleToast.alpha = 0.0;
                    }];
                }];
                return;
            }
            
            [_selectArr addObject:indexPath];
        }
        else {
            [_selectArr removeObject:indexPath];
        }
        
        if (_selectArr.count == 0) {
            [_bottomToast updateTitleText:@"请选择日期"];
        }
        else if (_selectArr.count == 1) {
            [_bottomToast updateTitleText:@"请再选择一个日期"];
        }
        else if (_selectArr.count >=2) {
            [self submitDate];
        }
    }
}


- (void)submitDate
{
    if (_chooseType == DJChooseTypeSingle) {
        NSIndexPath *indexPath = _selectArr.firstObject;
        
        NSDate *date = _yearArr[indexPath.row];
        
        DJCalendarObject *object = [[DJCalendarObject alloc] init];
        object.calendarType = DJCalendarTypeYear;
        object.chooseType = _chooseType;
        object.minDate = date;
        object.maxDate = date;
        
        _fatherVC.callBackBlock(object);
        [_fatherVC dismissViewController];
        
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
        
        DJCalendarObject *object = [[DJCalendarObject alloc] init];
        object.calendarType = DJCalendarTypeYear;
        object.chooseType = _chooseType;
        object.minDate = startDate;
        object.maxDate = endDate;
        
        _fatherVC.callBackBlock(object);
        [_fatherVC dismissViewController];
        
    }
}

- (BOOL)isValidRangeOfYear:(NSIndexPath *)indexPathX indexPath:(NSIndexPath *)indexPathY
{
    if (indexPathX == nil) {
        return YES;
    }
    
    NSDate *startDate = _yearArr[indexPathX.row];
    NSDate *endDate = _yearArr[indexPathY.row];
    
    NSDateComponents *resultComponents = [_gregorian components:NSCalendarUnitYear fromDate:startDate toDate:endDate options:0];
    
    NSInteger result = labs(resultComponents.year);
    // 限制年份跨度12年
    if (result <= 12) {
        return  YES;
    }
    return NO;
}

@end
