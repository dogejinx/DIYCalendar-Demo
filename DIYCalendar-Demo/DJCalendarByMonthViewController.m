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

@interface DJCalendarByMonthViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UITableView *subTableView;

@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *selectArr;

@end

@implementation DJCalendarByMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSInteger i=0; i<_yearMonthArr.count; i++) {
        NSDictionary *dic = _yearMonthArr[i];
        [_yearArr addObject:dic.allKeys.firstObject];
    }
    
    for (NSInteger i=0; i<_yearMonthArr.count; i++) {
        NSDictionary *dic = _yearMonthArr[i];
        NSArray *tempArr = dic.allValues;
        NSArray *valuesArr = tempArr.firstObject;
        for (NSInteger j=0; j<valuesArr.count; j++) {
            [_monthArr addObject:valuesArr[j]];
        }
    }
    
    
    [_mainTableView reloadData];
    [_subTableView reloadData];
}

- (void)loadView
{
    self.selectArr = [NSMutableArray array];
    self.yearArr = [NSMutableArray array];
    self.monthArr = [NSMutableArray array];
    
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    {
        UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        mainTableView.backgroundColor = [UIColor whiteColor];
        mainTableView.tag = 11;
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

#pragma mark - UItableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 11) {
        return _yearArr.count;
    }
    else {
        return _monthArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 11) {
        DJCalendarMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJCalendarMainTableViewCell" forIndexPath:indexPath];
        
        cell.calendarLabel.text = _yearArr[indexPath.row];
        
        
        if ([_selectArr containsObject:indexPath]) {
            cell.choose = YES;
        }
        else {
            cell.choose = NO;
        }
        
        return cell;
    }
    else {
        DJCalendarSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJCalendarSubTableViewCell" forIndexPath:indexPath];
        
        cell.calendarLabel.text = _monthArr[indexPath.row];
        if ([_selectArr containsObject:indexPath]) {
            cell.choose = YES;
        }
        else {
            cell.choose = NO;
        }
        
        return cell;
    }
}

#pragma mark - UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 11) {
        if (![_selectArr containsObject:indexPath]) {
            [_selectArr addObject:indexPath];
        }
        else {
            [_selectArr removeObject:indexPath];
        }
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

@end
