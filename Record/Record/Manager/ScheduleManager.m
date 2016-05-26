//
//  ScheduleManager.m
//  Record
//
//  Created by Jehy Fan on 16/3/10.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "ScheduleManager.h"

#import "ReminderManager.h"
#import "RecordData.h"
#import "MessageManager.h"

static NSString *IsEverydayKey = @"IsEveryday";
static NSString *PillDaysKey = @"PillDays";
static NSString *BreakDaysKey = @"BreakDays";
static NSString *TakePlaceboPillsKey = @"TakePlaceboPills";
static NSString *StartDateKey = @"StartDate";

static NSInteger DefaultPillDays = 21;
static NSInteger DefaultBreakDays = 7;



@implementation ScheduleManager

@synthesize startDay;

@synthesize today;

@synthesize currentDayFromStartDay;

@synthesize currentPack, currentPackDay;

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

- (BOOL)isBreakDay:(NSDateComponents *)day {
    NSTimeInterval timeInterval = [[day theDate] timeIntervalSinceDate:[[self class] startDate]];
    
    NSInteger dayFromStartDay = (NSInteger)timeInterval / (NSInteger)TimeIntervalDay;
    NSInteger remainder = dayFromStartDay % [ScheduleManager allDays];
    
    if (remainder >= [[self class] pillDays]) {
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


+ (void)setPillDays:(NSInteger)pilldays
          breakDays:(NSInteger)breakDays
          startDate:(NSDate *)date {
    if (pilldays > MaxPillDays) {
        pilldays = MaxPillDays;
    }
    
    if (breakDays > MaxBreakDays) {
        breakDays = MaxBreakDays;
    }
    
    
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:pilldays forKey:PillDaysKey];
    [[NSUserDefaults standardUserDefaults] setInteger:breakDays forKey:BreakDaysKey];
    [[NSUserDefaults standardUserDefaults] setValue:date forKey:StartDateKey];
    
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

- (void)resetRecordFrom:(NSDate *)startDate toDate:(NSDate *)endDate {
    
    NSDate *date = startDate;
    
    BOOL takePlaceboPill = [ScheduleManager takePlaceboPills];
    NSLog(@"take PlaceboPill: %zi", takePlaceboPill);
    
    NSInteger allDays = [[self class] allDays];
    NSInteger pillDay = [ScheduleManager pillDays];
    for (int i = 0; [date isEarlierThan:endDate]; i++) {
       
        NSInteger r = i % allDays;
        
        if (takePlaceboPill || r < pillDay) {
            NSLog(@"%zi day of %zi pill days: ", r, pillDay);
            [RecordData record:date];
        }
        
        
        date = [date dateByAddingTimeInterval:TimeIntervalDay];
    }
    
    [[MessageManager getInstance] reloadData];
}


+ (NSDate *)startDate {
    NSDate *startDate = [[NSUserDefaults standardUserDefaults] valueForKey:StartDateKey];
    if (startDate == nil) {
        startDate = [NSDate date];
        NSDateComponents *day = startDate.components;
        NSString *dayStr = [NSString stringWithFormat:@"%04zi-%02zi-%02zi 00:00:00.0", day.year, day.month, day.day];
        startDate = dayStr.date;
        
        
        [[NSUserDefaults standardUserDefaults] setValue:startDate forKey:StartDateKey];
    }
    
    return startDate;
}


+ (NSInteger)allDays {
    return [[self class] pillDays] + [[self class] breakDays];
}


- (NSString *)todayInfo {
    
    //设置副标题
    NSInteger currentDay = currentPackDay;
    NSInteger allDays = [ScheduleManager pillDays];
    
    BOOL takePlaceBo = [ScheduleManager takePlaceboPills];
    
    
    NSString *baseTitle = nil;
    if (currentDay <= allDays) {
        baseTitle = LocalizedString(@"pack_subtitle_pilldays");
        
    } else {
        currentDay -= allDays;
        allDays = [ScheduleManager breakDays];
        if (takePlaceBo) {
            baseTitle = LocalizedString(@"pack_subtitle_placebodays");
        } else {
            baseTitle = LocalizedString(@"pack_subtitle_breakdays");
        }
    }
    
    NSString *info = nil;
    if ([LanguageManager isZH_Han]) {
        info = [NSString stringWithFormat:baseTitle, allDays, currentDay];
    } else {
        info = [NSString stringWithFormat:baseTitle, currentDay, allDays];
    }
    return info;
}

@end
