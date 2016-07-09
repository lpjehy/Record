//
//  ReminderManager.m
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "ReminderManager.h"
#import "ScheduleManager.h"
#import "AudioManager.h"
#import "RecordData.h"

#import "NotifyManager.h"


#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

static NSString *ShouldRemindKey = @"ShouldRemind";
static NSString *RemindInSafeDaysKey = @"RemindInSafeDays";
static NSString *NotificationAlertBodyKey = @"NotificationAlertBody";
static NSString *NotificationTimeKey = @"NotificationTime";
static NSString *RemindRepeatKey = @"RemindRepeatKey";
static NSString *NotificationSoundKey = @"NotificationSound";








#define DefaultAlertBody LocalizedString(@"reminder_default_alertbody");

static NSString *DefaulNotifyTime = @"22:00";

@interface ReminderManager () <UIAlertViewDelegate> {
    
}



@end


@implementation ReminderManager





+ (ReminderManager *)getInstance {
    static ReminderManager *instance = nil;
    if (instance == nil) {
        instance = [[ReminderManager alloc] init];
    }
    
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}




#pragma mark - Config
/**
 *  业务相关
 *
 *
 */

+ (void)setShouldRmind:(BOOL)should {
    [[NSUserDefaults standardUserDefaults] setInteger:should forKey:ShouldRemindKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [NotifyManager resetRemindNotify];
}
+ (BOOL)shouldRemind {
    NSInteger should = [[NSUserDefaults standardUserDefaults] boolForKey:ShouldRemindKey];
    
    
    return should;
}

+ (void)setRemindPlaceboPill:(BOOL)remind {
    [[NSUserDefaults standardUserDefaults] setInteger:remind forKey:RemindInSafeDaysKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [NotifyManager resetRemindNotify];
}
+ (BOOL)remindPlaceboPill {
    NSInteger remindInSafeDays = [[NSUserDefaults standardUserDefaults] boolForKey:RemindInSafeDaysKey];
    
    
    return remindInSafeDays;
}

+ (void)setNotifyAlertBody:(NSString *)alertBody {
    if (alertBody == nil || alertBody.length == 0) {
        alertBody = DefaultAlertBody;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:alertBody forKey:NotificationAlertBodyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [NotifyManager resetRemindNotify];
}

+ (NSString *)notifyAlertBody {
    NSString * alertBody = [[NSUserDefaults standardUserDefaults] valueForKey:NotificationAlertBodyKey];
    
    if (alertBody == nil) {
        alertBody = DefaultAlertBody;
    }
    
    return alertBody;
}


+ (void)setNotifyTime:(NSString *)time {
    [[NSUserDefaults standardUserDefaults] setValue:time forKey:NotificationTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [NotifyManager resetRemindNotify];
    
    [NotifyManager resetActiveNotify];
}

+ (NSDate *)notifyTime {
    NSDate *date = nil;
    
    NSString *time = [[NSUserDefaults standardUserDefaults] valueForKey:NotificationTimeKey];
    if (time == nil) {
        
        time = DefaulNotifyTime;
        [ReminderManager setNotifyTime:time];
    }
    
    NSDateComponents *today = NSDate.components;
    date = [NSString stringWithFormat:@"%zi-%02zi-%02zi %@:00.0", today.year, today.month, today.day, time].date;
    
    return date;
}

+ (void)setRemindRepeat:(BOOL)repeat {
    [[NSUserDefaults standardUserDefaults] setInteger:repeat forKey:RemindRepeatKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [NotifyManager resetRemindNotify];
}

+ (BOOL)remindRepeat {
    NSInteger repeat = [[NSUserDefaults standardUserDefaults] boolForKey:RemindRepeatKey];
    
    
    return repeat;
}


+ (void)setNotifySound:(NSString *)sound {
    if (sound == nil || sound.length == 0) {
        sound = SoundNameDefault;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:sound forKey:NotificationSoundKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [NotifyManager resetRemindNotify];
    
    [NotifyManager resetActiveNotify];
}

+ (NSString *)notifySound {
    NSString * sound = [[NSUserDefaults standardUserDefaults] valueForKey:NotificationSoundKey];
    
    if (sound == nil || [sound isEqualToString:UILocalNotificationDefaultSoundName]) {
        sound = SoundNameDefault;
    }
    
    return sound;
}


#pragma mark - Snooze

+ (BOOL)canSnooze {
    if ([NotifyManager hasAuthority]
        // 有通知权限
        
        && [ReminderManager shouldRemind]) {
        // 需要通知
        
        if ([ScheduleManager isEveryday]
            || ([ScheduleManager takePlaceboPills] && [ReminderManager remindPlaceboPill])
            || ![[ScheduleManager getInstance] isBreakDay:[ScheduleManager getInstance].today]) {
            //这一天需要通知
            
            
            NSDate *remindDate = [ReminderManager notifyTime];
            if ([remindDate isEarlier]) {
                // 已经过了通知时间
                
                NSString *record = [RecordData selectRecord:[NSDate date]];
                if (record == nil) {
                    // 还未服药
                    
                    return YES;
                }
            }
        }
        
    }
    
    return NO;
}


+ (UILocalNotification *)snoozeNotification {
    
    
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSDictionary *userinfo = notification.userInfo;
        NSString *type = [userinfo validObjectForKey:LocalNotificationUserinfoTypeKey];
        if ([type isEqualToString:LocalNotificationTypeSnooze]) {
            return notification;
        }
    }
    
    
    return nil;
}

+ (void)cancelSnoozeNotification {
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSDictionary *userinfo = notification.userInfo;
        NSString *type = [userinfo validObjectForKey:LocalNotificationUserinfoTypeKey];
        if ([type isEqualToString:LocalNotificationTypeSnooze]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}





@end
