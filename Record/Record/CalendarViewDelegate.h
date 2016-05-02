//
//  CalendarViewDelegate.h
//  Record
//
//  Created by Jehy Fan on 16/3/12.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>





static NSString *MonthHeader = @"MonthHeaderView";

static NSString *DayCell = @"DayCell";


@interface CalendarViewDelegate : NSObject<UIScrollViewDelegate>

+ (CalendarViewDelegate *)getInstance;

@property(nonatomic, strong) UIScrollView *thisScrollView;
@property(nonatomic, assign) NSInteger currentMonth;


- (void)reloadData;

- (void)scrollToToday;

- (void)resetView;
- (void)reloadView;

- (CGFloat)contentOffsetYForMonth:(NSInteger)month;
@end
