//
//  CalendarViewDelegate.h
//  Record
//
//  Created by Jehy Fan on 16/3/12.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarLogic.h"


static NSString *MonthHeader = @"MonthHeaderView";

static NSString *DayCell = @"DayCell";

typedef void (^CalendarBlock)(CalendarDayModel *model);

@interface CalendarViewDelegate : NSObject<UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

+ (CalendarViewDelegate *)getInstance;


@property(nonatomic ,strong) NSMutableArray *calendarMonth;//每个月份的中的daymodel容器数组

@property(nonatomic ,strong) CalendarLogic *Logic;

@property (nonatomic, copy) CalendarBlock calendarblock;//回调
@end
