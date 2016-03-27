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

@synthesize isPlacebo, isTaken, isToday;
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
        
        [self addSubview:dayLabel];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    
    backImageView.frame = CGRectMake(5, 5, self.width - 10, self.height - 10);
    pillImageView.frame = CGRectMake(10, 10, self.width - 20, self.height - 20);
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

- (void)setIsPlacebo:(BOOL)is {
    isPlacebo = is;
    if (is) {
        pillImageView.image = [UIImage imageNamed:@"Pill_Placebo.png"];
    }
}

- (void)setIsToday:(BOOL)is {
    isToday = is;
    if (is) {
        backImageView.image = [UIImage imageNamed:@"BG_Pill_Today.png"];
        
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

- (void)setIsTaken:(BOOL)is {
    isTaken = is;
    if (is) {
        NSString *imagename = [NSString stringWithFormat:@"Pill_Taken_%zi.png", arc4random() % 4 + 1];
        pillImageView.image = [UIImage imageNamed:imagename];
        
        if (!isToday) {
            backImageView.image = [UIImage imageNamed:@"BG_Pill_Normal.png"];
        }
        
    } else {
        
        if (isPlacebo) {
            pillImageView.image = [UIImage imageNamed:@"Pill_Placebo.png"];
        } else {
            pillImageView.image = [UIImage imageNamed:@"Pill_Untaken.png"];
        }
        
        if (isToday) {
            backImageView.image = [UIImage imageNamed:@"BG_Pill_Today.png"];
            
        } else if ([[ScheduleManager getInstance].today isEarlier:day]) {
            backImageView.image = [UIImage imageNamed:@"BG_Pill_Normal.png"];
        } else {
            backImageView.image = [UIImage imageNamed:@"BG_Pill_Miss.png"];
        }
        
        
    }
}

@end
