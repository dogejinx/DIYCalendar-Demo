//
//  DJCalendarHeaderView.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/4.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DJCalendarHeaderView.h"

@interface DJCalendarHeaderView()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *btnByDate;
@property (nonatomic, strong) UIButton *btnByWeek;
@property (nonatomic, strong) UIButton *btnByMonth;
@property (nonatomic, strong) UIButton *btnByYear;
@property (nonatomic, strong) NSArray <UIButton *> *btnArr;

@property (nonatomic, strong) CAShapeLayer *selectLayer;
@property (nonatomic, strong) NSMutableArray <UIBezierPath *> *selectLinePathArr;

@property (nonatomic, strong) UIColor *btnHighlightColor;
@property (nonatomic, strong) UIColor *btnNormalColor;
@property (nonatomic, strong) UIFont *btnFont;

@property (assign) CGFloat viewMargin;
@property (assign) CGFloat btnWidth;
@property (assign) CGFloat bottomLineHeight;

@property (assign) NSInteger currentIndex;

@property (nonatomic, strong) NSMutableArray<NSString *> *btnTitleArr;


@end

@implementation DJCalendarHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupDefaultValue];
        
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor whiteColor];
            [self addSubview:view];
            self.contentView = view;
        }
        
        for (NSInteger i=0; i<_btnTitleArr.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitle:_btnTitleArr[i] forState:UIControlStateNormal];
            if (_currentIndex == i) {
                [btn setTitleColor:_btnHighlightColor forState:UIControlStateNormal];
            }
            else {
                [btn setTitleColor:_btnNormalColor forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(btnHandler:) forControlEvents:UIControlEventTouchUpInside];
            [btn.titleLabel setFont:_btnFont];
            [_contentView addSubview:btn];
            
            if (i==0) {
                self.btnByDate = btn;
            }
            else if (i==1) {
                self.btnByWeek = btn;
            }
            else if (i==2) {
                self.btnByMonth = btn;
            }
            else if (i==3) {
                self.btnByYear = btn;
            }
        }
        self.btnArr = @[_btnByDate, _btnByWeek, _btnByMonth, _btnByYear];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.btnWidth = (self.bounds.size.width - 2 * _viewMargin) / 4.0;
    
    // 设置底部选中线的位置
    if (!_selectLinePathArr) {
        _selectLinePathArr = [[NSMutableArray alloc] initWithCapacity:4];
        for (NSInteger i=0; i<4; i++) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(_viewMargin + _btnWidth * i, self.bounds.size.height - 2)];
            [path addLineToPoint:CGPointMake(_viewMargin + _btnWidth * (i+1), self.bounds.size.height - 2)];
            [_selectLinePathArr addObject:path];
        }
    }
    
    
    _contentView.frame = CGRectMake(_viewMargin, 0, _btnWidth * 4, self.bounds.size.height - _bottomLineHeight);
    
    {
        _btnByDate.frame = CGRectMake(0, 0, _btnWidth, _contentView.bounds.size.height);
        
        _btnByWeek.frame = CGRectMake(_btnWidth, 0, _btnWidth, _contentView.bounds.size.height);
        
        _btnByMonth.frame = CGRectMake(_btnWidth * 2, 0, _btnWidth, _contentView.bounds.size.height);
        
        _btnByYear.frame = CGRectMake(_btnWidth * 3, 0, _btnWidth, _contentView.bounds.size.height);
        
    }
    
    if (!_selectLayer) {
        CAShapeLayer *selectLayer = [CAShapeLayer layer];
        selectLayer.strokeColor = [UIColorFromRGB(0x3897f0) CGColor];
        selectLayer.lineCap = kCALineCapRound;
        selectLayer.lineJoin = kCALineJoinRound;
        selectLayer.fillColor = [UIColorFromRGB(0x3897f0) CGColor];
        selectLayer.lineWidth = 2.f;
        _selectLayer = selectLayer;
        [self.layer addSublayer:selectLayer];
    }

    _selectLayer.path = _selectLinePathArr[_currentIndex].CGPath;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0xdcdcdc).CGColor);
    
    // 绘制 底部水平线
    {
        CGContextMoveToPoint(ctx, 0, self.bounds.size.height);
        CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height - 1);
        CGContextStrokePath(ctx);
    }
    
    // 绘制 底部选中红线
    {
        CGContextMoveToPoint(ctx, 0, self.bounds.size.height);
        CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height - 1);
        CGContextStrokePath(ctx);
    }
    
    [super drawRect:rect];
}

- (void)setupDefaultValue
{
    self.backgroundColor = [UIColor clearColor];
    self.btnHighlightColor = UIColorFromRGB(0x3f3f3f);
    self.btnNormalColor = UIColorFromRGB(0xaeb4bc);
    self.btnFont = [UIFont boldSystemFontOfSize:16];
    
    self.currentIndex = 0;
    self.viewMargin = 8.0;
    self.bottomLineHeight = 2.0;
    
    NSArray *arr = @[@"按日",@"按周",@"按日",@"按日"];
    self.btnTitleArr = [arr mutableCopy];
}

- (void)updateCalendarView:(NSInteger)index
{
    for (NSInteger i=0; i< _btnArr.count; i++) {
        UIButton *btn = _btnArr[i];
        if (index == i) {
            [btn setTitleColor:_btnHighlightColor forState:UIControlStateNormal];
        }
        else {
            [btn setTitleColor:_btnNormalColor forState:UIControlStateNormal];
        }
    }
}

- (void)updateLinePath:(CGFloat)offset
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(_viewMargin + (_btnWidth * 4) * offset, self.bounds.size.height - 2)];
    [path addLineToPoint:CGPointMake(_viewMargin + (_btnWidth * 4) * offset + _btnWidth , self.bounds.size.height - 2)];
    
    _selectLayer.path = path.CGPath;
    
    if (offset == 0.0 || offset == 0.25 || offset == 0.5 || offset == 0.75) {
        NSInteger index = (NSInteger)(offset * 4);
        _currentIndex = index;
        [self updateCalendarView:index];
    }
}

#pragma mark - Target Handler
- (void)btnHandler:(UIButton *)sender
{
    for (NSInteger i=0; i< _btnArr.count; i++) {
        UIButton *btn = _btnArr[i];
        if (sender == btn) {
            _currentIndex = i;
            if([self.delegate respondsToSelector:@selector(dj_calendar:didSelectPageAtIndex:)]) {
                [self.delegate dj_calendar:self didSelectPageAtIndex:_currentIndex];
            }
            break;
        }
    }
}

@end
