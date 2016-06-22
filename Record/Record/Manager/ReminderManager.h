//
//  ReminderManager.h
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>



// 激活提醒4个
static NSInteger NotificationNumActive = 4;
 
// 每天都吃药时，只需一个本地通知；非每天吃药时的通知为
static NSInteger NotificationNumSpecific = 48;
 

// 余下一个为Snooze通知


@interface ReminderManager : NSObject

@property(nonatomic, readonly) NSArray *soundArray;

+ (ReminderManager *)getInstance;


+ (void)resetNotify;
+ (void)checkReminder;


+ (void)checkNotifications;

#pragma mark - Authority
/**
 *  通知权限相关
 */

+ (BOOL)hasAuthority;


+ (void)setDidRegisterUserNotificationSettings;

+ (BOOL)didRegisterUserNotificationSettings;

#pragma mark - Business
/**
 *  业务相关
 *
 *
 */

+ (void)setShouldRmind:(BOOL)should;
+ (BOOL)shouldRmind;

+ (void)setRemindInSafeDays:(BOOL)remind;
+ (BOOL)remindInSafeDays;

+ (void)setNotificationAlertBody:(NSString *)alertBody;
+ (NSString *)notificationAlertBody;


+ (void)setNotificationTime:(NSString *)time;
+ (NSDate *)notificationTime;

+ (void)setNotificationSound:(NSString *)sound;
+ (NSString *)notificationSound;



#pragma mark - Snooze

+ (BOOL)canSnooze;


+ (UILocalNotification *)snoozeNotification;
+ (void)cancelSnoozeNotification;




+ (void)snoozeInInterval:(NSTimeInterval)interval;






@end
