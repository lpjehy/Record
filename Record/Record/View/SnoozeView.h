//
//  SnoozeView.h
//  Reminder
//
//  Created by Jehy Fan on 16/6/5.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnoozeView : UIImageView


+ (SnoozeView *)getInstance;

- (void)showInView:(UIView *)view;
- (void)hide;
- (void)cancel;


@end
