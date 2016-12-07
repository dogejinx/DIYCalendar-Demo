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
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *selectArr;

@end

@implementation DJCalendarByYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView reloadData];
}

- (void)loadView
{
    self.selectArr = [NSMutableArray array];
    
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

#pragma mark - UItableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _yearArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DJCalendarSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJCalendarSubTableViewCell" forIndexPath:indexPath];
    
    cell.calendarLabel.text = _yearArr[indexPath.row];
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


@end
