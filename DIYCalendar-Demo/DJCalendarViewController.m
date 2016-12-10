//
//  DJCalendarViewController.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/4.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DJCalendarViewController.h"
#import "DJCalendarByDateViewController.h"
#import "DJCalendarByWeekViewController.h"
#import "DJCalendarByMonthViewController.h"
#import "DJCalendarByYearViewController.h"

@interface DJCalendarViewController ()<UIScrollViewDelegate, DJCalendarHeaderViewDelegate>

@property (nonatomic, strong) DJCalendarHeaderView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) DJCalendarByDateViewController *byDateVC;
@property (nonatomic, strong) DJCalendarByWeekViewController *byWeekVC;
@property (nonatomic, strong) DJCalendarByMonthViewController *byMonthVC;
@property (nonatomic, strong) DJCalendarByYearViewController *byYearVC;

@end

@implementation DJCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择日期范围";
    
    [self addNavigationBarItem];
    
}

- (void)addNavigationBarItem {
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backItemClicked:)];
    
    self.navigationItem.leftBarButtonItems = @[backItem];
    
}

- (void)loadView
{
    if (!_calendarStartDate && !_calendarEndDate) {
        self.calendarStartDate = [self.dateFormatter dateFromString:@"2011-01-02"];
        self.calendarEndDate = [NSDate date];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    DJCalendarHeaderView *headerView = [[DJCalendarHeaderView alloc] initWithFrame:CGRectMake(0, 64, view.frame.size.width, 44)];
    headerView.delegate = self;
    [view addSubview:headerView];
    self.headerView = headerView;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + headerView.frame.size.height, view.bounds.size.width, view.bounds.size.height - 64 - headerView.frame.size.height)];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 4, scrollView.frame.size.height);
    [view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    
    [self setupSubViewController];
}

- (void)setupSubViewController
{
    // 设置 日Page
    {
        DJCalendarByDateViewController *byDate = [[DJCalendarByDateViewController alloc] init];
        byDate.calendarStartDate = _calendarStartDate;
        byDate.calendarEndDate = _calendarEndDate;
        byDate.chooseType = _chooseType;
        byDate.fatherVC = self;
        [self addChildViewController:byDate];
        [byDate didMoveToParentViewController:self];
        self.byDateVC = byDate;
        // 解决UICollectionView中 Cell宽度必须为整数的BUG
        CGFloat orgin_X = 0;
        CGFloat byDateView_Width = _scrollView.bounds.size.width;
        CGFloat screen_Width = [UIScreen mainScreen].bounds.size.width;
        if (screen_Width == 320) {
            orgin_X = 2.5;
            byDateView_Width = byDateView_Width - 5.0;
        }
        else if (screen_Width == 375) {
            orgin_X = 2.0;
            byDateView_Width = byDateView_Width - 4.0;
        }
        else if (screen_Width == 414) {
            orgin_X = 1.0;
            byDateView_Width = byDateView_Width - 1.0;
        }
        
        byDate.view.frame = CGRectMake(orgin_X, 0, byDateView_Width, _scrollView.bounds.size.height);
        [_scrollView addSubview:byDate.view];
    }
    
    // 设置 周Page
    {
        DJCalendarByWeekViewController * byWeek = [[DJCalendarByWeekViewController alloc] init];
        byWeek.calendarStartDate = _calendarStartDate;
        byWeek.calendarEndDate = _calendarEndDate;
        byWeek.chooseType = _chooseType;
        byWeek.fatherVC = self;
        [self addChildViewController:byWeek];
        [byWeek didMoveToParentViewController:self];
        self.byWeekVC = byWeek;
        
        byWeek.view.frame = CGRectMake(1 * _scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        [_scrollView addSubview:byWeek.view];
    }

    // 设置 月Page
    {
        DJCalendarByMonthViewController * byMonth = [[DJCalendarByMonthViewController alloc] init];
        byMonth.calendarStartDate = _calendarStartDate;
        byMonth.calendarEndDate = _calendarEndDate;
        byMonth.chooseType = _chooseType;
        byMonth.fatherVC = self;
        [self addChildViewController:byMonth];
        [byMonth didMoveToParentViewController:self];
        self.byMonthVC = byMonth;
        
        byMonth.view.frame = CGRectMake(2 * _scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        [_scrollView addSubview:byMonth.view];
    }
    // 设置 年Page
    {
        DJCalendarByYearViewController * byYear = [[DJCalendarByYearViewController alloc] init];
        byYear.calendarStartDate = _calendarStartDate;
        byYear.calendarEndDate = _calendarEndDate;
        byYear.chooseType = _chooseType;
        byYear.fatherVC = self;
        [self addChildViewController:byYear];
        [byYear didMoveToParentViewController:self];
        self.byYearVC = byYear;
        
        byYear.view.frame = CGRectMake(3 * _scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        [_scrollView addSubview:byYear.view];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _scrollView.frame = CGRectMake(0, 64 + _headerView.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - 64 - _headerView.frame.size.height);
}

#pragma mark - Target Actions

- (void)backItemClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x / scrollView.contentSize.width;
    [_headerView updateLinePath:offset];
}

#pragma mark - DJCalendarHeaderViewDelegate
- (void)dj_calendar:(DJCalendarHeaderView *)calendarHeaderView didSelectPageAtIndex:(NSInteger)index
{
    CGFloat offset_X = _scrollView.bounds.size.width * index;
    [_scrollView setContentOffset:CGPointMake(offset_X, 0) animated:YES];
}

- (void)setup:(DJCalendarObject *)obj minDate:(NSString *)minDate maxDate:(NSString *)maxDate block:(CallBackBlock)block
{
    if (_calendarObject && _chooseType != obj.chooseType) {
        [_byDateVC forceClearData];
        [_byWeekVC forceClearData];
        [_byMonthVC forceClearData];
        [_byYearVC forceClearData];
    }
    
    self.calendarObject = obj;
    self.chooseType = obj.chooseType;
    NSDate *startDate = [self.dateFormatter dateFromString:minDate];
    NSDate *endDate = [self.dateFormatter dateFromString:maxDate];
    self.calendarStartDate = startDate;
    self.calendarEndDate = endDate;
    self.callBackBlock = block;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setChooseType:(DJChooseType)chooseType
{
    _chooseType = chooseType;
    _byDateVC.chooseType = chooseType;
    _byWeekVC.chooseType = chooseType;
    _byMonthVC.chooseType = chooseType;
    _byYearVC.chooseType = chooseType;
}

@end
