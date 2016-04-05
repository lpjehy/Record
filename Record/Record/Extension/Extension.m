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
        case 1:
            text = NSLocalizedString(@"weekday_mon", nil);
            break;
        case 2:
            text = NSLocalizedString(@"weekday_tue", nil);
            break;
        case 3:
            text = NSLocalizedString(@"weekday_wed", nil);
            break;
        case 4:
            text = NSLocalizedString(@"weekday_thr", nil);
            break;
        case 5:
            text = NSLocalizedString(@"weekday_fri", nil);
            break;
        case 6:
            text = NSLocalizedString(@"weekday_sat", nil);
            break;
        case 7:
            text = NSLocalizedString(@"weekday_sun", nil);
            break;
            
            
        default:
            break;
    }
    
    return text;
}

@end
