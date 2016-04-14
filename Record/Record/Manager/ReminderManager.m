//
//  ReminderManager.m
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "ReminderManager.h"
#import "ScheduleManager.h"


#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

static NSString *ShouldRemindKey = @"ShouldRemind";
static NSString *RemindInSafeDaysKey = @"RemindInSafeDays";
static NSString *NotificationAlertBodyKey = @"NotificationAlertBody";
static NSString *NotificationTimeKey = @"NotificationTime";
static NSString *NotificationSoundKey = @"NotificationSound";

#define DefaultAlertBody NSLocalizedString(@"reminder_default_alertbody", nil);

@interface ReminderManager () {
    
}



@end


@implementation ReminderManager

@synthesize soundArray;


+ (void)test {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
    //设置本地通知的时区
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //设置通知的内容
    localNotification.alertBody = [[self class] notificationAlertBody];
    localNotification.applicationIconBadgeNumber++;
    //设置通知动作按钮的标题
    localNotification.alertAction = @"查看";
    //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
    NSString *soundName = [[self class] notificationSound];
    if (![soundName isEqualToString:UILocalNotificationDefaultSoundName]) {
        soundName = [soundName stringByAppendingString:@".mp3"];
    }
    localNotification.soundName = soundName;
    //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
    localNotification.userInfo = @{@"id":@"test"};
    //在规定的日期触发通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    NSLog(@"scheduleLocalNotification in %@", localNotification.fireDate.description);
    //立即触发一个通知
    //[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

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
        soundArray = @[UILocalNotificationDefaultSoundName, @"bird", @"cat1", @"cat2", @"cat3", @"cat4", @"cat5", @"coin", @"cup", @"doorbell1", @"doorbell2", @"melonfruit", @"popcorn", @"teddy", @"trafficlight", @"turkey", @"unpacking", @"windbell", @"yoho"];
    }
    
    return self;
}


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
    if (sound == nil || sound.length == 0) {
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



+ (void)resetNotify {
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    BOOL remind = [[self class] shouldRmind];
    if (remind) {
        BOOL remindEveryDay = [ScheduleManager isEveryday];
        BOOL takePlacebo = [ScheduleManager takePlaceboPills];
        BOOL reminderForPlaceBoPill = [ReminderManager remindInSafeDays];
        if (remindEveryDay || (takePlacebo && reminderForPlaceBoPill)) {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.repeatInterval = NSCalendarUnitDay;
            
            
            localNotification.fireDate = [[self class] notificationTime];
            
            localNotification.alertBody = [[self class] notificationAlertBody];
            //localNotification.applicationIconBadgeNumber++;
            //设置通知动作按钮的标题
            localNotification.alertAction = NSLocalizedString(@"button_title_view", nil);
            //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
            NSString *soundName = [[self class] notificationSound];
            if (![soundName isEqualToString:UILocalNotificationDefaultSoundName]) {
                soundName = [soundName stringByAppendingString:@".mp3"];
            }
            localNotification.soundName = soundName;
            
            //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
            //localNotification.userInfo = userInfo;
            //在规定的日期触发通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        } else {
            [[[self class] getInstance] performSelectorInBackground:@selector(resetSpecialNotify) withObject:nil];
        }
    }
}

- (void)resetSpecialNotify {
    
    NSDate *beginDate = [[self class] notificationTime];
    NSInteger beginDay = [ScheduleManager getInstance].currentDayFromStartDay;
    if (!beginDate.isEarlier) {
        //beginDay++;
        //beginDate = [beginDate dateByAddingTimeInterval:TimeIntervalDay];
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
            //localNotification.applicationIconBadgeNumber++;
            //设置通知动作按钮的标题
            localNotification.alertAction = NSLocalizedString(@"button_title_view", nil);
            //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
            NSString *soundName = [[self class] notificationSound];
            if (![soundName isEqualToString:UILocalNotificationDefaultSoundName]) {
                soundName = [soundName stringByAppendingString:@".mp3"];
            }
            localNotification.soundName = soundName;
            
            //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
            //localNotification.userInfo = userInfo;
            //在规定的日期触发通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
            if (array.count >= 64) {
                break;
            }
        }
    }
    
}


@end
