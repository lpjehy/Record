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
    NSInteger weekday = self.weekday;
    NSString *text = nil;
    switch (weekday) {
        case 1:
            text = @"MON";
            break;
        case 2:
            text = @"TUR";
            break;
        case 3:
            text = @"WED";
            break;
        case 4:
            text = @"THU";
            break;
        case 5:
            text = @"FRI";
            break;
        case 6:
            text = @"SAT";
            break;
        case 7:
            text = @"SUN";
            break;
            
            
        default:
            break;
    }
    
    return text;
}


@end
