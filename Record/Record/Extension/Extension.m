//
//  NSArrayExtension.m
//  ticket
//
//  Created by 饺子 on 13-7-18.
//  Copyright (c) 2013年 Mibang.Inc. All rights reserved.
//

#import "NSExtension.h"

@implementation NSString (eCook)





@end

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

@end
