//
//  ReminderManager.m
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "ReminderManager.h"

static NSString *RemindInSafeDaysKey = @"RemindInSafeDays";
static NSString *NotificationAlertBodyKey = @"NotificationAlertBody";
static NSString *NotificationTimeKey = @"NotificationTime";
static NSString *NotificationSoundKey = @"NotificationSound";

static NSString *DefaultAlertBody = @"Please take yousr contraceptive pill~";


@implementation ReminderManager


+ (void)setRemindInSafeDays:(BOOL)remind {
    [[NSUserDefaults standardUserDefaults] setInteger:remind forKey:RemindInSafeDaysKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
}
+ (NSString *)notificationAlertBody {
    NSString * alertBody = [[NSUserDefaults standardUserDefaults] valueForKey:NotificationAlertBodyKey];
    
    if (alertBody == nil) {
        alertBody = DefaultAlertBody;
    }
    
    return alertBody;
}


+ (void)setNotificationTime:(NSTimeInterval)time {
    [[NSUserDefaults standardUserDefaults] setFloat:time forKey:NotificationTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSDate *)notificationTime {
    NSTimeInterval time = [[NSUserDefaults standardUserDefaults] floatForKey:NotificationTimeKey];
    
    if (time == 0) {
        time = [NSDate date].timeIntervalSince1970;
        [ReminderManager setNotificationTime:time];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    return date;
}

+ (void)setNotificationSoundBody:(NSString *)sound {
    if (sound == nil || sound.length == 0) {
        sound = UILocalNotificationDefaultSoundName;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:sound forKey:NotificationSoundKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)notificationSound {
    NSString * sound = [[NSUserDefaults standardUserDefaults] valueForKey:NotificationSoundKey];
    
    if (sound == nil) {
        sound = UILocalNotificationDefaultSoundName;
    }
    
    return sound;
}

@end
