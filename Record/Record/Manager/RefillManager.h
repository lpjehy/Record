//
//  RefillManager.h
//  Reminder
//
//  Created by Jehy Fan on 16/7/2.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>


// 最大剩余药量
static NSInteger MaxLeftPillNum = 99;


@interface RefillManager : NSObject

#pragma mark - 配置
+ (void)setShouldNotify:(BOOL)should;
+ (BOOL)shouldNotify;

+ (void)setLeftPillNum:(NSInteger)num;
+ (NSInteger)leftPillNum;

+ (void)setNotifyPillNum:(NSInteger)num;
+ (NSInteger)notifyPillNum;

+ (void)setNotifyTime:(NSString *)time;
+ (NSDate *)notifyTime;

+ (void)setNotifySound:(NSString *)sound;
+ (NSString *)notifySound;



#pragma mark - 通知
+ (void)checkRefillNotify;

+ (void)cancelRefillNotification;

#pragma mark - 提醒
+ (void)showRemindRefill;

@end
