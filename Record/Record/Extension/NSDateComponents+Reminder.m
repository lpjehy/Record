//
//  NSArrayExtension.m
//  ticket
//
//  Created by 饺子 on 13-7-18.
//  Copyright (c) 2013年 Mibang.Inc. All rights reserved.
//

#import "NSDateComponents+Reminder.h"


@implementation NSDateComponents(Reminder)


- (NSString *)weekDayText {
    
    
    return [[self class] textForWeekday:self.weekday];
}

+ (NSString *)textForWeekday:(NSInteger)weekday {
    NSString *text = nil;
    switch (weekday) {
        case 2:
            text = LocalizedString(@"weekday_mon");
            break;
        case 3:
            text = LocalizedString(@"weekday_tue");
            break;
        case 4:
            text = LocalizedString(@"weekday_wed");
            break;
        case 5:
            text = LocalizedString(@"weekday_thr");
            break;
        case 6:
            text = LocalizedString(@"weekday_fri");
            break;
        case 7:
            text = LocalizedString(@"weekday_sat");
            break;
        case 1:
            text = LocalizedString(@"weekday_sun");
            break;
            
            
        default:
            break;
    }
    
    return text;
}

+ (NSString *)descriptionOfMonth:(NSInteger)month
{
    switch (month) {
        case 1:
            return LocalizedString(@"month_january");
            break;
            
        case 2:
            return LocalizedString(@"month_february");
            break;
            
        case 3:
            return LocalizedString(@"month_march");
            break;
            
        case 4:
            return LocalizedString(@"month_april");
            break;
            
        case 5:
            return LocalizedString(@"month_may");
            break;
            
        case 6:
            return LocalizedString(@"month_june");
            break;
            
        case 7:
            return LocalizedString(@"month_july");
            break;
            
        case 8:
            return LocalizedString(@"month_august");
            break;
            
        case 9:
            return LocalizedString(@"month_september");
            break;
            
        case 10:
            return LocalizedString(@"month_october");
            break;
            
        case 11:
            return LocalizedString(@"month_november");
            break;
            
        case 12:
            return LocalizedString(@"month_december");
            break;
            
        default:
            return nil;
            break;
    }
}

@end
