//
//  ScheduleManager.m
//  Record
//
//  Created by Jehy Fan on 16/3/10.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "ScheduleManager.h"

static NSString *IsEverydayKey = @"IsEveryday";
static NSString *PillDaysKey = @"PillDays";
static NSString *SafeDaysKey = @"SafeDays";
static NSString *StartDateKey = @"StartDate";

static NSInteger DefaultPillDays = 21;
static NSInteger DefaultSafeDays = 7;



@implementation ScheduleManager

+ (void)setIsEveryday:(BOOL)everyday {
    [[NSUserDefaults standardUserDefaults] setBool:everyday forKey:IsEverydayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)isEveryday {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsEverydayKey];
}


+ (void)setPillDays:(NSInteger)days {
    if (days > DefaultPillDays) {
        days = DefaultPillDays;
    }
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:days forKey:PillDaysKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSInteger)pillDays {
    NSInteger pillDays = [[NSUserDefaults standardUserDefaults] integerForKey:PillDaysKey];
    
    if (pillDays == 0) {
        pillDays = DefaultPillDays;
    }
    
    return pillDays;
}

+ (void)setSafeDays:(NSInteger)days {
    
    if (days > DefaultSafeDays) {
        days = DefaultSafeDays;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:days forKey:SafeDaysKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSInteger)safeDays {
    NSInteger safeDays = [[NSUserDefaults standardUserDefaults] integerForKey:SafeDaysKey];
    
    if (safeDays == 0) {
        safeDays = DefaultSafeDays;
    }
    
    return safeDays;
}


+ (void)setStartDate:(NSTimeInterval)date {
    [[NSUserDefaults standardUserDefaults] setFloat:date forKey:StartDateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSDate *)startDate {
    NSTimeInterval startDateTimeInterval = [[NSUserDefaults standardUserDefaults] floatForKey:StartDateKey];
    if (startDateTimeInterval == 0) {
        startDateTimeInterval = [NSDate date].timeIntervalSince1970;
        [ScheduleManager setStartDate:startDateTimeInterval];
    }
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startDateTimeInterval];
    
    return startDate;
}

+ (NSInteger)allDays {
    NSInteger alldays = [ScheduleManager pillDays] + [ScheduleManager safeDays];
    
    return alldays;
}

@end
