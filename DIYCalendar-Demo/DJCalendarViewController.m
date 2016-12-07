//
//  DJCalendarViewController.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/4.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DJCalendarViewController.h"

@interface DJCalendarViewController ()<UIScrollViewDelegate, DJCalendarHeaderViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DJCalendarHeaderView *headerView;
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
    
    for (NSInteger i =0; i<4; i++) {
        CGFloat x = i * _scrollView.bounds.size.width;
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
        v.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:(1 - 0.2 * i)];
        [_scrollView addSubview:v];
    }
    
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


@end
