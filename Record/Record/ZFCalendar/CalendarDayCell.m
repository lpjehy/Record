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

#import "CalendarDayCell.h"

#import "RecordManager.h"
#import "ScheduleManager.h"

@interface CalendarDayCell () {
    UILabel *titleLabel;
    UIImageView *markImageView;
    
    UIImageView *frameImageView;
}

@end

@implementation CalendarDayCell

@synthesize isToday, isPlacebo, isTaken, isSelected, isFuture;
@synthesize day;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    frameImageView = [[UIImageView alloc] init];
    frameImageView.frame = CGRectMake(0, 0, self.width, self.height);
    
    [self.contentView addSubview:frameImageView];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, self.width, self.height);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = FontSmall;
    [self.contentView addSubview:titleLabel];
    
    markImageView = [[UIImageView alloc] init];
    markImageView.frame = CGRectMake(self.width - 12, 2, 10, 10);
    [self.contentView addSubview:markImageView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = ColorGrayDark;
    lineView.frame = CGRectMake(0, ScreenWidth / 7 - 0.5, ScreenWidth / 7, 0.5);
    [self.contentView addSubview:lineView];
    
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = ColorGrayDark;
    lineView.frame = CGRectMake(ScreenWidth / 7 - 0.5, 0, 0.5, ScreenWidth / 7);
    [self.contentView addSubview:lineView];

}

- (void)resetState {
    
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
                if ([ScheduleManager isEveryday] || [ScheduleManager takePlaceboPills]) {
                    markImageView.image = [UIImage imageNamed:@"Calendar_Placebo_taken.png"];
                } else {
                    markImageView.image = nil;
                }
                
            } else {
                markImageView.image = [UIImage imageNamed:@"Calendar_Pill_taken.png"];
            }
        } else {
            if (isPlacebo) {
                if ([ScheduleManager isEveryday] || [ScheduleManager takePlaceboPills]) {
                    markImageView.image = [UIImage imageNamed:@"Calendar_Pill_miss.png"];
                } else {
                    markImageView.image = nil;
                }
                
            } else {
                markImageView.image = [UIImage imageNamed:@"Calendar_Pill_miss.png"];
            }
        }
        
    }
    
    if (isSelected) {
        frameImageView.image = [UIImage imageNamed:@"Calendar_Frame_FocusDay.png"];
    } else if (isToday) {
        frameImageView.image = [UIImage imageNamed:@"Calendar_Frame_Today.png"];
    } else {
        frameImageView.image = nil;
    }
    
}

- (void)setDay:(NSDateComponents *)d {
    day = d;
    
    NSString *text = [NSString stringWithInteger:day.day];
    if (text.intValue != 0) {
        titleLabel.text = text;
        
        NSDateComponents *today = NSDate.components;
        
        if (day.year == today.year && day.month == today.month && day.day == today.day) {
            self.isToday = YES;
        } else {
            self.isToday = NO;
        }
        
        self.isFuture = ![day isEarlier:today];
        
        NSString *recordText = [RecordManager selectRecord:day.theDate];
        //NSLog(@"recordText: %@", recordText);
        if (recordText) {
            self.isTaken = YES;
        } else {
            self.isTaken = NO;
        }
        
        self.isPlacebo = [[ScheduleManager getInstance] isPlaceboDay:day];
        
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
