//
//  ScheduleManager.h
//  Record
//
//  Created by Jehy Fan on 16/3/10.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleManager : NSObject

+ (void)setIsEveryday:(BOOL)everyday;
+ (BOOL)isEveryday;

+ (void)setPillDays:(NSInteger)days;
+ (NSInteger)pillDays;

+ (void)setSafeDays:(NSInteger)days;
+ (NSInteger)safeDays;

+ (void)setStartDate:(NSTimeInterval)date;
+ (NSDate *)startDate;

+ (NSInteger)allDays;

@end
