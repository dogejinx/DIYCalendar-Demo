//
//  DJToastView.h
//  DIYCalendar-Demo
//
//  Created by linxian on 2016/12/9.
//  Copyright © 2016年 DogeJinx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJToastView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titlelabel;

- (void)updateTitleText:(NSString *)text;

@end
