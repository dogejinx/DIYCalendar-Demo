//
//  DJCalendarWeekView.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/7.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DJCalendarWeekView.h"

@interface DJCalendarWeekView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray<UILabel *> *labelArr;

@property (assign) CGFloat viewMargin;
@property (assign) CGFloat labelWidth;

@end

@implementation DJCalendarWeekView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupDefaultValue];
        
        UIView *view;
        
        
        {
            view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = UIColorFromRGB(0xf6f6f6);
            [self addSubview:view];
            self.contentView = view;
        }
        
        NSArray *titleArr = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
        self.labelArr = [NSMutableArray arrayWithCapacity:7];
        for (NSInteger i=0; i<7; i++) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont boldSystemFontOfSize:13.f];
            label.text = titleArr[i];
            if ( i==0 || i ==6 ) {
                label.textColor = UIColorFromRGB(0x3897f0);
            }
            else {
                label.textColor = UIColorFromRGB(0x666666);
            }
            [_contentView addSubview:label];
            [_labelArr addObject:label];
        }
            
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.labelWidth = floorf(self.bounds.size.width / 7.f);
    self.viewMargin = (self.bounds.size.width - (_labelWidth * 7.f)) / 2.f;
    self.contentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    for (NSInteger i=0; i<_labelArr.count; i++) {
        UILabel *label = _labelArr[i];
        label.frame = CGRectMake(_viewMargin + _labelWidth * i, 0, _labelWidth, self.bounds.size.height);
    }
}

- (void)setupDefaultValue
{
    self.viewMargin = 0.0;
}

@end
