//
//  PillButton.m
//  Record
//
//  Created by Jehy Fan on 16/3/15.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "PillButton.h"

#import "ScheduleManager.h"

#import "RecordManager.h"


@interface PillButton () {
    UIImageView *backImageView;
    UIImageView *pillImageView;
    UILabel *dayLabel;
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
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    
    backImageView.frame = CGRectMake((self.width - 45) / 2, (self.height - 45) / 2, 45, 45);
    pillImageView.frame = CGRectMake((self.width - 35) / 2, (self.height - 35) / 2, 35, 35);
    dayLabel.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)setDay:(NSDateComponents *)d {
    day = d;
    
    dayLabel.text = [NSString stringWithInteger:day.day];
    
    
    
    NSDateComponents *today = NSDate.components;
    
    
    
    
    
    //NSLog(@"components: %zi %zi %zi today:  %zi %zi %zi ", components.year, components.month, components.day, today.year, today.month, today.day);
    if (day.year == today.year && day.month == today.month && day.day == today.day) {
        self.isToday = YES;
    } else {
        self.isToday = NO;
    }
    
    if ([day isEarlier:today]) {
        NSString *recordText = [RecordManager selectRecord:day.theDate];
        //NSLog(@"recordText: %@", recordText);
        if (recordText) {
            self.isTaken = YES;
        } else {
            self.isTaken = NO;
        }
    }
    
    
}

- (void)setIsBreakDay:(BOOL)is {
    isBreakDay = is;
}

- (void)setIsToday:(BOOL)is {
    isToday = is;
    if (is) {
        
        
        if (backImageView.tag == 0) {
            [self showToday];
        }
        
    } else {
        
    }
}

- (void)showToday {
    if (!isToday) {
        backImageView.tag = 0;
        return;
    }
    backImageView.tag = 1;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showToday)];
    [UIView setAnimationDuration:.8];
    backImageView.alpha = 1 - backImageView.alpha;
    
    [UIView commitAnimations];
}

- (void)resetState {
    
    if (isTaken) {
        NSString *imagename = [NSString stringWithFormat:@"Pill_Taken_%zi.png", arc4random() % 4 + 1];
        pillImageView.image = [UIImage imageNamed:imagename];
        
        if (isToday) {
            backImageView.image = [UIImage imageNamed:@"BG_Pill_Today.png"];
            
        } else {
            backImageView.image = [UIImage imageNamed:@"BG_Pill_Normal.png"];
        }
    } else {
        if (isBreakDay && [ScheduleManager takePlaceboPills]) {
            pillImageView.image = [UIImage imageNamed:@"Pill_Placebo.png"];
        } else {
            pillImageView.image = [UIImage imageNamed:@"Pill_Untaken.png"];
        }
    }
    
    if (isToday) {
        backImageView.image = [UIImage imageNamed:@"BG_Pill_Today.png"];
        
    } else if (isTaken || [[ScheduleManager getInstance].today isEarlier:day]) {
        backImageView.image = [UIImage imageNamed:@"BG_Pill_Normal.png"];
    } else {
        backImageView.image = [UIImage imageNamed:@"BG_Pill_Miss.png"];
    }
    
}

- (void)setIsTaken:(BOOL)is {
    isTaken = is;
    
    [self resetState];
}

@end
