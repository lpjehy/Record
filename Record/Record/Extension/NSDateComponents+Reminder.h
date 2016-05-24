//
//  NSArrayExtension.h
//  ticket
//
//  Created by 饺子 on 13-7-18.
//  Copyright (c) 2013年 Mibang.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface NSDateComponents(Reminder)


- (NSString *)weekDayText;
+ (NSString *)textForWeekday:(NSInteger)weekday;

+ (NSString *)descriptionOfMonth:(NSInteger)month;

@end