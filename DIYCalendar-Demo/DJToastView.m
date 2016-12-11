//
//  DJToastView.m
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/9.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import "DJToastView.h"

@implementation DJToastView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupDefaultValue];
        
        UIView *view;
        
        {
            view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
            [self addSubview:view];
            self.contentView = view;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15.f];
        label.textColor = [UIColor whiteColor];
        [_contentView addSubview:label];
        self.titlelabel = label;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    _titlelabel.frame = self.contentView.bounds;
    
    _contentView.layer.masksToBounds = YES;
    _contentView.layer.cornerRadius = 4.f;
    
}

- (void)setupDefaultValue
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)updateTitleText:(NSString *)text
{
    if ([text isEqualToString:self.titlelabel.text]) {
        return;
    }
    
    CGPoint point = self.center;
    point.y += 120;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.center = point;
        self.alpha = 0.3f;
    } completion:^(BOOL finished) {
        CGPoint point = self.center;
        point.y -= 120;
        _titlelabel.text = text;
        [_titlelabel sizeToFit];
        [self setNeedsLayout];
        
        [UIView animateWithDuration:0.15 animations:^{
            self.center = point;
            self.alpha = 1.f;
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}

@end
