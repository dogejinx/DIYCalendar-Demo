//
//  DIYCalendarCell.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/9.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DIYCalendarCell.h"
#import "FSCalendarExtensions.h"

@implementation DIYCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *todayView = [[UIView alloc] init];
        todayView.backgroundColor = FSCalendarStandardTodayColor;
        [self.contentView insertSubview:todayView atIndex:0];
        self.todayView = todayView;
        
        CAShapeLayer *selectionLayer = [[CAShapeLayer alloc] init];
        selectionLayer.fillColor = UIColorFromRGB(0x3897f0).CGColor;
        selectionLayer.actions = @{@"hidden":[NSNull null]};
        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];
        self.selectionLayer = selectionLayer;
        
        self.shapeLayer.hidden = YES;
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
    //    NSLog(@"cell_bounds: (%0.f, %0.f, %0.f, %0.f)",self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    //    NSLog(@"cell_frame: (%0.f, %0.f, %0.f, %0.f)",self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    self.todayView.frame = self.backgroundView.frame;
    
    self.selectionLayer.frame = self.bounds;
    NSLog(@"selectionLayer_frame: (%0.f, %0.f, %0.f, %0.f)",_selectionLayer.frame.origin.x, _selectionLayer.frame.origin.y, _selectionLayer.frame.size.width, _selectionLayer.frame.size.height);
    if (self.selectionType == SelectionTypeMiddle) {
        
        self.selectionLayer.fillColor = UIColorFromRGB(0x73b6f4).CGColor;
        self.selectionLayer.path = [UIBezierPath bezierPathWithRect:self.selectionLayer.bounds].CGPath;
        
    } else if (self.selectionType == SelectionTypeLeftBorder) {
        
        self.selectionLayer.fillColor = UIColorFromRGB(0x3897f0).CGColor;
        self.selectionLayer.path = [UIBezierPath bezierPathWithRect:self.selectionLayer.bounds].CGPath;
        
    } else if (self.selectionType == SelectionTypeRightBorder) {
        
        self.selectionLayer.fillColor = UIColorFromRGB(0x3897f0).CGColor;
        self.selectionLayer.path = [UIBezierPath bezierPathWithRect:self.selectionLayer.bounds].CGPath;
        
    } else if (self.selectionType == SelectionTypeSingle) {
        
        self.selectionLayer.fillColor = UIColorFromRGB(0x3897f0).CGColor;
        self.selectionLayer.path = [UIBezierPath bezierPathWithRect:self.selectionLayer.bounds].CGPath;
    }
}

- (void)setSelectionType:(SelectionType)selectionType
{
    if (_selectionType != selectionType) {
        _selectionType = selectionType;
        [self setNeedsLayout];
    }
}

@end
