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
#import "DJToastView.h"

@interface DJCalendarWeekDataObject : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, strong) NSMutableArray<NSDate *> *weekArr;

@end

@implementation DJCalendarWeekDataObject

@end

//gregorian
@interface DJCalendarByWeekViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;// left tableview
@property (nonatomic, strong) UITableView *subTableView;// right tableview

@property (nonatomic, strong) NSMutableArray<DJCalendarWeekDataObject *> *weekDataArr;
@property (nonatomic, assign) NSInteger mainTableViewCurrentRow;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *selectArr;

@property (nonatomic, strong) NSCalendar *gregorian;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) DJToastView *middleToast;
@property (nonatomic, strong) DJToastView *bottomToast;

@end

@implementation DJCalendarByWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWeekDataArr];
    
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
    
    if (_fatherVC.calendarObject.calendarType != DJCalendarTypeWeek) {
        [self setupDefaultValue];
        [self initWeekDataArr];
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
        subTableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
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
    mToast.titlelabel.text = @"最多可选8周";
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
    self.weekDataArr = [NSMutableArray array];
    
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
        NSDate *secondDate = [_gregorian dateByAddingComponents:dateComponentsAsTimeQantum toDate:firstDate options:0];
        
        NSDateComponents *fComponents = [_gregorian components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear fromDate:firstDate];
        NSDateComponents *sComponents = [_gregorian components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear fromDate:secondDate];
        
        NSString *firstStr = [NSString stringWithFormat:@"第%zd周", fComponents.weekOfYear];
        NSString *secondStr = [NSString stringWithFormat:@" (%zd月%zd日-%zd月%zd日)", fComponents.month, fComponents.day, sComponents.month, sComponents.day];
        if ([self isInWeekend:firstDate]) {
            secondStr = [secondStr stringByAppendingString:@" 本周"];
        }
        
        NSString *finalStr = [firstStr stringByAppendingString:secondStr];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:finalStr];
        
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, firstStr.length)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(firstStr.length, secondStr.length)];
        
        [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x79828f) range:NSMakeRange(0, firstStr.length + secondStr.length)];
        
        cell.calendarLabel.attributedText = attrStr;
        [cell.calendarLabel sizeToFit];
        
        if (_chooseType == DJChooseTypeSingle) {
            if ([_selectArr containsObject:indexPath]) {
                cell.cellSelectionType = CellSelectionTypeSingle;
            }
            else {
                cell.cellSelectionType = CellSelectionTypeNone;
            }
        }
        else if (_chooseType == DJChooseTypeMuti) {
            if ([_selectArr containsObject:indexPath]) {
                cell.cellSelectionType = CellSelectionTypeMutiBorder;
            }
            else if ([self isBetweenRangeOfSelected:indexPath]) {
                cell.cellSelectionType = CellSelectionTypeMutiMiddle;
            }
            else {
                cell.cellSelectionType = CellSelectionTypeNone;
            }
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
        [self clickAction:indexPath];
        [tableView reloadData];
    }
}


- (BOOL)isInWeekend:(NSDate *)date
{
    NSDateComponents *dateComponents = [_gregorian components:NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear fromDate:date];
    NSDateComponents *currentComponents = [_gregorian components:NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear fromDate:[NSDate date]];
    
    if (dateComponents.weekOfYear == currentComponents.weekOfYear && dateComponents.yearForWeekOfYear == currentComponents.yearForWeekOfYear) {
        return YES;
    }
    return NO;
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
        
        NSDateComponents *startDateComponents = [_gregorian components:NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear fromDate:startDate];
        NSDateComponents *endDateComponents = [_gregorian components:NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear fromDate:endDate];
        
        NSMutableArray *yearArr = [NSMutableArray array];
        for (NSInteger i=endDateComponents.yearForWeekOfYear; i>=startDateComponents.yearForWeekOfYear; i--) {
            DJCalendarWeekDataObject *obj = [[DJCalendarWeekDataObject alloc] init];
            obj.year = i;
            obj.weekArr = [NSMutableArray array];
            
            NSInteger weekCountMax = endDateComponents.weekOfYear;
            if (i<endDateComponents.yearForWeekOfYear) {
                NSDateComponents *dateComponentsForLastDay = [[NSDateComponents alloc] init];
                [dateComponentsForLastDay setDay:28];
                [dateComponentsForLastDay setMonth:12];
                [dateComponentsForLastDay setYear:i];
                NSDate *dateFromDateComponentsForLastDate = [_gregorian dateFromComponents:dateComponentsForLastDay];
                NSDateComponents *dateComponents = [_gregorian components:NSCalendarUnitWeekOfYear fromDate:dateFromDateComponentsForLastDate];
                weekCountMax = dateComponents.weekOfYear;
            }
            NSInteger weekCountMin = endDateComponents.weekOfYear;
            if (i>startDateComponents.yearForWeekOfYear) {
                weekCountMin = 1;
            }
            
            for (NSInteger j=weekCountMax; j>=weekCountMin; j--) {
                NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
                [dateComponentsForDate setWeekday:2];
                [dateComponentsForDate setWeekOfYear:j];
                [dateComponentsForDate setYearForWeekOfYear:i];
                NSDate *dateFromDateComponentsForDate = [_gregorian dateFromComponents:dateComponentsForDate];
                [obj.weekArr addObject:dateFromDateComponentsForDate];
                
            }
            if (obj.weekArr.count > 0) {
                [yearArr addObject:obj];
            }
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
            if (![self isValidRangeOfWeek:_selectArr.firstObject indexPath:indexPath]) {
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
        DJCalendarWeekDataObject *obj = _weekDataArr[indexPath.section];
        
        NSDate *date = obj.weekArr[indexPath.row];
        
        DJCalendarObject *object = [[DJCalendarObject alloc] init];
        object.calendarType = DJCalendarTypeWeek;
        object.chooseType = _chooseType;
        object.minDate = date;
        object.maxDate = date;
        
        _fatherVC.callBackBlock(object);
        [_fatherVC dismissViewController];
    }
    else if (_chooseType == DJChooseTypeMuti) {
        NSIndexPath *startIndexPath = _selectArr.firstObject;
        NSIndexPath *endIndexPath = _selectArr.lastObject;
        
        DJCalendarWeekDataObject *startObj = _weekDataArr[startIndexPath.section];
        DJCalendarWeekDataObject *endObj = _weekDataArr[endIndexPath.section];
        
        NSDate *startDate = startObj.weekArr[startIndexPath.row];
        NSDate *endDate = endObj.weekArr[endIndexPath.row];
        if ([startDate timeIntervalSinceDate:endDate] > 0) {
            startDate = endObj.weekArr[endIndexPath.row];
            endDate = startObj.weekArr[startIndexPath.row];
        }
        
        DJCalendarObject *object = [[DJCalendarObject alloc] init];
        object.calendarType = DJCalendarTypeWeek;
        object.chooseType = _chooseType;
        object.minDate = startDate;
        object.maxDate = endDate;
        
        _fatherVC.callBackBlock(object);
        [_fatherVC dismissViewController];
    }
}

- (BOOL)isValidRangeOfWeek:(NSIndexPath *)indexPathX indexPath:(NSIndexPath *)indexPathY
{
    if (indexPathX == nil) {
        return YES;
    }
    
    DJCalendarWeekDataObject *startObj = _weekDataArr[indexPathX.section];
    DJCalendarWeekDataObject *endObj = _weekDataArr[indexPathY.section];
    
    NSDate *startDate = startObj.weekArr[indexPathX.row];
    NSDate *endDate = endObj.weekArr[indexPathY.row];
    
    NSDateComponents *resultComponents = [_gregorian components:NSCalendarUnitWeekOfYear fromDate:startDate toDate:endDate options:0];
    
    NSInteger result = labs(resultComponents.weekOfYear);
    // 限制周跨度8周
    if (result <= 8) {
        return  YES;
    }
    return NO;
}

- (BOOL)isBetweenRangeOfSelected:(NSIndexPath *)indexPath
{
    if (_selectArr.count < 2) {
        return NO;
    }
    
    NSIndexPath *indexPathX = _selectArr.firstObject;
    NSIndexPath *indexPathY = _selectArr.lastObject;
    
    DJCalendarWeekDataObject *obj = _weekDataArr[indexPath.section];
    DJCalendarWeekDataObject *objX = _weekDataArr[indexPathX.section];
    DJCalendarWeekDataObject *objY = _weekDataArr[indexPathY.section];
    
    NSDate *date = obj.weekArr[indexPath.row];
    NSDate *dateX = objX.weekArr[indexPathX.row];
    NSDate *dateY = objY.weekArr[indexPathY.row];
    
    NSDateComponents *dateFromX = [_gregorian components:NSCalendarUnitWeekOfYear fromDate:date toDate:dateX options:0];
    NSDateComponents *dateFromY = [_gregorian components:NSCalendarUnitWeekOfYear fromDate:date toDate:dateY options:0];
    NSDateComponents *xFromY = [_gregorian components:NSCalendarUnitWeekOfYear fromDate:dateX toDate:dateY options:0];
    
    NSInteger d_X = labs(dateFromX.weekOfYear);
    NSInteger d_Y = labs(dateFromY.weekOfYear);
    NSInteger x_Y = labs(xFromY.weekOfYear);
    
    if (d_X + d_Y == x_Y) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)forceClearData
{
    [_selectArr removeAllObjects];
    _mainTableViewCurrentRow = 0;
    [_mainTableView reloadData];
    [_subTableView reloadData];
}
@end
