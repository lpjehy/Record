//
//  NotifyUtil.h
//  Reminder
//
//  Created by Jehy Fan on 16/7/2.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>




static NSString *LocalNotificationUserinfoTypeKey = @"LocalNotificationUserinfoKeyType";


static NSString *LocalNotificationTypeActive = @"LocalNotificationTypeActive";
static NSString *LocalNotificationTypeTakePill = @"LocalNotificationTypeTakePill";
static NSString *LocalNotificationTypeTakePillSpecial = @"LocalNotificationTypeTakePillSpecial";
static NSString *LocalNotificationTypeTakePillRepeat = @"LocalNotificationTypeTakePillRepeat";
static NSString *LocalNotificationTypeSnooze = @"LocalNotificationTypeSnooze";
static NSString *LocalNotificationTypeRefill = @"LocalNotificationTypeRefill";

// 激活提醒4个
static NSInteger NotificationNumActive = 4;

// 每天都吃药时，只需一个本地通知；非每天吃药时的通知为
static NSInteger NotificationNumSpecific = 48;

// refill通知
static NSInteger NotificationMaxNumRefill = 6;



@interface NotifyManager : NSObject


#pragma mark - Authority
/**
 *  通知权限相关
 */

+ (BOOL)hasAuthority;
+ (void)setDidRegisterUserNotificationSettings;
+ (BOOL)didRegisterUserNotificationSettings;


#pragma mark - Notifications
+ (void)checkNotifications;
+ (NSString *)soundName:(NSString *)sound;


#pragma mark - Reminder pill

+ (void)resetRemindNotify;

#pragma mark snooze
+ (void)snoozeInInterval:(NSTimeInterval)interval;

#pragma mark - Refill
+ (void)notifyRefill;

#pragma mark - Active
+ (void)resetActiveNotify;

@end
