//
//  ReminderManager.h
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>






 

// 余下一个为Snooze通知


@interface ReminderManager : NSObject



+ (ReminderManager *)getInstance;









#pragma mark - Config
/**
 *  业务相关
 *
 *
 */

+ (void)setShouldRmind:(BOOL)should;
+ (BOOL)shouldRemind;

+ (void)setRemindPlaceboPill:(BOOL)remind;
+ (BOOL)remindPlaceboPill;

+ (void)setNotifyAlertBody:(NSString *)alertBody;
+ (NSString *)notifyAlertBody;


+ (void)setNotifyTime:(NSString *)time;
+ (NSDate *)notifyTime;

+ (void)setRemindRepeat:(BOOL)repeat;
+ (BOOL)remindRepeat;

+ (void)setNotifySound:(NSString *)sound;
+ (NSString *)notifySound;



#pragma mark - Snooze

+ (BOOL)canSnooze;


+ (UILocalNotification *)snoozeNotification;
+ (void)cancelSnoozeNotification;








@end
