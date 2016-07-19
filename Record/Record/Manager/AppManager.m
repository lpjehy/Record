//
//  AppManager.m
//  Imager
//
//  Created by Jehy Fan on 16/2/24.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "AppManager.h"

#import "RecordData.h"
#import "OnlineConfigUtil.h"
#import "ReminderManager.h"
#import "NotifyManager.h"
#import "ScheduleManager.h"
#import "HelpView.h"


static NSString *MarkFirstOpenedKey = @"MarkFirstOpened";
static NSString *MarkFirstSetDoneKey = @"MarkFirstSetDone";
static NSString *MarkFirstPackShowedKey = @"MarkFirstPackShowed";
static NSString *MarkFirstOpenedByReminderKey = @"MarkFirstOpenedByReminder";
static NSString *MarkFirstTakeByReminderKey = @"MarkFirstTakeByRedminder";

static NSString *MarkIsFirstOpeningByReminderKey = @"MarkIsFirstOpeningByRedminder";



@implementation AppManager

+ (void)Initialize
{
    if ([AppManager hasFirstSetDone]) {
        [ActionManager action:Action_APP_Init];
    }
    
    
    [LanguageManager Initialize];
    
    [AnalyticsUtil Initialize];
    
    
}

+ (void)Update {
    
    [[AnalyticsUtil getOnceActiveKeys] removeAllObjects];
    
    [ActionManager action:Action_APP_Active];
    
    
    [OnlineConfigUtil update];
    
    
    
    
    if ([AppManager hasFirstSetDone]) {
        
        [[ScheduleManager getInstance] resetDate];
        
        [NotifyManager resetRemindNotify];
        
        [NotifyManager resetActiveNotify];
    }
    
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


+ (BOOL)shouldShowRedPoint {
    BOOL should = NO;
    
    
    if ([AppManager hasFirstSetDone]) {
        // 没有通知权限
        if (![NotifyManager hasAuthority]) {
            should = YES;
        }
        
        if ([HelpView RepeatNotifyHelpShouldShowed]) {
            should = YES;
        }
    }
    
    
    return should;
}


@end
