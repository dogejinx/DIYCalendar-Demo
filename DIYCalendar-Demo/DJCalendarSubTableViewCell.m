//
//  DJCalendarSubTableViewCell.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/7.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DJCalendarSubTableViewCell.h"

@implementation DJCalendarSubTableViewCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    _labelMargin = 15.f;
    _choose = NO;
    
    UILabel *label;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.f];
    label.textColor = UIColorFromRGB(0x79828f);
    [self.contentView addSubview:label];
    self.calendarLabel = label;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _calendarLabel.frame = CGRectMake(_labelMargin, 0, self.bounds.size.width - _labelMargin, self.bounds.size.height);
}

- (void)drawRect:(CGRect)rect
{
    UIColor *aColor = [UIColor clearColor];
    if (self.choose) {
        aColor = UIColorFromRGB(0xf6f6f6);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);
    CGContextAddRect(context,rect);
    CGContextDrawPath(context, kCGPathFillStroke);

    CGContextSetStrokeColorWithColor(context,  UIColorFromRGB(0xe9e9e9).CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextMoveToPoint(context, 15, rect.size.height - 0.25);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 0.25);
    CGContextStrokePath(context);
    
    [super drawRect:rect];
}

- (void)setChoose:(BOOL)choose
{
    _choose = choose;
    [self setNeedsDisplay];
}

@end
