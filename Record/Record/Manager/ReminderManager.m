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


#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

static NSString *ShouldRemindKey = @"ShouldRemind";
static NSString *RemindInSafeDaysKey = @"RemindInSafeDays";
static NSString *NotificationAlertBodyKey = @"NotificationAlertBody";
static NSString *NotificationTimeKey = @"NotificationTime";
static NSString *NotificationSoundKey = @"NotificationSound";



static NSString *DidRegisterUserNotificationSettingsKey = @"DidRegisterUserNotificationSettings";



static NSString *LocalNotificationUserinfoTypeKey = @"LocalNotificationUserinfoKeyType";
static NSString *LocalNotificationTypeActive = @"LocalNotificationTypeActive";
static NSString *LocalNotificationTypeTakePill = @"LocalNotificationTypeTakePill";
static NSString *LocalNotificationTypeTakePillSpecial = @"LocalNotificationTypeTakePillSpecial";
static NSString *LocalNotificationTypeSnooze = @"LocalNotificationTypeSnooze";

#define DefaultAlertBody LocalizedString(@"reminder_default_alertbody");

@interface ReminderManager () <UIAlertViewDelegate> {
    
}



@end


@implementation ReminderManager

@synthesize soundArray;



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
        soundArray = @[SoundNameDefault, @"Chewing", @"Drums", @"Cat", @"Coin", @"Yoho"];
    }
    
    return self;
}



#pragma mark - Set Notifications


+ (void)checkReminder {
    if ([AppManager hasFirstSetDone]) {
        // 用户已经确认过本地通知权限
        
        if ([ReminderManager hasAuthority]) {
            // 如果有权限
            
            [ReminderManager resetNotify];
            
            
        }
    }
}

+ (void)clearNotifications {
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSDictionary *userinfo = notification.userInfo;
        NSString *type = [userinfo validObjectForKey:LocalNotificationUserinfoTypeKey];
        if (type == nil || ![type isEqualToString:LocalNotificationTypeSnooze]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

+ (void)resetNotify {
    
    if (![ReminderManager hasAuthority]) {
        return;
    }
    
    [ReminderManager clearNotifications];
    
    BOOL remind = [[self class] shouldRmind];
    if (remind) {
        BOOL remindEveryDay = [ScheduleManager isEveryday];
        BOOL takePlacebo = [ScheduleManager takePlaceboPills];
        BOOL reminderForPlaceBoPill = [ReminderManager remindInSafeDays];
        if (remindEveryDay || (takePlacebo && reminderForPlaceBoPill)) {
            
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.repeatInterval = NSCalendarUnitDay;
            
            
            NSDate *notifyDate = [[self class] notificationTime];
            if ([RecordData selectRecord:[NSDate date]]) {
                //如果今天已服用，则第二天开始通知
                notifyDate = [notifyDate dateByAddingTimeInterval:TimeIntervalDay];
            }
            
            localNotification.fireDate = notifyDate;
            
            localNotification.alertBody = [[self class] notificationAlertBody];
            localNotification.applicationIconBadgeNumber = 1;
            //设置通知动作按钮的标题
            localNotification.alertAction = LocalizedString(@"button_title_view");
            //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
            NSString *soundName = [[self class] notificationSound];
            if (![soundName isEqualToString:UILocalNotificationDefaultSoundName]) {
                soundName = [soundName stringByAppendingString:@".mp3"];
            }
            localNotification.soundName = soundName;
            
            //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
            localNotification.userInfo = @{LocalNotificationUserinfoTypeKey:LocalNotificationTypeTakePill};
            //在规定的日期触发通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        } else {
            [[[self class] getInstance] performSelectorInBackground:@selector(resetSpecialNotify) withObject:nil];
        }
    }
    
    [[[self class] getInstance] resetActiveNotify];
}

- (void)resetSpecialNotify {
    
    NSDate *beginDate = [[self class] notificationTime];
    NSInteger beginDay = [ScheduleManager getInstance].currentDayFromStartDay;
    if (beginDate.isEarlier || [RecordData selectRecord:[NSDate date]]) {
        beginDay++;
        beginDate = [beginDate dateByAddingTimeInterval:TimeIntervalDay];
    }
    
    for (int i = 0; 1; i++) {
        
        NSInteger theday = beginDay + i;
        NSInteger remainder = theday % [ScheduleManager allDays];
        if (remainder < [ScheduleManager pillDays]) {
            
            //属于用药期内
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.repeatInterval = NSCalendarUnitDay;
            NSDate *fireDate = [beginDate dateByAddingTimeInterval:TimeIntervalDay * i];
            localNotification.fireDate = fireDate;
            if ([UIApplication sharedApplication].scheduledLocalNotifications.count == 0) {
                
            }
            
            localNotification.alertBody = [[self class] notificationAlertBody];
            localNotification.applicationIconBadgeNumber = 1;
            //设置通知动作按钮的标题
            localNotification.alertAction = LocalizedString(@"button_title_view");
            //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
            NSString *soundName = [[self class] notificationSound];
            if (![soundName isEqualToString:UILocalNotificationDefaultSoundName]) {
                soundName = [soundName stringByAppendingString:@".mp3"];
            }
            localNotification.soundName = soundName;
            
            //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
            localNotification.userInfo = @{LocalNotificationUserinfoTypeKey:LocalNotificationTypeTakePillSpecial};
            
            //在规定的日期触发通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
            if (array.count >= NotificationNumSpecific) {
                break;
            }
        }
    }
    
    
    
}


/*
 每周一次通知，按月循环
 */
- (void)resetActiveNotify {
    
    NSDate *beginDate = [[self class] notificationTime];
    
    for (int i = 1; i <= NotificationNumActive; i++) {
        
        //属于用药期内
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.repeatInterval = kCFCalendarUnitMonth;
        
        NSDate *fireDate = [beginDate dateByAddingTimeInterval:TimeIntervalDay * 7 * i + 60 * 10];
        localNotification.fireDate = fireDate;
        
        
        localNotification.alertBody = LocalizedString(@"reminder_take_pill");
        localNotification.applicationIconBadgeNumber = 1;
        //设置通知动作按钮的标题
        localNotification.alertAction = LocalizedString(@"button_title_view");
        //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
        NSString *soundName = [[self class] notificationSound];
        if (![soundName isEqualToString:UILocalNotificationDefaultSoundName]) {
            soundName = [soundName stringByAppendingString:@".mp3"];
        }
        localNotification.soundName = soundName;
        
        //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
        localNotification.userInfo = @{LocalNotificationUserinfoTypeKey:LocalNotificationTypeActive};
        //在规定的日期触发通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

+ (void)checkNotifications {
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSDictionary *userinfo = notification.userInfo;
        NSString *type = [userinfo validObjectForKey:LocalNotificationUserinfoTypeKey];
        NSLog(@"%@ %@", type, notification.fireDate.description);
        
        
    }
}


#pragma mark - Authority

+ (void)setDidRegisterUserNotificationSettings {
    [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:DidRegisterUserNotificationSettingsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+ (BOOL)didRegisterUserNotificationSettings {
    NSInteger did = [[NSUserDefaults standardUserDefaults] boolForKey:DidRegisterUserNotificationSettingsKey];
    
    
    return did;
}

//

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


#pragma mark - Business
/**
 *  业务相关
 *
 *
 */

+ (void)setShouldRmind:(BOOL)should {
    [[NSUserDefaults standardUserDefaults] setInteger:should forKey:ShouldRemindKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [ReminderManager resetNotify];
}
+ (BOOL)shouldRmind {
    NSInteger should = [[NSUserDefaults standardUserDefaults] boolForKey:ShouldRemindKey];
    
    
    return should;
}

+ (void)setRemindInSafeDays:(BOOL)remind {
    [[NSUserDefaults standardUserDefaults] setInteger:remind forKey:RemindInSafeDaysKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [ReminderManager resetNotify];
}
+ (BOOL)remindInSafeDays {
    NSInteger remindInSafeDays = [[NSUserDefaults standardUserDefaults] boolForKey:RemindInSafeDaysKey];
    
    
    return remindInSafeDays;
}

+ (void)setNotificationAlertBody:(NSString *)alertBody {
    if (alertBody == nil || alertBody.length == 0) {
        alertBody = DefaultAlertBody;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:alertBody forKey:NotificationAlertBodyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [ReminderManager resetNotify];
}
+ (NSString *)notificationAlertBody {
    NSString * alertBody = [[NSUserDefaults standardUserDefaults] valueForKey:NotificationAlertBodyKey];
    
    if (alertBody == nil) {
        alertBody = DefaultAlertBody;
    }
    
    return alertBody;
}


+ (void)setNotificationTime:(NSString *)time {
    [[NSUserDefaults standardUserDefaults] setValue:time forKey:NotificationTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [ReminderManager resetNotify];
}
+ (NSDate *)notificationTime {
    NSDate *date = nil;
    
    NSString *time = [[NSUserDefaults standardUserDefaults] valueForKey:NotificationTimeKey];
    if (time == nil) {
        date = [NSDate dateWithTimeIntervalSinceNow:-10];
        
        time = [date stringWithFormat:@"HH:mm"];
        [ReminderManager setNotificationTime:time];
    } else {
        NSDateComponents *today = NSDate.components;
        date = [NSString stringWithFormat:@"%zi-%02zi-%02zi %@:00.0", today.year, today.month, today.day, time].date;
    }
    
    return date;
}

+ (void)setNotificationSound:(NSString *)sound {
    if (sound == nil || sound.length == 0 || [sound isEqualToString:SoundNameDefault]) {
        sound = UILocalNotificationDefaultSoundName;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:sound forKey:NotificationSoundKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [ReminderManager resetNotify];
}
+ (NSString *)notificationSound {
    NSString * sound = [[NSUserDefaults standardUserDefaults] valueForKey:NotificationSoundKey];
    
    if (sound == nil) {
        sound = UILocalNotificationDefaultSoundName;
    }
    
    return sound;
}


#pragma mark - Snooze

+ (BOOL)canSnooze {
    if ([ReminderManager hasAuthority]
        // 有通知权限
        
        && [ReminderManager shouldRmind]) {
        // 需要通知
        
        if ([ScheduleManager isEveryday]
            || ([ScheduleManager takePlaceboPills] && [ReminderManager remindInSafeDays])
            || ![[ScheduleManager getInstance] isBreakDay:[ScheduleManager getInstance].today]) {
            //这一天需要通知
            
            
            NSDate *remindDate = [ReminderManager notificationTime];
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


+ (void)snoozeInInterval:(NSTimeInterval)interval {
    UILocalNotification *localNotification = [ReminderManager snoozeNotification];
    if (localNotification != nil) {
        
        [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        
    }
    
    localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = [[self class] notificationAlertBody];
    localNotification.applicationIconBadgeNumber = 1;
    //设置通知动作按钮的标题
    localNotification.alertAction = LocalizedString(@"button_title_view");
    //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
    NSString *soundName = [[self class] notificationSound];
    if (![soundName isEqualToString:UILocalNotificationDefaultSoundName]) {
        soundName = [soundName stringByAppendingString:@".mp3"];
    }
    localNotification.soundName = soundName;
    localNotification.userInfo = @{LocalNotificationUserinfoTypeKey:LocalNotificationTypeSnooze};
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:interval];
    
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    
}



@end
