//
//  NotifyUtil.m
//  Reminder
//
//  Created by Jehy Fan on 16/7/2.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "NotifyManager.h"

#import "ReminderManager.h"
#import "ScheduleManager.h"
#import "RefillManager.h"
#import "RecordData.h"

#import "AudioManager.h"


static NSString *DidRegisterUserNotificationSettingsKey = @"DidRegisterUserNotificationSettings";




@implementation NotifyManager


+ (NotifyManager *)getInstance {
    static NotifyManager *instance = nil;
    if (instance == nil) {
        instance = [[NotifyManager alloc] init];
    }
    
    return instance;
}

#pragma mark - Authority

/**
 *  获取本地推送权限状态
 *
 *  @return
 */
+ (BOOL)hasAuthority {
    if ([UIApplication instancesRespondToSelector:@selector(currentUserNotificationSettings)]
        && [UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone) {
        return NO;
    }
    
    return YES;
}

+ (void)setDidRegisterUserNotificationSettings {
    [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:DidRegisterUserNotificationSettingsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (BOOL)didRegisterUserNotificationSettings {
    NSInteger did = [[NSUserDefaults standardUserDefaults] boolForKey:DidRegisterUserNotificationSettingsKey];
    
    
    return did;
}


#pragma mark - Notifications

+ (void)checkNotifications {
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSDictionary *userinfo = notification.userInfo;
        NSString *type = [userinfo validObjectForKey:LocalNotificationUserinfoTypeKey];
        NSLog(@"%@ %@", type, notification.fireDate.description);
        
    }
}

+ (NSString *)soundName:(NSString *)sound {
    NSString *soundName = nil;
    if ([sound isEqualToString:SoundNameMute]) {
        soundName = nil;
    } else if ([sound isEqualToString:SoundNameDefault]) {
        soundName = UILocalNotificationDefaultSoundName;
    } else {
        soundName = [sound stringByAppendingString:@".mp3"];
    }
    
    return soundName;
}

#pragma mark - Remind pill

+ (void)clearTakePillNotifications {
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSDictionary *userinfo = notification.userInfo;
        NSString *type = [userinfo validObjectForKey:LocalNotificationUserinfoTypeKey];
        if (type == nil
            || [type isEqualToString:LocalNotificationTypeTakePill]
            || [type isEqualToString:LocalNotificationTypeTakePillSpecial]
            || [type isEqualToString:LocalNotificationTypeTakePillRepeat]) {
            
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

+ (void)resetRemindNotify {
    
    if (![NotifyManager hasAuthority]) {
        return;
    }
    
    [NotifyManager clearTakePillNotifications];
    
    BOOL remind = [ReminderManager shouldRemind];
    if (remind) {
        if ([ReminderManager remindRepeat]) {
            // 重复提醒
            [[NotifyManager getInstance] performSelectorInBackground:@selector(resetRepeatNotify) withObject:nil];
            
        } else {
            BOOL remindEveryDay = [ScheduleManager isEveryday];
            BOOL takePlacebo = [ScheduleManager takePlaceboPills];
            BOOL reminderForPlaceBoPill = [ReminderManager remindPlaceboPill];
            if (remindEveryDay || (takePlacebo && reminderForPlaceBoPill)) {
                // 每天都吃
                [[NotifyManager getInstance] resetDailyNotify];
                
            } else {
                // 特定日期吃
                [[NotifyManager getInstance] performSelectorInBackground:@selector(resetSpecialNotify) withObject:nil];
            }
        }
        
    }
}

- (void)resetDailyNotify {
    
    NSDate *nowDate = [NSDate date];
    
    NSDate *notifyDate = [ReminderManager notifyTime];
    if ([RecordData selectRecord:nowDate]) {
        //如果今天已服用，则第二天开始通知
        notifyDate = [notifyDate dateByAddingTimeInterval:TimeIntervalDay];
    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSCalendarUnitDay;
    localNotification.fireDate = notifyDate;
    
    localNotification.alertBody = [ReminderManager notifyAlertBody];
    localNotification.applicationIconBadgeNumber = 1;
    
    //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
    NSString *sound = [ReminderManager notifySound];
    NSString *soundName = [NotifyManager soundName:sound];
    localNotification.soundName = soundName;
    
    //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
    localNotification.userInfo = @{LocalNotificationUserinfoTypeKey:LocalNotificationTypeTakePill};
    
    //在规定的日期触发通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)resetSpecialNotify {
    
    NSDate *nowDate = [NSDate date];
    
    NSDate *beginDate = [ReminderManager notifyTime];
    NSInteger beginDay = [ScheduleManager getInstance].currentDayFromStartDay;
    if (beginDate.isEarlier || [RecordData selectRecord:nowDate]) {
        beginDay++;
        beginDate = [beginDate dateByAddingTimeInterval:TimeIntervalDay];
    }
    
    NSInteger specialNotifyNum = 0;
    for (int day = 0; 1; day++) {
        
        NSInteger theday = beginDay + day;
        NSInteger remainder = theday % [ScheduleManager allDays];
        if (remainder < [ScheduleManager pillDays]) {
            
            //属于用药期内
            
            NSDate *fireDate = [beginDate dateByAddingTimeInterval:TimeIntervalDay * day];
            
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.repeatInterval = 0;
            
            localNotification.fireDate = fireDate;
            
            localNotification.alertBody = [ReminderManager notifyAlertBody];
            localNotification.applicationIconBadgeNumber = 1;
            
            
            //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
            NSString *sound = [ReminderManager notifySound];
            NSString *soundName = [NotifyManager soundName:sound];
            localNotification.soundName = soundName;
            
            //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
            localNotification.userInfo = @{LocalNotificationUserinfoTypeKey:LocalNotificationTypeTakePillSpecial};
            
            //在规定的日期触发通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            specialNotifyNum++;
            
            if (specialNotifyNum >= NotificationNumSpecific) {
                break;
            }
            
        }
    }
}

- (void)resetRepeatNotify {
    
    BOOL remindEveryDay = [ScheduleManager isEveryday];
    BOOL takePlacebo = [ScheduleManager takePlaceboPills];
    BOOL reminderForPlaceBoPill = [ReminderManager remindPlaceboPill];
    BOOL remindEveryday = remindEveryDay || (takePlacebo && reminderForPlaceBoPill);
   
    NSDate *nowDate = [NSDate date];
    
    NSDate *notifyTime = [ReminderManager notifyTime];
    NSInteger beginDay = [ScheduleManager getInstance].currentDayFromStartDay;
    if ([RecordData selectRecord:nowDate]) {
        beginDay++;
        notifyTime = [notifyTime dateByAddingTimeInterval:TimeIntervalDay];
    }
    
    UILocalNotification *snoozeNotification = [ReminderManager snoozeNotification];
    
    NSInteger specialNotifyNum = 0;
    for (int day = 0; 1; day++) {
        
        NSInteger theday = beginDay + day;
        NSInteger remainder = theday % [ScheduleManager allDays];
        if (remindEveryday || remainder < [ScheduleManager pillDays]) {
            
            NSDate *beginDate = notifyTime;
            if (day == 0 && snoozeNotification) {
                beginDate = [snoozeNotification.fireDate dateByAddingTimeInterval:TimeIntervalHour];
            }
            
            NSInteger currentHour = beginDate.components.hour;
            NSInteger notifyNum = 24 - currentHour;
            
            //属于用药期内
            for (NSInteger hour = 0; hour < notifyNum; hour++) {
                NSDate *fireDate = [beginDate dateByAddingTimeInterval:TimeIntervalDay * day + TimeIntervalHour * hour];
                if (fireDate.isEarlier) {
                    continue;
                }
                
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                localNotification.timeZone = [NSTimeZone defaultTimeZone];
                localNotification.repeatInterval = 0;
                
                localNotification.fireDate = fireDate;
                
                localNotification.alertBody = [ReminderManager notifyAlertBody];
                localNotification.applicationIconBadgeNumber = 1;
                
                
                //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
                NSString *sound = [ReminderManager notifySound];
                NSString *soundName = [NotifyManager soundName:sound];
                localNotification.soundName = soundName;
                
                //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
                localNotification.userInfo = @{LocalNotificationUserinfoTypeKey:LocalNotificationTypeTakePillRepeat};
                
                //在规定的日期触发通知
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                
                specialNotifyNum++;
                if (specialNotifyNum >= NotificationNumSpecific) {
                    return;
                }
            }
            
        }
    }
}


#pragma mark snooze


+ (void)snoozeInInterval:(NSTimeInterval)interval {
    UILocalNotification *localNotification = [ReminderManager snoozeNotification];
    if (localNotification != nil) {
        
        [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        
    }
    
    localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = [ReminderManager notifyAlertBody];
    localNotification.applicationIconBadgeNumber = 1;
    
    //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
    NSString *sound = [ReminderManager notifySound];
    NSString *soundName = [NotifyManager soundName:sound];
    localNotification.soundName = soundName;
    localNotification.userInfo = @{LocalNotificationUserinfoTypeKey:LocalNotificationTypeSnooze};
    
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:interval];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

#pragma mark - Refill

+ (void)notifyRefill {
    
    NSInteger startIndex = 0;
    NSDate *date = [RefillManager notifyTime];
    if (date.isEarlier) {
        startIndex = 1;
        date = [date dateByAddingTimeInterval:TimeIntervalDay];
    }
    
    for (NSInteger i = startIndex; i < NotificationMaxNumRefill && i < [RefillManager leftPillNum]; i++) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        
        NSDate *fireDate = [date dateByAddingTimeInterval:TimeIntervalDay * i];
        localNotification.fireDate = fireDate;
        localNotification.alertBody = LocalizedString(@"refill_alert_title");
        localNotification.applicationIconBadgeNumber = 1;
        
        
        NSString *sound = [RefillManager notifySound];
        NSString *soundName = [NotifyManager soundName:sound];
        localNotification.soundName = soundName;
        localNotification.userInfo = @{LocalNotificationUserinfoTypeKey:LocalNotificationTypeRefill};
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
}




#pragma mark - Active
/*
 每周一次通知，按月循环，独立于其它任务，永久分配
 */
+ (void)resetActiveNotify {
    
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSDictionary *userinfo = notification.userInfo;
        NSString *type = [userinfo validObjectForKey:LocalNotificationUserinfoTypeKey];
        if ([type isEqualToString:LocalNotificationTypeActive]) {
            
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    
    if (![NotifyManager hasAuthority]) {
        return;
    }
    
    
    NSDate *beginDate = [ReminderManager notifyTime];
    
    for (int i = 1; i <= NotificationNumActive; i++) {
        
        //属于用药期内
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.repeatInterval = 0;
        
        NSDate *fireDate = [beginDate dateByAddingTimeInterval:TimeIntervalDay * 7 * i + 60 * 10];
        localNotification.fireDate = fireDate;
        
        
        localNotification.alertBody = LocalizedString(@"Notification_AlertBody_Active_App");
        localNotification.applicationIconBadgeNumber = 1;
        
        //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
        NSString *sound = [ReminderManager notifySound];
        NSString *soundName = [NotifyManager soundName:sound];
        localNotification.soundName = soundName;
        
        //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
        localNotification.userInfo = @{LocalNotificationUserinfoTypeKey:LocalNotificationTypeActive};
        //在规定的日期触发通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

@end
