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

#import "RecordManager.h"
#import "ScheduleManager.h"

@interface CalendarDayButton () {
    UILabel *titleLabel;
    UIImageView *markImageView;
    
    UIImageView *frameImageView;
}

@end

@implementation CalendarDayButton

@synthesize isStarted, isToday, isPlacebo, isTaken, isSelected, isFuture;
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
        
        NSString *record = [RecordManager selectRecord:day.theDate];
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
    
    if (!isStarted) {
        markImageView.image = nil;
        return;
    }
    
    if (isFuture) {
        if (isPlacebo) {
            if ([ScheduleManager isEveryday] || [ScheduleManager takePlaceboPills]) {
                markImageView.image = [UIImage imageNamed:@"Calendar_Placebo_future.png"];
            } else {
                markImageView.image = nil;
            }
            
        } else {
            markImageView.image = [UIImage imageNamed:@"Calendar_Pill_future.png"];
        }
    } else {
        
        if (isTaken) {
            if (isPlacebo) {
                if ([ScheduleManager takePlaceboPills]) {
                    markImageView.image = [UIImage imageNamed:@"Calendar_Placebo_taken.png"];
                } else {
                    markImageView.image = nil;
                }
                
            } else {
                markImageView.image = [UIImage imageNamed:@"Calendar_Pill_taken.png"];
            }
        } else {
            if (isPlacebo && ![ScheduleManager isEveryday] && ![ScheduleManager takePlaceboPills]) {
                
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
        
        
        
        NSString *recordText = [RecordManager selectRecord:day.theDate];
        
        if (recordText) {
            self.isTaken = YES;
        } else {
            self.isTaken = NO;
        }
        
        NSDateComponents *startDay = [ScheduleManager getInstance].startDay;
        if ([day isEarlier:startDay]) {
            isStarted = NO;
            return;
        }
        
        isStarted = YES;
        
        NSDateComponents *today = [ScheduleManager getInstance].today;
        if (day.year == today.year && day.month == today.month && day.day == today.day) {
            self.isToday = YES;
        } else {
            self.isToday = NO;
        }
        
        self.isFuture = ![day isEarlier:today];
        
        
        
        if (![ScheduleManager isEveryday]) {
            self.isPlacebo = [[ScheduleManager getInstance] isPlaceboDay:day];
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
