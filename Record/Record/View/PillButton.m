//
//  PillButton.m
//  Record
//
//  Created by Jehy Fan on 16/3/15.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "PillButton.h"

#import "ScheduleManager.h"

#import "RecordData.h"


@interface PillButton () {
    UIImageView *backImageView;
    UIImageView *pillImageView;
    UILabel *dayLabel;
    
    BOOL showingToday;
}

@end

@implementation PillButton

@synthesize isBreakDay, isTaken, isToday;
@synthesize day;

- (id)init {
    self = [super init];
    if (self) {
        backImageView = [[UIImageView alloc] init];
        
        backImageView.image = [UIImage imageNamed:@"BG_Pill_Normal.png"];
        
        
        [self addSubview:backImageView];
        
        pillImageView = [[UIImageView alloc] init];
        pillImageView.image = [UIImage imageNamed:@"Pill_Untaken.png"];
        
        [self addSubview:pillImageView];
        
        
        dayLabel = [[UILabel alloc] init];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.font = FontSmall;
        [self addSubview:dayLabel];
        
        [NotificationCenter addObserver:self selector:@selector(pillStateChanged:) name:PillStateChangedNotification object:nil];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (ScreenHeight == ScreenHeight568) {
        backImageView.frame = CGRectMake((self.width - 40) / 2, (self.height - 40) / 2, 40, 40);
        pillImageView.frame = CGRectMake((self.width - 32) / 2, (self.height - 32) / 2, 32, 32);
    } else if (ScreenHeight == ScreenHeight480) {
        backImageView.frame = CGRectMake((self.width - 32) / 2, (self.height - 32) / 2, 32, 32);
        pillImageView.frame = CGRectMake((self.width - 24) / 2, (self.height - 24) / 2, 24, 24);
    } else {
        backImageView.frame = CGRectMake((self.width - 45) / 2, (self.height - 45) / 2, 45, 45);
        pillImageView.frame = CGRectMake((self.width - 35) / 2, (self.height - 35) / 2, 35, 35);
    }
    
    dayLabel.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)dealloc {
    
    
    
    [NotificationCenter removeObserver:self];
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
        
    }
}

- (void)setDay:(NSDateComponents *)d {
    day = d;
    
    if (day) {
        dayLabel.text = [NSString stringWithInteger:day.day];
        
        
        
        NSDateComponents *today = NSDate.components;
        
        
        if (day.year == today.year && day.month == today.month && day.day == today.day) {
            
            self.isToday = YES;
            
            
            NSNumber *num = [NSNumber numberWithFloat:self.superview.originX];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:TodayPackSettedNotification object:nil userInfo:@{@"DestX":num}];
        } else {
            self.isToday = NO;
        }
        
        
        NSString *recordText = nil;
        if ([day isEarlier:today]) {
            recordText = [RecordData selectRecord:day.theDate];
            
        }
        
        
        if (recordText) {
            self.isTaken = YES;
        } else {
            self.isTaken = NO;
        }

    } else {
        dayLabel.text = nil;
        self.isToday = NO;
        self.isTaken = NO;
        self.isBreakDay = NO;
    }
    
    
    
}

- (void)setIsBreakDay:(BOOL)is {
    isBreakDay = is;
}

- (void)setIsToday:(BOOL)is {
    
    backImageView.alpha = 1;
    
    isToday = is;
    if (is) {
        
        
        if (showingToday == NO) {
            
            [self showToday];
        }
        
    } else {
        
    }
}

- (void)showToday {
    
    //若今日已服，则停止闪烁
    if (isTaken && backImageView.alpha == 1) {
        
        showingToday = NO;
        return;
    }
    
    //不是今日，则停止闪烁
    if (!isToday || [UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        
        showingToday = NO;
        return;
    }
    
    
    
    showingToday = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showToday)];
    [UIView setAnimationDuration:.8];
    
    backImageView.alpha = 1 - backImageView.alpha;
    
    [UIView commitAnimations];
}

- (void)resetState {
    
    if (isTaken) {
        
        if (isBreakDay && ![ScheduleManager takePlaceboPills]) {
            dayLabel.textColor = ColorTextPill;
            
            pillImageView.image = nil;
            self.enabled = NO;
            
        } else {
            dayLabel.textColor = [UIColor whiteColor];
            
            NSString *imagename = [NSString stringWithFormat:@"Pill_Taken_%zi.png", arc4random() % 4 + 1];
            pillImageView.image = [UIImage imageNamed:imagename];
            self.enabled = YES;
        }
        
    } else {
        
        dayLabel.textColor = ColorTextPill;
        
        if (isBreakDay) {
            if ([ScheduleManager takePlaceboPills]) {
                pillImageView.image = [UIImage imageNamed:@"Pill_Placebo.png"];
                self.enabled = YES;
            } else {
                pillImageView.image = nil;
                self.enabled = NO;
            }
            
        } else {
            pillImageView.image = [UIImage imageNamed:@"Pill_Untaken.png"];
        }
    }
    
    if (isToday) {
        backImageView.image = [UIImage imageNamed:@"BG_Pill_Today.png"];
        
    } else {
        backImageView.image = [UIImage imageNamed:@"BG_Pill_Normal.png"];
    }
    
}

- (void)setIsTaken:(BOOL)is {
    isTaken = is;
    
    [self resetState];
    
    if (!isTaken && isToday && showingToday == NO) {
        
        [self showToday];
    }
}

@end
