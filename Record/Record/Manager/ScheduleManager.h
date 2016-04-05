//
//  ScheduleManager.h
//  Record
//
//  Created by Jehy Fan on 16/3/10.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger MaxPillDays = 48;
static NSInteger MaxBreakDays = 8;

@interface ScheduleManager : NSObject

+ (ScheduleManager *)getInstance;

@property(nonatomic, assign) NSInteger currentPack;
@property(nonatomic, assign) NSInteger currentPackDay;
@property(nonatomic, assign) NSInteger currentDayFromStartDay;
@property(nonatomic, strong) NSDateComponents *today;
@property(nonatomic, strong) NSDateComponents *startDay;

- (NSDate *)dateInPack:(NSInteger)pack day:(NSInteger)day;

- (BOOL)isPlaceboDay:(NSDateComponents *)day;

+ (void)setIsEveryday:(BOOL)everyday;
+ (BOOL)isEveryday;




+ (void)setPillDays:(NSInteger)days;
+ (NSInteger)pillDays;

+ (void)setSafeDays:(NSInteger)days;
+ (NSInteger)breakDays;


+ (void)setTakePlaceboPills:(BOOL)take;
+ (BOOL)takePlaceboPills;

+ (void)setStartDate:(NSDate *)date;
+ (NSDate *)startDate;

+ (NSInteger)allDays;


@end
