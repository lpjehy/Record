//
//  CalendarViewDelegate.m
//  Record
//
//  Created by Jehy Fan on 16/3/12.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "CalendarViewDelegate.h"


#import "CalendarDayButton.h"


#import "ScheduleManager.h"
#import "RecordManager.h"

#import "CalendarMenuView.h"

static CGFloat MaxHeight = 1024000;

@interface CalendarViewDelegate ()  {
    
    NSMutableDictionary *dayButtonsInSection;
    NSMutableDictionary *contentOffsetYForMonth;
    
    CalendarDayButton *seletedButton;
    
    NSMutableDictionary *dayViewsDic;
    
    
    CGFloat baseContentOffsetY;
}

@property(nonatomic, retain) NSDateComponents *startDay;
@property(nonatomic, retain) NSDateComponents *today;
@property(nonatomic, retain) NSDateComponents *selectedDay;


@end

@implementation CalendarViewDelegate
+ (CalendarViewDelegate *)getInstance {
    static CalendarViewDelegate *instance = nil;
    if (instance == nil) {
        instance = [[CalendarViewDelegate alloc] init];
    }
    
    return instance;
}

@synthesize today, selectedDay, startDay, currentMonth;
@synthesize thisScrollView;


- (id)init {
    self = [super init];
    if (self) {
        
        
        contentOffsetYForMonth = [[NSMutableDictionary alloc] init];
        
        dayViewsDic = [[NSMutableDictionary alloc] init];
        
        self.startDay = [ScheduleManager startDate].components;
        self.today = NSDate.components;
        self.currentMonth = 0;
        
        baseContentOffsetY = MaxHeight / 2;
        
        
    }
    
    return self;
}

- (void)scrollToToday {
    [thisScrollView setContentOffset:CGPointMake(0, baseContentOffsetY) animated:YES];
}

- (void)reloadData {
    self.startDay = [ScheduleManager startDate].components;
    self.today = NSDate.components;
    
    
    thisScrollView.contentSize = CGSizeMake(ScreenWidth, MaxHeight);
    thisScrollView.contentOffset = CGPointMake(0, baseContentOffsetY);
    
    if (dayViewsDic.count == 0) {
        [self reloadView];
    }
    
    for (CalendarDayButton *button in thisScrollView.subviews) {
        if ([button isKindOfClass:[CalendarDayButton class]]) {
            button.day = button.day;
            [button resetState];
        }
    }
    
    
}

- (void)reloadView {
    //NSLog(@"reloadView 1");
    CGFloat size = ScreenWidth / 7;
    
    CGFloat startY = [self contentOffsetYForMonth:currentMonth] - [self heightForMonth:currentMonth - 1] - [self heightForMonth:currentMonth - 2];
    
    for (NSInteger i = currentMonth - 2; i <= currentMonth + 2; i++) {
        
        NSString *key = [NSString stringWithInteger:i];
        NSMutableArray *dayViewArray = [dayViewsDic validObjectForKey:key];
        if (dayViewArray == nil) {
            dayViewArray = [NSMutableArray array];
            [dayViewsDic setValue:dayViewArray forKey:key];
        }
        
        NSArray *dayArray = [self daysInMonth:i];
        
        NSDateComponents *firstDay = dayArray.firstObject;
        
        
        
        
        for (int dayIndex = 0; dayIndex < dayArray.count; dayIndex++) {
            CalendarDayButton *button = [dayViewArray validObjectAtIndex:dayIndex];
            if (button == nil) {
                NSInteger position = dayIndex + firstDay.weekday - 1;
                NSInteger q = position / 7;
                NSInteger r = position % 7;
                button = [[CalendarDayButton alloc] initWithFrame:CGRectMake(r * size, startY + q * size, size, size)];
                [button addTarget:self action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                [thisScrollView addSubview:button];
                
                [dayViewArray addObject:button];
                
                NSDateComponents *components = [dayArray validObjectAtIndex:dayIndex];
                button.day = components;
                if (components) {
                    BOOL isSelected = components.year == selectedDay.year && components.month == selectedDay.month && components.day == selectedDay.day;
                    button.isSelected = isSelected;
                    
                    if (isSelected) {
                        seletedButton = button;
                    }
                    
                }
                
                if (r == 0) {
                    UIView *lineView = [[UIView alloc] init];
                    lineView.backgroundColor = ColorGrayDark;
                    lineView.frame = CGRectMake(0, startY + size * q, ScreenWidth, 0.5);
                    [thisScrollView addSubview:lineView];
                } else if (dayIndex == dayArray.count - 1 && r != 6) {
                    UIView *lineView = [[UIView alloc] init];
                    lineView.backgroundColor = ColorGrayDark;
                    lineView.frame = CGRectMake(0, startY + size * (q + 1), ScreenWidth, 1);
                    [thisScrollView addSubview:lineView];
                } else if (dayIndex == 0 && r != 0) {
                    UIView *lineView = [[UIView alloc] init];
                    lineView.backgroundColor = ColorGrayDark;
                    lineView.frame = CGRectMake(0, startY + size * q, ScreenWidth, 1);
                    [thisScrollView addSubview:lineView];
                }
            }
            
            
        }
        
        if (i == currentMonth) {
            NSLog(@"year %zi month %zi day %zi weekday %zi num %zi", firstDay.year, firstDay.month, firstDay.day, firstDay.weekday, dayArray.count);
        }
        
        startY += [self heightForMonth:i];
    }
    
    //NSLog(@"reloadView 2");
}

- (CGFloat)contentOffsetYForMonth:(NSInteger)month {
    
    //NSLog(@"contentOffsetYForMonth 1");
    
    NSString *key = [NSString stringWithInteger:month];
    NSNumber *yNumber = [contentOffsetYForMonth validObjectForKey:key];
    if (yNumber == nil) {
        CGFloat contentOffsetY = 0;
        if (month < 0) {
            contentOffsetY = [self contentOffsetYForMonth:month + 1] - [self heightForMonth:month];
        } else if (month > 0) {
            contentOffsetY = [self contentOffsetYForMonth:month - 1] + [self heightForMonth:month - 1];
        } else {
            contentOffsetY = baseContentOffsetY;
        }
        
        
        yNumber = [NSNumber numberWithFloat:contentOffsetY];
        
        [contentOffsetYForMonth setValue:yNumber forKey:key];
    }
    //NSLog(@"contentOffsetYForMonth 2");
    return yNumber.floatValue;
}

- (NSArray *)daysInMonth:(NSInteger)monthIndex {
    
    //NSLog(@"daysInMonth 1");
    
    static NSMutableDictionary *daysForMonthDic = nil;
    if (daysForMonthDic == nil) {
        daysForMonthDic = [[NSMutableDictionary alloc] init];
    }
    
    NSString *key = [NSString stringWithInteger:monthIndex];
    NSMutableArray *dayArray = [daysForMonthDic validObjectForKey:key];
    if (dayArray == nil) {
        dayArray = [NSMutableArray array];
        
        NSDateComponents *firstDay = [self firstDayForMonth:monthIndex];
        if (firstDay) {
            [dayArray addObject:firstDay];
            
            NSInteger num = [NSDateComponents numberOfDaysInMonth:firstDay.month year:firstDay.year];
            for (int i = 2; i <= num; i++) {
                NSDateComponents *day = [NSDateComponents componentsWithYear:firstDay.year month:firstDay.month day:i];
                if (day) {
                    [dayArray addObject:day];
                } else {
                    //NSLog(@"componentsWithYear %zi month %zi day %zi exception", firstDay.year, firstDay.month, i);
                }
                
            }
            
            
            [daysForMonthDic setValue:dayArray forKey:key];
        }
        
        
    }
    //NSLog(@"daysInMonth 2");
    return dayArray;
}

- (NSDateComponents *)firstDayForMonth:(NSInteger)monthIndex {
    
    
    static NSMutableDictionary *firstDayForMonthDic = nil;
    if (firstDayForMonthDic == nil) {
        firstDayForMonthDic = [[NSMutableDictionary alloc] init];
    }
    
    NSString *monthKey = [NSString stringWithInteger:monthIndex];
    NSDateComponents *firstDay = [firstDayForMonthDic validObjectForKey:monthKey];
    if (firstDay == nil) {
        NSInteger q = monthIndex / 12;
        NSInteger r = monthIndex % 12;
        
        
        NSInteger month = today.month + r;
        NSInteger year = today.year + q;
        if (month <= 0) {
            month += 12;
            year--;
        } else if (month > 12) {
            month-= 12;
            year++;
        }
        
        firstDay = [NSDateComponents componentsWithYear:year month:month day:1];
        if (firstDay == nil) {
            NSLog(@"firstDayForMonth %zi year %zi month %zi day %zi exception", monthIndex, year, month, 1);
        }
        [firstDayForMonthDic setValue:firstDay forKey:monthKey];
    }
    
    return firstDay;
    
}

- (CGFloat)heightForMonth:(NSInteger)month {
    
    static NSMutableDictionary *numberOfItemsInSectionDic = nil;
    if (numberOfItemsInSectionDic == nil) {
        numberOfItemsInSectionDic = [[NSMutableDictionary alloc] init];
    }
    
    NSString *key = [NSString stringWithInteger:month];
    NSNumber *number = [numberOfItemsInSectionDic validObjectForKey:key];
    if (number == nil) {
        
        NSInteger days = [self daysInMonth:month].count;
        
        NSDateComponents *firstDay = [self firstDayForMonth:month];
        
        if (firstDay.weekday != 1) {
            days += firstDay.weekday - 1;
        }
        
        NSLog(@"month: %zi days: %zi weekday: %zi", month, days, firstDay.weekday);
        NSInteger q = days / 7;
        NSInteger r = days % 7;
        if (r != 0) {
            q++;
        }
        
        days = q * 7;
        
        number = [NSNumber numberWithInteger:days];
        
        NSLog(@"number: %zi", number.integerValue);
        
        [numberOfItemsInSectionDic setValue:number forKey:key];
    }
    
    return number.integerValue / 7 * (ScreenWidth / 7);
}

- (void)dayButtonPressed:(CalendarDayButton *)button {
    
    if (button.day == nil) {
        return;
    }
    
    self.selectedDay = button.day;
    
    
    seletedButton.isSelected = NO;
    seletedButton = button;
    
    button.isSelected = YES;
    
    if (button.isFuture) {
        [UIAlertView showMessage:NSLocalizedString(@"alert_message_nohurry", nil)];
        return;
    }
    
    
    if (!button.isPlacebo || [ScheduleManager takePlaceboPills] || [ScheduleManager isEveryday]) {
        [[CalendarMenuView getInstance] showInView:button];
    }
    
    
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat currentOffsetY = [self contentOffsetYForMonth:currentMonth];
    
    CGFloat lastOffsetY = currentOffsetY - [self heightForMonth:currentMonth - 1] / 2;
    CGFloat nextOffsetY = currentOffsetY + [self heightForMonth:currentMonth] / 2;
    
    if (scrollView.contentOffset.y < lastOffsetY) {
        currentMonth--;
        
        [self reloadView];
        
        [NotificationCenter postNotificationName:CalendarMonthChangedNotification object:nil userInfo:@{@"day":[self firstDayForMonth:currentMonth]}];
        
    } else if (scrollView.contentOffset.y > nextOffsetY) {
        currentMonth++;
        
        [self reloadView];
        
        [NotificationCenter postNotificationName:CalendarMonthChangedNotification object:nil userInfo:@{@"day":[self firstDayForMonth:currentMonth]}];
    }

}

@end
