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
    _cellSelectionType = CellSelectionTypeNone;
    
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

    if (_cellSelectionType == CellSelectionTypeSingle) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
        if (_calendarLabel.attributedText) {
            NSMutableAttributedString *attrStr = [_calendarLabel.attributedText mutableCopy];
            [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x3897f0) range:NSMakeRange(0, _calendarLabel.text.length)];
            _calendarLabel.attributedText = attrStr;
        }
        else {
            _calendarLabel.textColor = UIColorFromRGB(0x3897f0);
            _calendarLabel.font = [UIFont boldSystemFontOfSize:15.f];
        }
        
        aColor = UIColorFromRGB(0xf6f6f6);
    }
    else if (_cellSelectionType == CellSelectionTypeNone) {
        self.accessoryType = UITableViewCellAccessoryNone;
        if (_calendarLabel.attributedText) {
            NSMutableAttributedString *attrStr = [_calendarLabel.attributedText mutableCopy];
            [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x79828f) range:NSMakeRange(0, _calendarLabel.text.length)];
            _calendarLabel.attributedText = attrStr;
        }
        else {
            _calendarLabel.textColor = UIColorFromRGB(0x79828f);
            _calendarLabel.font = [UIFont systemFontOfSize:15.f];
        }
    }
    else if (_cellSelectionType == CellSelectionTypeMutiBorder) {
        self.accessoryType = UITableViewCellAccessoryNone;
        if (_calendarLabel.attributedText) {
            NSMutableAttributedString *attrStr = [_calendarLabel.attributedText mutableCopy];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, _calendarLabel.text.length)];
            _calendarLabel.attributedText = attrStr;
        }
        else {
            _calendarLabel.textColor = [UIColor whiteColor];
            _calendarLabel.font = [UIFont boldSystemFontOfSize:15.f];
        }
        
        aColor = UIColorFromRGB(0x3897f0);
    }
    else if (_cellSelectionType == CellSelectionTypeMutiMiddle) {
        self.accessoryType = UITableViewCellAccessoryNone;
        if (_calendarLabel.attributedText) {
            NSMutableAttributedString *attrStr = [_calendarLabel.attributedText mutableCopy];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, _calendarLabel.text.length)];
            _calendarLabel.attributedText = attrStr;
        }
        else {
            _calendarLabel.textColor = [UIColor whiteColor];
            _calendarLabel.font = [UIFont boldSystemFontOfSize:15.f];
        }
        
        aColor = UIColorFromRGB(0x73b6f4);
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

- (void)setCellSelectionType:(CellSelectionType)cellSelectionType
{
    _cellSelectionType = cellSelectionType;
    [self setNeedsDisplay];
}

@end
