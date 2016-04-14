//
//  AppManager.m
//  Imager
//
//  Created by Jehy Fan on 16/2/24.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "AppManager.h"

#import "RecordManager.h"

static NSString *MarkFirstOpenedKey = @"MarkFirstOpened";
static NSString *MarkFirstSetDoneKey = @"MarkFirstSetDone";
static NSString *MarkFirstPackShowedKey = @"MarkFirstPackShowed";
static NSString *MarkFirstOpenedByReminderKey = @"MarkFirstOpenedByReminder";
static NSString *MarkFirstTakeByReminderKey = @"MarkFirstTakeByRedminder";

static NSString *MarkIsFirstOpeningByReminderKey = @"MarkIsFirstOpeningByRedminder";

@implementation AppManager

+ (void)Initialize
{
    [AnalyticsUtil Initialize];
    
    
}


+ (BOOL)hasFirstOpened {
    return [[NSUserDefaults standardUserDefaults] boolForKey:MarkFirstOpenedKey];
}
+ (BOOL)hasFirstSetDone {
    return [[NSUserDefaults standardUserDefaults] boolForKey:MarkFirstSetDoneKey];
}
+ (BOOL)hasFirstPackShowed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:MarkFirstPackShowedKey];
}
+ (BOOL)hasFirstOpenedByReminder {
    return [[NSUserDefaults standardUserDefaults] boolForKey:MarkFirstOpenedByReminderKey];
}
+ (BOOL)hasFirstTakeByReminder {
    return [[NSUserDefaults standardUserDefaults] boolForKey:MarkFirstTakeByReminderKey];
}

+ (void)setFirstOpened {
    
    [AnalyticsUtil event:Event_First_Opened];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MarkFirstOpenedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)setFirstSetDone {
    [AnalyticsUtil event:Event_First_Set_Done];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MarkFirstSetDoneKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)setFirstPackShowed {
    [AnalyticsUtil event:Event_First_Pack_Showed];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MarkFirstPackShowedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)setFirstOpenedByReminder {
    [AnalyticsUtil event:Event_First_Opened_By_Reminder];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MarkFirstOpenedByReminderKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)setFirstTakeByReminder {
    [AnalyticsUtil event:Event_First_Take_By_Reminder];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MarkFirstTakeByReminderKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isFirstOpeningByReminder {
    return [[NSUserDefaults standardUserDefaults] boolForKey:MarkIsFirstOpeningByReminderKey];
}

+ (void)setFirstOpeningByReminder:(BOOL)is {
    
    [[NSUserDefaults standardUserDefaults] setBool:is forKey:MarkIsFirstOpeningByReminderKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
