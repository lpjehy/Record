//
//  ScheduleManager.m
//  Record
//
//  Created by Jehy Fan on 16/3/10.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "ScheduleManager.h"

#import "ReminderManager.h"

static NSString *IsEverydayKey = @"IsEveryday";
static NSString *PillDaysKey = @"PillDays";
static NSString *BreakDaysKey = @"BreakDays";
static NSString *TakePlaceboPillsKey = @"TakePlaceboPills";
static NSString *StartDateKey = @"StartDate";

static NSInteger DefaultPillDays = 21;
static NSInteger DefaultBreakDays = 7;



@implementation ScheduleManager


@synthesize currentDayFromStartDay, currentPack, currentCycle, today;

- (id)init {
    self = [super init];
    if (self) {
        
        self.today = NSDate.components;
        
        currentCycle = [self.class pillDays] + [self.class breakDays];
        
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:[[self class] startDate]];
        
        
        currentDayFromStartDay = timeInterval / TimeIntervalDay;
        
        currentPack = currentDayFromStartDay / currentCycle;
        
    }
    
    return self;
}

- (void)resetDate {
    currentCycle = [self.class pillDays] + [self.class breakDays];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:[[self class] startDate]];
    
    
    currentDayFromStartDay = timeInterval / TimeIntervalDay;
    
    currentPack = currentDayFromStartDay / currentCycle;
    
    
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
    NSInteger dayFromStartDay = currentCycle * (currentPack + pack) + day;
    NSTimeInterval timeInterval = dayFromStartDay * TimeIntervalDay;
    
    return [NSDate dateWithTimeInterval:timeInterval sinceDate:[self.class startDate]];
}

- (BOOL)isPlaceboDay:(NSDateComponents *)day {
    NSTimeInterval timeInterval = [[day theDate] timeIntervalSinceDate:[[self class] startDate]];
    
    NSInteger dayFromStartDay = (NSInteger)timeInterval / (NSInteger)TimeIntervalDay;
    NSInteger r = dayFromStartDay % currentCycle;
    
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
    if (days > DefaultPillDays) {
        days = DefaultPillDays;
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
    
    if (days > DefaultBreakDays) {
        days = DefaultBreakDays;
    }
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:days forKey:BreakDaysKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[[self class] getInstance] resetDate];
}
+ (NSInteger)breakDays {
    NSInteger safeDays = [[NSUserDefaults standardUserDefaults] integerForKey:BreakDaysKey];
    
    if (safeDays == 0) {
        safeDays = DefaultBreakDays;
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


+ (void)setStartDate:(NSDate *)date {
    
    
    [[NSUserDefaults standardUserDefaults] setValue:date forKey:StartDateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[[self class] getInstance] resetDate];
}
+ (NSDate *)startDate {
    NSDate *startDate = [[NSUserDefaults standardUserDefaults] valueForKey:StartDateKey];
    if (startDate == nil) {
        startDate = [NSDate date];
        [ScheduleManager setStartDate:startDate];
    }
    
    return startDate;
}


+ (NSInteger)allDays {
    return [[self class] pillDays] + [[self class] breakDays];
}

@end
