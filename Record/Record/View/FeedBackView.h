//
//  RateView.h
//  Reminder
//
//  Created by Jehy Fan on 16/6/7.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackView : UIImageView


+ (FeedBackView *)getInstance;


+ (BOOL)shouldShow;

- (void)showInView:(UIView *)view;
- (void)hide;

@end
