//
//  ReminderManager.h
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReminderManager : NSObject

+ (void)setRemindInSafeDays:(BOOL)remind;
+ (BOOL)remindInSafeDays;

+ (void)setNotificationAlertBody:(NSString *)alertBody;
+ (NSString *)notificationAlertBody;


+ (void)setNotificationTime:(NSTimeInterval)time;
+ (NSDate *)notificationTime;

+ (void)setNotificationSoundBody:(NSString *)sound;
+ (NSString *)notificationSound;


@end
