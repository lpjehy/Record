//
//  ScheduleManager.m
//  Record
//
//  Created by Jehy Fan on 16/3/10.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "ScheduleManager.h"

#import "ReminderManager.h"
#import "RecordManager.h"

static NSString *IsEverydayKey = @"IsEveryday";
static NSString *PillDaysKey = @"PillDays";
static NSString *BreakDaysKey = @"BreakDays";
static NSString *TakePlaceboPillsKey = @"TakePlaceboPills";
static NSString *StartDateKey = @"StartDate";

static NSInteger DefaultPillDays = 21;
static NSInteger DefaultBreakDays = 7;



@implementation ScheduleManager


@synthesize currentDayFromStartDay, currentPack, today, currentPackDay, startDay;

- (id)init {
    self = [super init];
    if (self) {
        
        self.today = NSDate.components;
        self.startDay = [ScheduleManager startDate].components;
        
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:[[self class] startDate]];
        
        
        currentDayFromStartDay = timeInterval / TimeIntervalDay;
        
        NSInteger allDays = [[self class] allDays];
        currentPack = currentDayFromStartDay / allDays;
        currentPackDay = currentDayFromStartDay % allDays + 1;
    }
    
    return self;
}

- (void)resetDate {
    
    self.today = NSDate.components;
    self.startDay = [ScheduleManager startDate].components;
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:[[self class] startDate]];
    
    
    currentDayFromStartDay = timeInterval / TimeIntervalDay;
    
    currentPack = currentDayFromStartDay / [ScheduleManager allDays];
    currentPackDay = currentDayFromStartDay % [ScheduleManager allDays] + 1;
    
    [ReminderManager resetNotify];
    
}

+ (ScheduleManager *)getInstance {
    static ScheduleManager *instance = nil;
    if (instance == nil) {
        instance = [[ScheduleManager alloc] init];
    }
    
    return instance;
}


- (NSDate *)dateInPack:(NSInteger)pack day:(NSInteger)day {
    if (day >= [ScheduleManager allDays]) {
        return nil;
    }
    NSInteger dayFromStartDay = [ScheduleManager allDays] * (currentPack + pack) + day;
    NSTimeInterval timeInterval = dayFromStartDay * TimeIntervalDay;
    
    return [NSDate dateWithTimeInterval:timeInterval sinceDate:[self.class startDate]];
}

- (BOOL)isPlaceboDay:(NSDateComponents *)day {
    NSTimeInterval timeInterval = [[day theDate] timeIntervalSinceDate:[[self class] startDate]];
    
    NSInteger dayFromStartDay = (NSInteger)timeInterval / (NSInteger)TimeIntervalDay;
    NSInteger r = dayFromStartDay % [ScheduleManager allDays];
    
    if (r >= [[self class] pillDays]) {
        return YES;
    }
    
    return NO;
}


+ (void)setIsEveryday:(BOOL)everyday {
    [[NSUserDefaults standardUserDefaults] setBool:everyday forKey:IsEverydayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[[self class] getInstance] resetDate];
}
+ (BOOL)isEveryday {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsEverydayKey];
}



+ (void)setPillDays:(NSInteger)days {
    if (days > MaxPillDays) {
        days = MaxPillDays;
    }
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:days forKey:PillDaysKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[[self class] getInstance] resetDate];
}
+ (NSInteger)pillDays {
    NSInteger pillDays = [[NSUserDefaults standardUserDefaults] integerForKey:PillDaysKey];
    
    if (pillDays == 0) {
        pillDays = DefaultPillDays;
    }
    
    return pillDays;
}

+ (void)setSafeDays:(NSInteger)days {
    
    if (days > MaxBreakDays) {
        days = MaxBreakDays;
    }
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:days forKey:BreakDaysKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[[self class] getInstance] resetDate];
}
+ (NSInteger)breakDays {
    NSInteger safeDays = [[NSUserDefaults standardUserDefaults] integerForKey:BreakDaysKey];
    
    if (safeDays == 0 && ![AppManager hasFirstSetDone]) {
        safeDays = DefaultBreakDays;
        
        [[NSUserDefaults standardUserDefaults] setInteger:safeDays forKey:BreakDaysKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return safeDays;
}

+ (void)setTakePlaceboPills:(BOOL)take {
    [[NSUserDefaults standardUserDefaults] setBool:take forKey:TakePlaceboPillsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[[self class] getInstance] resetDate];
}
+ (BOOL)takePlaceboPills {
    return [[NSUserDefaults standardUserDefaults] boolForKey:TakePlaceboPillsKey];

    
}

- (void)resetRecord:(NSDate *)date {
    NSDate *todayDate = [NSString stringWithFormat:@"%zi-%02zi-%02zi 00:00:00.0", today.year, today.month, today.day].date;
    while ([date isEarlierThan:todayDate]) {
        [RecordManager record:date];
        
        date = [date dateByAddingTimeInterval:TimeIntervalDay];
    }
    
    
    [[[self class] getInstance] resetDate];
}

+ (void)setStartDate:(NSDate *)date {
    
    
    [[NSUserDefaults standardUserDefaults] setValue:date forKey:StartDateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[[self class] getInstance] performSelectorInBackground:@selector(resetRecord:) withObject:date];
}
+ (NSDate *)startDate {
    NSDate *startDate = [[NSUserDefaults standardUserDefaults] valueForKey:StartDateKey];
    if (startDate == nil) {
        startDate = [NSDate date];
        NSDateComponents *day = startDate.components;
        NSString *dayStr = [NSString stringWithFormat:@"%04zi-%02zi-%02zi 00:00:00.0", day.year, day.month, day.day];
        startDate = dayStr.date;
        [ScheduleManager setStartDate:startDate];
    }
    
    return startDate;
}


+ (NSInteger)allDays {
    return [[self class] pillDays] + [[self class] breakDays];
}


@end
