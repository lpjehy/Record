//
//  SnoozeView.m
//  Reminder
//
//  Created by Jehy Fan on 16/6/5.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "SnoozeView.h"
#import "FeedBackView.h"

#import "NotifyManager.h"

#import "ReminderManager.h"

@interface SnoozeView () <UIActionSheetDelegate> {
    
    UIButton *snoozeButton;
    
    NSTimer *mainTimer;
    
    BOOL isShowed;
}

@end

@implementation SnoozeView

+ (SnoozeView *)getInstance {
    static SnoozeView *instance = nil;
    if (instance == nil) {
        instance = [[SnoozeView alloc] init];
    }
    
    return instance;
}



- (void)initView {
    self.frame = CGRectMake(ScreenWidth - 120, -120, 88, 120);
    
    self.image = [UIImage imageNamed:@"snooze.png"];
    
    
    self.userInteractionEnabled = YES;
    
    
    
    snoozeButton = [[UIButton alloc] init];
    
    [snoozeButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    [snoozeButton setTitleColor:[UIColor colorWithR:6 g:101 b:80 a:1] forState:UIControlStateNormal];
    snoozeButton.titleLabel.font = FontMiddle;
    
    
    snoozeButton.frame = CGRectMake(0, 120 - 88, 88, 88);
    [self addSubview:snoozeButton];
    
   
}

- (id)init {
    self = [super init];
    if (self) {
        
        mainTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                     target:self
                                                   selector:@selector(resetTitle)
                                                   userInfo:nil
                                                    repeats:YES];
        
        [self initView];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTitle) name:LanguageChangedNotification object:nil];
    }
    
    
    return self;
}

- (void)resetTitle {
    UILocalNotification *notification = [ReminderManager snoozeNotification];
    if (notification) {
        NSString *title = nil;
        
        NSTimeInterval interval = [notification.fireDate timeIntervalSinceNow];
        NSInteger minutes = (NSInteger)interval / 60 + 1;
        if (minutes >= 60) {
            title = [@"1 " stringByAppendingString:LocalizedString(@"snoooze_time_hour")];
        } else {
            title = [NSString stringWithFormat:@"%zi %@", minutes, LocalizedString(@"snoooze_time_minutes")];
        }
        
        
        [snoozeButton setTitle:title forState:UIControlStateNormal];
    } else {
        [snoozeButton setTitle:LocalizedString(@"snoooze_button_title") forState:UIControlStateNormal];
    }
}


- (void)buttonPressed {
    [AnalyticsUtil buttonClicked:__FUNCTION__];
    
    
    UIActionSheet *actionSheet  = [[UIActionSheet alloc] initWithTitle:LocalizedString(@"snoooze_action_title")
                                                              delegate:self
                                                     cancelButtonTitle:LocalizedString(@"button_title_cancel")
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:
                                   [@"5 " stringByAppendingString:LocalizedString(@"snoooze_time_minutes")],
                                   [@"20 " stringByAppendingString:LocalizedString(@"snoooze_time_minutes")],
                                   [@"1 " stringByAppendingString:LocalizedString(@"snoooze_time_hour")], nil];
    
    
    [actionSheet showInView:KeyWindow];
}


- (void)showInView:(UIView *)view {
    if (isShowed == YES || view == nil) {
        return;
    }
    isShowed = YES;
    
    [view addSubview:self];
    
    [self resetTitle];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.originY = 0;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    // Snooze优先级大于Feedback
    [[FeedBackView getInstance] hide];
    
}

- (void)hide {
    
    if (isShowed == NO) {
        return;
    }
    
    isShowed = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.originY = -self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

- (void)cancel {
    [self hide];
    
    [ReminderManager cancelSnoozeNotification];
}

- (BOOL)isShowing {
    return isShowed;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSTimeInterval interval = 0;
    if (buttonIndex == 0) {
        // 5分钟
        interval = 60 * 5;
        
    } else if (buttonIndex == 1) {
        // 20分钟
        interval = 60 * 20;
        
    } else if (buttonIndex == 2) {
        // 1小时
        interval = 60 * 60;
        
    }
    
    if (interval != 0) {
        [NotifyManager snoozeInInterval:interval];
        
        [self resetTitle];
    }
}

@end
