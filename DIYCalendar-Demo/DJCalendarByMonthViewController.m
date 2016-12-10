//
//  DJCalendarByMonthViewController.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/7.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DJCalendarByMonthViewController.h"
#import "DJCalendarMainTableViewCell.h"
#import "DJCalendarSubTableViewCell.h"
#import "DJTableViewHeader.h"
#import "DJToastView.h"

@interface DJCalendarMonthDataObject : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, strong) NSMutableArray<NSDate *> *monthArr;

@end

@implementation DJCalendarMonthDataObject

@end


@interface DJCalendarByMonthViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;// left tableview
@property (nonatomic, strong) UITableView *subTableView;// right tableview

@property (nonatomic, strong) NSMutableArray<DJCalendarMonthDataObject *> *monthDataArr;
@property (nonatomic, assign) NSInteger mainTableViewCurrentRow;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *selectArr;

@property (nonatomic, strong) NSCalendar *gregorian;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) DJToastView *middleToast;
@property (nonatomic, strong) DJToastView *bottomToast;

@end

@implementation DJCalendarByMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMonthDataArr];
    [_mainTableView reloadData];
    [_subTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateUI];
    [_mainTableView reloadData];
    [_subTableView reloadData];
}

- (void)updateUI
{
    [_bottomToast updateTitleText:@"请选择日期"];
    
    if (_fatherVC.calendarObject.calendarType != DJCalendarTypeMonth) {
        [self setupDefaultValue];
        [self initMonthDataArr];
    }
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
        subTableView.backgroundColor = UIColorFromRGB(0xf6f6f6);;
        subTableView.tag = 22;
        subTableView.rowHeight = 45.f;
        subTableView.delegate = self;
        subTableView.dataSource = self;
        subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [subTableView registerClass:[DJCalendarSubTableViewCell class] forCellReuseIdentifier:@"DJCalendarSubTableViewCell"];
        
        [view addSubview:subTableView];
        self.subTableView = subTableView;
    }
    
    [self addToastView];
    
}

- (void)viewWillLayoutSubviews
{
    _mainTableView.frame = CGRectMake(0, 0, 88, self.view.bounds.size.height);
    _subTableView.frame = CGRectMake(_mainTableView.bounds.size.width, 0, self.view.bounds.size.width - _mainTableView.bounds.size.width, self.view.bounds.size.height);
    _middleToast.frame = CGRectMake(0, 0, 150, 40);
    _middleToast.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    _bottomToast.frame = CGRectMake(0, 0, 150, 40);
    _bottomToast.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - 60);
}

- (void)addToastView
{
    DJToastView *mToast = [[DJToastView alloc] initWithFrame:CGRectZero];
    mToast.titlelabel.text = @"最多可选12个月";
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
    self.monthDataArr = [NSMutableArray array];
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _gregorian.minimumDaysInFirstWeek = 4;
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
        return _monthDataArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 11) {
        return _monthDataArr.count;
    }
    else {
        DJCalendarMonthDataObject *obj = _monthDataArr[section];
        return obj.monthArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 11) {
        DJCalendarMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJCalendarMainTableViewCell" forIndexPath:indexPath];
        
        DJCalendarMonthDataObject *obj = _monthDataArr[indexPath.row];
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
        
        DJCalendarMonthDataObject *obj = _monthDataArr[indexPath.section];
        NSDate *date = obj.monthArr[indexPath.row];
        NSInteger monthInt = [_gregorian component:NSCalendarUnitMonth fromDate:date];
        NSString *firstStr = [NSString stringWithFormat:@"%zd月", monthInt];
        NSString *secondStr = @"";
        
        if ([self isInMonth:date]) {
            secondStr = [secondStr stringByAppendingString:@" 本月"];
        }
        
        NSString *finalStr = [firstStr stringByAppendingString:secondStr];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:finalStr];
        
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, firstStr.length)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(firstStr.length, secondStr.length)];
        
        [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x79828f) range:NSMakeRange(0, firstStr.length + secondStr.length)];
        
        cell.calendarLabel.attributedText = attrStr;
        [cell.calendarLabel sizeToFit];
        
        
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
        if (section==0) {
            return 0.0;
        }
        else {
            return _headerHeight;
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 11) {
        return nil;
    }
    else {
        
        DJTableViewHeader * header = [[DJTableViewHeader alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, _headerHeight)];
        DJCalendarMonthDataObject *obj = _monthDataArr[section];
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
        [self clickAction:indexPath];
    }

    [tableView reloadData];
}

- (BOOL)isInMonth:(NSDate *)date
{
    NSDateComponents *dateComponents = [_gregorian components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSDateComponents *currentComponents = [_gregorian components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    if (dateComponents.year == currentComponents.year && dateComponents.month == currentComponents.month) {
        return YES;
    }
    return NO;
}

- (void)initMonthDataArr
{
    if (_calendarStartDate && _calendarEndDate) {
        NSDate *startDate = _calendarStartDate;
        NSDate *endDate = _calendarEndDate;
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = _calendarEndDate;
            endDate = _calendarStartDate;
        }
        
        NSDateComponents *startDateComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:startDate];
        NSDateComponents *endDateComponents = [_gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:endDate];
        
        NSMutableArray *yearArr = [NSMutableArray array];
        for (NSInteger i=endDateComponents.year; i>=startDateComponents.year; i--) {
            DJCalendarMonthDataObject *obj = [[DJCalendarMonthDataObject alloc] init];
            obj.year = i;
            obj.monthArr = [NSMutableArray array];
            
            NSInteger monthCountMax = endDateComponents.month;
            if (i<endDateComponents.year) {
                monthCountMax = 12;
            }
            NSInteger monthCountMin = endDateComponents.month;
            if (i>startDateComponents.year) {
                monthCountMin = 1;
            }
            
            for (NSInteger j=monthCountMax; j>=monthCountMin; j--) {
                NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
                [dateComponentsForDate setDay:1];
                [dateComponentsForDate setMonth:j];
                [dateComponentsForDate setYear:i];
                NSDate *dateFromDateComponentsForDate = [_gregorian dateFromComponents:dateComponentsForDate];
                [obj.monthArr addObject:dateFromDateComponentsForDate];
                
            }
            [yearArr addObject:obj];
        }
        _monthDataArr = yearArr;
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
        [_mainTableView reloadData];
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
            if (![self isValidRangeOfMonth:_selectArr.firstObject indexPath:indexPath]) {
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
        DJCalendarMonthDataObject *obj = _monthDataArr[indexPath.section];
        
        NSDate *date = obj.monthArr[indexPath.row];
        
        DJCalendarObject *object = [[DJCalendarObject alloc] init];
        object.calendarType = DJCalendarTypeMonth;
        object.chooseType = _chooseType;
        object.minDate = date;
        object.maxDate = date;
        
        _fatherVC.callBackBlock(object);
        [_fatherVC dismissViewController];
    }
    else if (_chooseType == DJChooseTypeMuti) {
        NSIndexPath *startIndexPath = _selectArr.firstObject;
        NSIndexPath *endIndexPath = _selectArr.lastObject;
        
        DJCalendarMonthDataObject *startObj = _monthDataArr[startIndexPath.section];
        DJCalendarMonthDataObject *endObj = _monthDataArr[endIndexPath.section];
        
        NSDate *startDate = startObj.monthArr[startIndexPath.row];
        NSDate *endDate = endObj.monthArr[endIndexPath.row];
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = endObj.monthArr[endIndexPath.row];
            endDate = startObj.monthArr[startIndexPath.row];
        }
        
        DJCalendarObject *object = [[DJCalendarObject alloc] init];
        object.calendarType = DJCalendarTypeMonth;
        object.chooseType = _chooseType;
        object.minDate = startDate;
        object.maxDate = endDate;
        
        _fatherVC.callBackBlock(object);
        [_fatherVC dismissViewController];

    }
}

- (BOOL)isValidRangeOfMonth:(NSIndexPath *)indexPathX indexPath:(NSIndexPath *)indexPathY
{
    if (indexPathX == nil) {
        return YES;
    }
    
    DJCalendarMonthDataObject *startObj = _monthDataArr[indexPathX.section];
    DJCalendarMonthDataObject *endObj = _monthDataArr[indexPathY.section];
    
    NSDate *startDate = startObj.monthArr[indexPathX.row];
    NSDate *endDate = endObj.monthArr[indexPathY.row];
    
    NSDateComponents *resultComponents = [_gregorian components:NSCalendarUnitMonth fromDate:startDate toDate:endDate options:0];
    
    NSInteger result = labs(resultComponents.month);
    // 限制月份跨度12月
    if (result <= 12) {
        return  YES;
    }
    return NO;
}

@end
