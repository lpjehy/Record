//
//  RecordManager.m
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "RecordManager.h"

#import "SqlUtil.h"


static NSString *SQL_CREATE_TABLE = @"CREATE TABLE IF NOT EXISTS RECORD (ID INTEGER PRIMARY KEY AUTOINCREMENT, createtime DATETIME, pilltype INTEGER)";

static NSString *SQL_INSERT_RECORD = @"INSERT INTO RECORD ('createtime') VALUES (datetime('now', 'localtime'))";
static NSString *SQL_DELETE_RECORD = @"DELETE FROM RECORD WHERE createtime >= '%@' and createtime < '%@'";
static NSString *SQL_SELECT_RECORD = @"SELECT * FROM RECORD";

static NSCache *recordCache = nil;

@implementation RecordManager


+ (void)record:(NSDate *)date {
    [self createTable];
    
    NSString *record = [RecordManager selectRecord:date];
    if (record == nil) {
        BOOL result = [[SqlUtil getInstance] execSql:SQL_INSERT_RECORD];
        if (result) {
            
            NSString *time = [[date stringWithFormat:@"yyyy-MM-dd "] stringByAppendingString:[[NSDate date] stringWithFormat:@"HH:mm:ss"]];
            if (time) {
                NSString *key = [time componentsSeparatedByString:@" "].firstObject;
                [recordCache setObject:time forKey:key];
                
                [NotificationCenter postNotificationName:PillStateChangedNotification object:nil userInfo:@{@"time": key}];
            }
            
            
        }
    } else {
        NSLog(@"已记录");
    }
    
    if ([AppManager isFirstOpeningByReminder]) {
        [AppManager setFirstOpeningByReminder:NO];
        
        [AnalyticsUtil event:Event_First_Take_By_Reminder];
    }
    
    /*
    if (DeviceSystemVersion > 9.0 && date.components.isToday) {
        NSString *type = nil;
        NSString *title = nil;
        type = @"untakepill";
        title = NSLocalizedString(@"button_title_untake", nil);
        
        UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:type localizedTitle:title];
        // 将标签添加进Application的shortcutItems中。
        [UIApplication sharedApplication].shortcutItems = @[item];
    }
     */
    
}

+ (NSString *)selectRecord:(NSDate *)date {
    
    [self createTable];
    
    if (recordCache == nil) {
        recordCache = [[NSCache alloc] init];
        recordCache.totalCostLimit = 10000000;
        
        NSArray *resultArray = [[SqlUtil getInstance] selectWithSql:SQL_SELECT_RECORD];
        for (NSDictionary *result in resultArray) {
            NSString *time = [result validObjectForKey:@"createtime"];
            if (time) {
                NSString *key = [time componentsSeparatedByString:@" "].firstObject;
                [recordCache setObject:time forKey:key];
            }
        }
    }
    
    NSString *key = [date stringWithFormat:@"yyyy-MM-dd"];
    NSString *record = [recordCache validObjectForKey:key];
    
    return record;
}

+ (void)createTable {
    [[SqlUtil getInstance] execSql:SQL_CREATE_TABLE];
}

+ (void)deleteRecord:(NSDate *)date {
    [self createTable];
    
    NSString *today = [date stringWithFormat:@"yyyy-MM-dd"];
    NSString *starttime = [today stringByAppendingString:@" 00:00:00"];
    NSString *endtime = [[[NSDate dateWithTimeInterval:TimeIntervalDay sinceDate:date] stringWithFormat:@"yyyy-MM-dd"] stringByAppendingString:@" 00:00:00"];
    
    [recordCache removeObjectForKey:today];
    
    [NotificationCenter postNotificationName:PillStateChangedNotification object:nil userInfo:@{@"time": today}];
    
    [[SqlUtil getInstance] execSql:[NSString stringWithFormat:SQL_DELETE_RECORD, starttime, endtime]];
    
    /*
    if (DeviceSystemVersion > 9.0 && date.components.isToday) {
        NSString *type = nil;
        NSString *title = nil;
        type = @"takepill";
        title = NSLocalizedString(@"button_title_take", nil);
        
        UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:type localizedTitle:title];
        // 将标签添加进Application的shortcutItems中。
        [UIApplication sharedApplication].shortcutItems = @[item];
    }
     */
}

@end
