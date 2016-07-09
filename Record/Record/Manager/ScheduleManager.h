//
//  ScheduleManager.h
//  Record
//
//  Created by Jehy Fan on 16/3/10.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>



// 日期阶段
typedef NS_ENUM(NSInteger, DateStage) {
    // 开始日期之前
    DateStageUnstarted = 0,
    
    // 开始服用
    DateStageStarted = 1,
    
    // 未来
    DateStageFuture = 2
};



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

- (void)resetDate;

- (NSString *)todayInfo;

- (NSDate *)dateInPack:(NSInteger)pack day:(NSInteger)day;

- (BOOL)isBreakDay:(NSDateComponents *)day;

#pragma mark - Config

+ (void)setEveryday:(BOOL)everyday;
+ (BOOL)isEveryday;

+ (void)setTakePlaceboPills:(BOOL)take;
+ (BOOL)takePlaceboPills;

+ (void)setPillDays:(NSInteger)pilldays
          breakDays:(NSInteger)breakDays
          startDate:(NSDate *)date;

+ (NSInteger)pillDays;
+ (NSInteger)breakDays;
+ (NSDate *)startDate;

+ (NSInteger)allDays;


@end
