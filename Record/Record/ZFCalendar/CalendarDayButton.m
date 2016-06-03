//
//  CalendarDayCell.m
//  tttttt
//
//  Created by 张凡 on 14-8-20.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarDayButton.h"

#import "RecordData.h"
#import "ScheduleManager.h"

@interface CalendarDayButton () {
    UILabel *titleLabel;
    UIImageView *markImageView;
    
    UIImageView *frameImageView;
}

@end

@implementation CalendarDayButton

@synthesize stage, isToday, isBreakDay, isTaken, isSelected;
@synthesize day;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        
        
        
        [NotificationCenter addObserver:self selector:@selector(pillStateChanged:) name:PillStateChangedNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    
    
    
    [NotificationCenter removeObserver:self];
}

- (void)initView {
    
    frameImageView = [[UIImageView alloc] init];
    frameImageView.frame = CGRectMake(0, 0, self.width, self.height);
    
    [self addSubview:frameImageView];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, self.width, self.height);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = FontSmall;
    [self addSubview:titleLabel];
    
    markImageView = [[UIImageView alloc] init];
    markImageView.frame = CGRectMake(self.width - 15, 2, 12, 12);
    [self addSubview:markImageView];
    
    

}


- (void)pillStateChanged:(NSNotification *)notification {
    NSString *dayStr = [notification.userInfo validObjectForKey:@"time"];
    if ([dayStr isEqualToString:day.theDay]) {
        
        NSString *record = [RecordData selectRecord:day.theDate];
        if (record) {
            self.isTaken = YES;
        } else {
            self.isTaken = NO;
        }
        
        [self resetState];
        
    }
}

- (void)resetState {
    
    if (isSelected) {
        frameImageView.image = [UIImage imageNamed:@"Calendar_Frame_FocusDay.png"];
    } else if (isToday) {
        frameImageView.image = [UIImage imageNamed:@"Calendar_Frame_Today.png"];
    } else {
        frameImageView.image = nil;
    }
    
    
    if (DateStageUnstarted == stage) {
        // 未开始
        markImageView.image = nil;
        
        
    } else if (DateStageFuture == stage) {
        // 未来
        if (isBreakDay) {
            if ([ScheduleManager isEveryday] || [ScheduleManager takePlaceboPills]) {
                markImageView.image = [UIImage imageNamed:@"Calendar_Placebo_future.png"];
            } else {
                markImageView.image = nil;
            }
            
        } else {
            markImageView.image = [UIImage imageNamed:@"Calendar_Pill_future.png"];
        }
        
    } else {
        // 当前
        if (isTaken) {
            if (isBreakDay) {
                if ([ScheduleManager takePlaceboPills]) {
                    markImageView.image = [UIImage imageNamed:@"Calendar_Placebo_taken.png"];
                } else {
                    markImageView.image = nil;
                }
                
            } else {
                markImageView.image = [UIImage imageNamed:@"Calendar_Pill_taken.png"];
            }
        } else {
            if (isBreakDay && ![ScheduleManager isEveryday] && ![ScheduleManager takePlaceboPills]) {
                
                markImageView.image = nil;
                
            } else {
                markImageView.image = [UIImage imageNamed:@"Calendar_Pill_future.png"];
            }
        }
        
    }
    
    
    
}

- (void)setDay:(NSDateComponents *)d {
    day = d;
    
    NSString *text = [NSString stringWithInteger:day.day];
    if (text.intValue != 0) {
        titleLabel.text = text;
        
        
        NSString *recordText = [RecordData selectRecord:day.theDate];
        if (recordText) {
            self.isTaken = YES;
        } else {
            self.isTaken = NO;
        }
        
        NSDateComponents *startDay = [ScheduleManager getInstance].startDay;
        if ([day isEarlier:startDay]) {
            // 过去
            stage = DateStageUnstarted;
            
        } else {
            
            NSDateComponents *today = [ScheduleManager getInstance].today;
            if (![day isEarlier:today]) {
                // 未来
                stage = DateStageFuture;
                
            } else {
                // 当下
                stage = DateStageStarted;
                
                if (day.year == today.year && day.month == today.month && day.day == today.day) {
                    self.isToday = YES;
                } else {
                    self.isToday = NO;
                }
            }
            
            if (![ScheduleManager isEveryday]) {
                self.isBreakDay = [[ScheduleManager getInstance] isBreakDay:day];
            }
        }
        
    } else {
        titleLabel.text = nil;
        
        markImageView.image = nil;
        frameImageView.image = nil;
    }
    
   
}





- (void)setIsSelected:(BOOL)selected {
    isSelected = selected;
    [self resetState];
}


@end
