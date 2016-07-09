//
//  RefillManager.m
//  Reminder
//
//  Created by Jehy Fan on 16/7/2.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "RefillManager.h"

#import "ReminderManager.h"
#import "AudioManager.h"

#import "ScheduleManager.h"

#import "NotifyManager.h"

#import "RecordData.h"

static NSString *RefillShouldNotifyKey = @"RefillShouldNotify";
static NSString *RefillLeftPillNumKey = @"RefillLeftPillNum";
static NSString *RefillNotifyPillNumKey = @"RefillNotifyPillNum";
static NSString *RefillNotifyTimeKey = @"RefillNotifyTime";
static NSString *RefillNotifySoundKey = @"RefillNotifySound";

static NSString *RefillRemindDateKey = @"RefillRemindDate";

static NSString *DefaulNotifyTime = @"11:00";

@interface RefillManager () <UIAlertViewDelegate>

@end

@implementation RefillManager

#pragma mark - 配置

#pragma mark 开关
+ (void)setShouldNotify:(BOOL)should {
    [[NSUserDefaults standardUserDefaults] setInteger:should forKey:RefillShouldNotifyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [RefillManager checkRefillNotify];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RefillStateChangedNotification object:nil];
    
}

+ (BOOL)shouldNotify {
    BOOL should = [[NSUserDefaults standardUserDefaults] boolForKey:RefillShouldNotifyKey];
    
    
    
    return should;
}

#pragma mark 剩余药片数量
+ (void)setLeftPillNum:(NSInteger)num {
    [[NSUserDefaults standardUserDefaults] setInteger:num forKey:RefillLeftPillNumKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [RefillManager checkRefillNotify];
}

+ (NSInteger)leftPillNum {
    NSInteger leftPillNum = [[NSUserDefaults standardUserDefaults] integerForKey:RefillLeftPillNumKey];
    if (leftPillNum == 0) {
        NSInteger pillnum = [ScheduleManager pillDays];
        if ([ScheduleManager takePlaceboPills] || [ScheduleManager isEveryday]) {
            pillnum = [ScheduleManager allDays];
        }
        
        NSInteger currentPack = [ScheduleManager getInstance].currentPack;
        NSArray *takenPills = [RecordData selectRecordFromDate:[[ScheduleManager getInstance] dateInPack:currentPack
                                                                                                      day:0]
                                                         toDate:[[ScheduleManager getInstance] dateInPack:currentPack
                                                                                                      day:pillnum]];
        NSInteger takenPillsNum = takenPills.count;
        
        leftPillNum = pillnum - takenPillsNum;
        if (leftPillNum <= 1) {
            leftPillNum += pillnum;
        }
        
        
        [RefillManager setLeftPillNum:leftPillNum];
    }
    
    
    return leftPillNum;
}

#pragma mark 需要通知的药片数量
+ (void)setNotifyPillNum:(NSInteger)num {
    if (num == 0) {
        [RefillManager setShouldNotify:NO];
        
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:num forKey:RefillNotifyPillNumKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [RefillManager checkRefillNotify];
    }
}

+ (NSInteger)notifyPillNum {
    NSInteger pillnum = [[NSUserDefaults standardUserDefaults] integerForKey:RefillNotifyPillNumKey];
    if (pillnum == 0) {
        pillnum = 1;
    }
    
    
    return pillnum;
}

#pragma mark 通知时间
+ (void)setNotifyTime:(NSString *)time {
    [[NSUserDefaults standardUserDefaults] setValue:time forKey:RefillNotifyTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [RefillManager checkRefillNotify];
}
+ (NSDate *)notifyTime {
    NSDate *date = nil;
    
    NSString *time = [[NSUserDefaults standardUserDefaults] valueForKey:RefillNotifyTimeKey];
    if (time == nil) {
        
        time = DefaulNotifyTime;
        [RefillManager setNotifyTime:time];
    }
    
    NSDateComponents *today = NSDate.components;
    date = [NSString stringWithFormat:@"%zi-%02zi-%02zi %@:00.0", today.year, today.month, today.day, time].date;
    
    
    return date;
}

#pragma mark 通知音频
+ (void)setNotifySound:(NSString *)sound {
    if (sound == nil || sound.length == 0) {
        sound = SoundNameDefault;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:sound forKey:RefillNotifySoundKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [RefillManager checkRefillNotify];
}

+ (NSString *)notifySound {
    NSString * sound = [[NSUserDefaults standardUserDefaults] valueForKey:RefillNotifySoundKey];
    if (sound == nil || [sound isEqualToString:UILocalNotificationDefaultSoundName]) {
        sound = SoundNameDefault;
    }
    
    return sound;
}


#pragma mark - 通知


+ (void)checkRefillNotify {
    
    [RefillManager cancelRefillNotification];
    
    if (![NotifyManager hasAuthority]) {
        return;
    }
    
    
    if (![RefillManager shouldNotify]) {
        return;
    }
    
    NSInteger leftPillNum = [RefillManager leftPillNum];
    if (leftPillNum == 1 && [RefillManager notifyTime].isEarlier) {
        return;
    }
    
    NSInteger notifyPillNum = [RefillManager notifyPillNum];
    if (leftPillNum <= notifyPillNum) {
        
        [RefillManager setRemindDate:nil];
        
        [NotifyManager notifyRefill];
    }
}


+ (void)cancelRefillNotification {
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSDictionary *userinfo = notification.userInfo;
        NSString *type = [userinfo validObjectForKey:LocalNotificationUserinfoTypeKey];
        if ([type isEqualToString:LocalNotificationTypeRefill]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}



#pragma mark - 提醒

+ (void)setRemindDate:(NSDate *)date {
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:RefillRemindDateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSDate *)remindDate {
    NSDate *date = [[NSUserDefaults standardUserDefaults] valueForKey:RefillRemindDateKey];
    
    return date;
}

+ (void)showRemindRefill {
    
    if (![RefillManager shouldNotify]) {
        return;
    }
    
    NSInteger leftPillNum = [RefillManager leftPillNum];
    if (leftPillNum == 1 && [RefillManager notifyTime].isEarlier) {
        return;
    }
    
    NSInteger notifyPillNum = [RefillManager notifyPillNum];
    if (leftPillNum > notifyPillNum) {
        return;
    }
    
    NSDate *nowDate = [NSDate date];
    NSDate *date = [RefillManager remindDate];
    if (date) {
        NSString *dayStr = [nowDate.string componentsSeparatedByString:@" "].firstObject;
        NSString *todayStr = [dayStr stringByAppendingString:@" 00:00:00.0"];
        NSDate *todayDate = todayStr.date;
        if (![date isEarlierThan:todayDate]) {
            // 今日已通知
            return;
        }
    }
    
    [RefillManager setRemindDate:nowDate];
    
    NSString *text = [NSString stringWithFormat:LocalizedString(@"refill_pills_left"), leftPillNum];
    if (leftPillNum == 1) {
        text = LocalizedString(@"refill_pill_left");
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:text
                                                    message:LocalizedString(@"refill_alert_title")
                                                   delegate:[RefillManager getInstance]
                                          cancelButtonTitle:LocalizedString(@"button_title_cancel")
                                          otherButtonTitles:LocalizedString(@"button_title_yes"), nil];
    [alert show];
}

+ (RefillManager *)getInstance {
    static RefillManager *instance = nil;
    if (instance == nil) {
        instance = [[RefillManager alloc] init];
    }
    
    return instance;
}



#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:LocalizedString(@"button_title_yes")]) {
        [RefillManager setShouldNotify:NO];
        
    } else {
        
    }
}


@end
