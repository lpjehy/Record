//
//  ScheduleManager.h
//  Record
//
//  Created by Jehy Fan on 16/3/10.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger MaxPillDays = 98;
static NSInteger MaxBreakDays = 98;

@interface ScheduleManager : NSObject

+ (ScheduleManager *)getInstance;

@property(nonatomic, assign) NSInteger currentPack;
@property(nonatomic, assign) NSInteger currentPackDay;
@property(nonatomic, assign) NSInteger currentDayFromStartDay;
@property(nonatomic, strong) NSDateComponents *today;
@property(nonatomic, strong) NSDateComponents *startDay;





- (void)resetRecordFrom:(NSDate *)startDate toDate:(NSDate *)endDate;

#pragma mark - base info

+ (NSInteger)allDays;

- (NSString *)todayInfo;

- (NSDate *)dateInPack:(NSInteger)pack day:(NSInteger)day;

- (BOOL)isPlaceboDay:(NSDateComponents *)day;

#pragma mark - set

+ (void)setIsEveryday:(BOOL)everyday;
+ (BOOL)isEveryday;


+ (void)setTakePlaceboPills:(BOOL)take;
+ (BOOL)takePlaceboPills;

+ (void)setPillDays:(NSInteger)pilldays
          breakDays:(NSInteger)breakDays
          startDate:(NSDate *)date;

+ (NSInteger)pillDays;
+ (NSInteger)breakDays;
+ (NSDate *)startDate;




@end
