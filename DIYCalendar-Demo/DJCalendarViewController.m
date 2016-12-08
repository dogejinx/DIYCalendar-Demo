//
//  DJCalendarViewController.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/4.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DJCalendarViewController.h"
#import <EventKit/EventKit.h>
#import "FSCalendar.h"
#import "DJCalendarWeekView.h"
#import "DJCalendarByMonthViewController.h"
#import "DJCalendarByYearViewController.h"

@interface DJCalendarViewController ()<UIScrollViewDelegate, DJCalendarHeaderViewDelegate, FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DJCalendarHeaderView *headerView;
@property (nonatomic, strong) FSCalendar *calendar;

@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;

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
    self.scrollView = scrollView;
    
    [self setupSubViewController];
}

- (void)setupSubViewController
{
    /*
     暂时的背景色
     */
    for (NSInteger i =0; i<4; i++) {
        CGFloat x = i * _scrollView.bounds.size.width;
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
        v.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:(1 - 0.2 * i)];
        [_scrollView addSubview:v];
    }
    
    //
    DJCalendarWeekView *weekView = [[DJCalendarWeekView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.bounds.size.width, 44)];
    [_scrollView addSubview:weekView];
    
    // TODO:
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 40, _scrollView.bounds.size.width, _scrollView.bounds.size.height - 40)];
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.pagingEnabled = NO; // important
    calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    calendar.headerHeight = 40;
    calendar.weekdayHeight = 8;
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
    
    [_scrollView addSubview:calendar];
    self.calendar = calendar;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-M-d";
    
    self.minimumDate = [self.dateFormatter dateFromString:@"2011-1-2"];
    self.maximumDate = [self.dateFormatter dateFromString:@"2016-12-31"];
    
    
    // 设置 月Page
    {
        DJCalendarByMonthViewController * byMonth = [[DJCalendarByMonthViewController alloc] init];
        NSArray *arr = @[
                         @{@"2016年": @[@"12月", @"11月", @"10月", @"9月", @"8月", @"7月", @"6月", @"5月", @"4月", @"3月", @"2月", @"1月"]},
                         @{@"2015年": @[@"12月", @"11月", @"10月", @"9月", @"8月", @"7月", @"6月", @"5月", @"4月", @"3月", @"2月", @"1月"]},
                         @{@"2014年": @[@"12月", @"11月", @"10月", @"9月", @"8月", @"7月", @"6月", @"5月", @"4月", @"3月", @"2月", @"1月"]},
                         @{@"2013年": @[@"12月", @"11月", @"10月", @"9月", @"8月", @"7月", @"6月", @"5月", @"4月", @"3月", @"2月", @"1月"]}
                         ];
        byMonth.yearMonthArr = [arr mutableCopy];
        [self addChildViewController:byMonth];
        [byMonth didMoveToParentViewController:self];
        byMonth.view.frame = CGRectMake(2 * _scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        [_scrollView addSubview:byMonth.view];
    }
    // 设置 年Page
    {
        DJCalendarByYearViewController * byYear = [[DJCalendarByYearViewController alloc] init];
        NSArray *arr = @[@"2017年", @"2016年", @"2015年", @"2014年", @"2013年", @"2012年", @"2011年"];
        byYear.yearArr = [arr mutableCopy];
        [self addChildViewController:byYear];
        [byYear didMoveToParentViewController:self];
        byYear.view.frame = CGRectMake(3 * _scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        [_scrollView addSubview:byYear.view];
    }
    
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.calendar.frame = CGRectMake(0, 40, _scrollView.bounds.size.width, _scrollView.bounds.size.height - 40);
}

#pragma mark - Target Actions

- (void)backItemClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismiss.Complete");
    }];
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
    return [[_dateFormatter stringFromDate:date] componentsSeparatedByString:@"-"].lastObject;
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select %@",[self.dateFormatter stringFromDate:date]);
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change page %@",[self.dateFormatter stringFromDate:calendar.currentPage]);
}


#pragma mark - FSCalendarDelegateAppearance
- (CGFloat)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderRadiusForDate:(NSDate *)date
{
    return 0;
}


@end
