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
@property(nonatomic) CABasicAnimation *pathAnimation;

@property (nonatomic, strong) UIColor *btnHighlightColor;
@property (nonatomic, strong) UIColor *btnNormalColor;
@property (nonatomic, strong) UIFont *btnFont;

@property (assign) CGFloat viewMargin;
@property (assign) CGFloat btnWidth;
@property (assign) CGFloat bottomLineHeight;

@property (assign) NSInteger currentIndex;


@end

@implementation DJCalendarHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupDefaultValue];
        
        UIView *view;
        UIButton *btn;
        
        {
            view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor whiteColor];
            [self addSubview:view];
            self.contentView = view;
        }
        
        {
            btn = [[UIButton alloc] initWithFrame:CGRectZero];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitle:@"按日" forState:UIControlStateNormal];
            [btn setTitleColor:_btnHighlightColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnHandler:) forControlEvents:UIControlEventTouchUpInside];
            [btn.titleLabel setFont:_btnFont];
            [_contentView addSubview:btn];
            self.btnByDate = btn;
        }
        
        {
            btn = [[UIButton alloc] initWithFrame:CGRectZero];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitle:@"按周" forState:UIControlStateNormal];
            [btn setTitleColor:_btnNormalColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnHandler:) forControlEvents:UIControlEventTouchUpInside];
            [btn.titleLabel setFont:_btnFont];
            [_contentView addSubview:btn];
            self.btnByWeek = btn;
        }
        
        {
            btn = [[UIButton alloc] initWithFrame:CGRectZero];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitle:@"按月" forState:UIControlStateNormal];
            [btn setTitleColor:_btnNormalColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnHandler:) forControlEvents:UIControlEventTouchUpInside];
            [btn.titleLabel setFont:_btnFont];
            [_contentView addSubview:btn];
            self.btnByMonth = btn;
        }
        
        {
            btn = [[UIButton alloc] initWithFrame:CGRectZero];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitle:@"按年" forState:UIControlStateNormal];
            [btn setTitleColor:_btnNormalColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnHandler:) forControlEvents:UIControlEventTouchUpInside];
            [btn.titleLabel setFont:_btnFont];
            [_contentView addSubview:btn];
            self.btnByYear = btn;
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
}

- (CABasicAnimation *)pathAnimation {
    
    if (!_pathAnimation) {
        _pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        _pathAnimation.duration = 0.2f;
        _pathAnimation.autoreverses = NO;
        _pathAnimation.removedOnCompletion = NO;
        _pathAnimation.fillMode = kCAFillModeForwards;
        _pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [_selectLayer addAnimation:_pathAnimation forKey:@"animationKey"];
    }
    
    _pathAnimation.fromValue = (id) _selectLayer.path;
    _pathAnimation.toValue = (id) [_selectLinePathArr[_currentIndex] CGPath];
    
    return _pathAnimation;
}

- (void)updateCalendarView:(NSInteger)i
{
    [_selectLayer addAnimation:self.pathAnimation forKey:@"path"];
    [self setNeedsLayout];
}

#pragma mark - Target Handler
- (void)btnHandler:(UIButton *)sender
{
    for (NSInteger i=0; i< _btnArr.count; i++) {
        UIButton *btn = _btnArr[i];
        if (sender == btn) {
            _currentIndex = i;
            [self updateCalendarView:i];
            [btn setTitleColor:_btnHighlightColor forState:UIControlStateNormal];
        }
        else {
            [btn setTitleColor:_btnNormalColor forState:UIControlStateNormal];
        }
    }
}

@end
