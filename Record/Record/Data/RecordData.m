//
//  RecordManager.m
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "RecordData.h"


#import "SqlUtil.h"


static NSString *SQL_CREATE_TABLE = @"CREATE TABLE IF NOT EXISTS RECORD (ID INTEGER PRIMARY KEY AUTOINCREMENT, createtime DATETIME, pilltype INTEGER)";

static NSString *SQL_INSERT_RECORD = @"INSERT INTO RECORD ('createtime') VALUES ('%@')";
static NSString *SQL_DELETE_RECORD = @"DELETE FROM RECORD WHERE createtime >= '%@' and createtime < '%@'";
static NSString *SQL_SELECT_RECORD = @"SELECT * FROM RECORD WHERE createtime >= '%@' and createtime < '%@'";

static NSCache *recordCache = nil;

@implementation RecordData


+ (void)record:(NSDate *)date {
    [self createTable];
    
    NSString *record = [RecordData selectRecord:date];
    if (record == nil) {
        NSString *time = [[date stringWithFormat:@"yyyy-MM-dd "] stringByAppendingString:[[NSDate date] stringWithFormat:@"HH:mm:ss"]];
        if (time) {
            BOOL result = [[SqlUtil getInstance] execSql:[NSString stringWithFormat:SQL_INSERT_RECORD, time]];
            if (result) {
                NSString *key = [time componentsSeparatedByString:@" "].firstObject;
                [recordCache setObject:time forKey:key];
                
                
                if (key) {
                    [NotificationCenter postNotificationName:PillStateChangedNotification object:nil userInfo:@{@"time": key, @"type":@"insert"}];
                }
                
                
                NSLog(@"记录 %@", time);
            }
        }
    } else {
        NSLog(@"已记录 %@", date.string);
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
        title = LocalizedString(@"button_title_untake", nil);
        
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
    }
    
    NSString *key = [date stringWithFormat:@"yyyy-MM-dd"];
    NSString *record = [recordCache validObjectForKey:key];
    if (record == nil) {
        
        NSString *starttime = [key stringByAppendingString:@" 00:00:00"];
        NSString *endtime = [[date dateByAddingTimeInterval:TimeIntervalDay] stringWithFormat:@"yyyy-MM-dd 00:00:00"];
        
        
        NSArray *resultArray = [[SqlUtil getInstance] selectWithSql:[NSString stringWithFormat:SQL_SELECT_RECORD, starttime, endtime]];
        for (NSDictionary *result in resultArray) {
            record = [result validObjectForKey:@"createtime"];
            if (record) {
                [recordCache setObject:record forKey:key];
                
                break;
            }
        }
    }
    
    if (record) {
        //NSLog(@"selectRecord %@ %@", key, record);
    }
    
    
    return record;
}

+ (void)createTable {
    [[SqlUtil getInstance] execSql:SQL_CREATE_TABLE];
}

+ (void)deleteRecord:(NSDate *)date {
    [self createTable];
    
    NSString *theday = [date stringWithFormat:@"yyyy-MM-dd"];
    NSString *starttime = [theday stringByAppendingString:@" 00:00:00"];
    NSString *endtime = [[NSDate dateWithTimeInterval:TimeIntervalDay sinceDate:date] stringWithFormat:@"yyyy-MM-dd 00:00:00"];
    
    [recordCache removeObjectForKey:theday];
    
    
    [[SqlUtil getInstance] execSql:[NSString stringWithFormat:SQL_DELETE_RECORD, starttime, endtime]];
    
    if (theday) {
        [NotificationCenter postNotificationName:PillStateChangedNotification object:nil userInfo:@{@"time": theday, @"type":@"delete"}];
    }
    
    
    
    /*
    if (DeviceSystemVersion > 9.0 && date.components.isToday) {
        NSString *type = nil;
        NSString *title = nil;
        type = @"takepill";
        title = LocalizedString(@"button_title_take", nil);
        
        UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:type localizedTitle:title];
        // 将标签添加进Application的shortcutItems中。
        [UIApplication sharedApplication].shortcutItems = @[item];
    }
     */
}

@end
