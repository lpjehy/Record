//
//  ReminderManager.h
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReminderManager : NSObject

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


+ (void)resetNotify;

+ (ReminderManager *)getInstance;

+ (void)test;


@property(nonatomic, readonly) NSArray *soundArray;

@end
