//
//  HelpView.m
//  Record
//
//  Created by Jehy Fan on 16/3/1.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "HelpView.h"

#import "ReminderManager.h"

@interface HelpView () {
    UILabel *tapLabel;
    UIImageView *tapImageView;
    UILabel *swipeLabel;
    UIImageView *swipeImageView;
    
    
    UIImageView *mainImageView;
}

@end


static NSString *HelpPackViewHasShowedKey = @"HelpPackViewHasShowed";
static NSString *HelpCalendarViewHasShowedKey = @"HelpCalendarViewHasShowed";

static NSString *HelpRepeatNotifyIsNewUserKey = @"HelpRepeatNotifyIsNewUser";
static NSString *HelpRepeatNotifyViewHasShowedKey = @"HelpRepeatNotifyViewHasShowed";



@implementation HelpView



- (void)initView {
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.hidden = YES;
    self.backgroundColor = ColorTranslucenceDark;
    
    
    tapLabel = [[UILabel alloc] init];
    tapLabel.font = FontMiddle;
    tapLabel.textAlignment = NSTextAlignmentCenter;
    tapLabel.numberOfLines = 0;
    tapLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:tapLabel];
    
    tapImageView = [[UIImageView alloc] init];
    
    
    tapImageView.image = [UIImage imageNamed:@"Gesture_Tap.png"];
    [self addSubview:tapImageView];
    
    
    swipeLabel = [[UILabel alloc] init];
    swipeLabel.font = FontMiddle;
    swipeLabel.textAlignment = NSTextAlignmentCenter;
    swipeLabel.numberOfLines = 0;
    
    swipeLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:swipeLabel];
    
    swipeImageView = [[UIImageView alloc] init];
    [self addSubview:swipeImageView];
    
    
    if (ScreenHeight == ScreenHeight480) {
        tapLabel.frame = CGRectMake(10, 100, ScreenWidth - 20, tapLabel.font.lineHeight);
        tapImageView.frame = CGRectMake((ScreenWidth - 71) / 2, 150, 71, 107);
        swipeLabel.frame = CGRectMake(10, 310, ScreenWidth - 20, swipeLabel.font.lineHeight);
    } else {
        tapLabel.frame = CGRectMake(10, 150, ScreenWidth - 20, tapLabel.font.lineHeight);
        tapImageView.frame = CGRectMake((ScreenWidth - 71) / 2, 200, 71, 107);
        swipeLabel.frame = CGRectMake(10, 360, ScreenWidth - 20, swipeLabel.font.lineHeight);
    }
    
}

- (id)init {
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        
        [self initView];
    }
    
    
    return self;
}


+ (BOOL)PackHelpHasShowed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:HelpPackViewHasShowedKey];
}
+ (BOOL)CalendarHelpHasShowed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:HelpCalendarViewHasShowedKey];
}

+ (void)setNewUserForRepeatNotify {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HelpRepeatNotifyIsNewUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isNewUserForRepeatNotify {
    return [[NSUserDefaults standardUserDefaults] boolForKey:HelpRepeatNotifyIsNewUserKey];
}

+ (BOOL)RepeatNotifyHelpShouldShowed {
    
    // 新用户
    if (![AppManager hasFirstSetDone]) {
        return NO;
    }
    
    // 新用户
    if ([HelpView isNewUserForRepeatNotify]) {
        return NO;
    }
    
    // 老用户
    // 已打开重复通知，则不必再提醒
    if ([ReminderManager remindRepeat]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HelpRepeatNotifyViewHasShowedKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return NO;
    }
    
    // 已查看
    if ([[NSUserDefaults standardUserDefaults] boolForKey:HelpRepeatNotifyViewHasShowedKey]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Show

- (void)showHelpRepeatNotifyWithImage:(UIImage *)image {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HelpRepeatNotifyViewHasShowedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HelpRepeatNotifyShowedNotification object:nil];
    
    [self.superview bringSubviewToFront:self];
    
    self.hidden = NO;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    CGFloat imageY = ScreenHeight - 88;
    
    
    tapLabel.frame = CGRectMake(32, 0, ScreenWidth - 160, ScreenHeight);
    tapLabel.font = FontBig;
    tapLabel.text = LocalizedString(@"help_repeat_notify");
    [tapLabel fixHeight];
    tapLabel.originY = imageY - tapLabel.height - 20;
    
    tapImageView.image = [UIImage imageNamed:@"Gesture_Tap_Down.png"];
    tapImageView.frame = CGRectMake(ScreenWidth - 100, 0, 67, 115);
    tapImageView.originY = imageY - 115 - 20;
    
    if (mainImageView == nil) {
        mainImageView = [[UIImageView alloc] init];
        mainImageView.backgroundColor = [UIColor colorWithWhite:68 / 255.0 alpha:1];
        mainImageView.frame = CGRectMake(0, imageY, ScreenWidth, 44);
        mainImageView.image = image;
        [self addSubview:mainImageView];
    }
}

- (void)showPackHelp {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HelpPackViewHasShowedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.superview bringSubviewToFront:self];
    
    self.hidden = NO;
    
    tapLabel.text = LocalizedString(@"help_take_pill");
    [tapLabel fixHeight];
    
    swipeLabel.text = LocalizedString(@"help_check_pack");
    [swipeLabel fixHeight];
    
    swipeImageView.image = [UIImage imageNamed:@"Gesture_Swipe_Right.png"];
    
    if (ScreenHeight == ScreenHeight480) {
        swipeImageView.frame = [swipeImageView.image frameInRect:CGRectMake((ScreenWidth - 100) / 2, 350, 100, 105)];
    } else {
        swipeImageView.frame = [swipeImageView.image frameInRect:CGRectMake((ScreenWidth - 100) / 2, 400, 100, 105)];
    }
    
    [AnalyticsUtil eventDistinguishInitial:Event_view_help_pack];
}
- (void)showCalendarHelp {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HelpCalendarViewHasShowedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.hidden = NO;
    
    
    tapLabel.text = LocalizedString(@"help_edit_date");
    [tapLabel fixHeight];
    
    swipeLabel.text = LocalizedString(@"help_switch_month");
    [swipeLabel fixHeight];
    
    swipeImageView.image = [UIImage imageNamed:@"Gesture_Swipe_Down.png"];
    
    if (ScreenHeight == ScreenHeight480) {
        swipeImageView.frame = [swipeImageView.image frameInRect:CGRectMake((ScreenWidth - 100) / 2, 350, 100, 122)];
    } else {
        swipeImageView.frame = [swipeImageView.image frameInRect:CGRectMake((ScreenWidth - 100) / 2, 400, 100, 122)];
    }
    
    [AnalyticsUtil eventDistinguishInitial:Event_view_help_calendar];
}

- (void)hide {
    self.hidden = YES;
}






@end
