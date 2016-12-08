//
//  DJTableViewHeader.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/9.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DJTableViewHeader.h"

@implementation DJTableViewHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = UIColorFromRGB(0x79828f);
        label.font = [UIFont systemFontOfSize:12.f];
        label.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:label];
        self.titleLabel = label;
                
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(15, 0, self.bounds.size.width, self.bounds.size.height - 0.5);
}

- (void)drawRect:(CGRect)rect
{
    UIColor *aColor = UIColorFromRGB(0xf6f6f6);
        
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
    
    CGContextMoveToPoint(context, 0, 0.25);
    CGContextAddLineToPoint(context, rect.size.width, 0.25);
    
    CGContextMoveToPoint(context, 0, rect.size.height - 0.25);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 0.25);
    CGContextStrokePath(context);
    
    [super drawRect:rect];}


@end
