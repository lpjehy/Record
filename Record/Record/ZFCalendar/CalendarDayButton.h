//
//  CalendarDayCell.h
//  tttttt
//
//  Created by 张凡 on 14-8-20.
//  Copyright (c) 2014年 张凡. All rights reserved.
//



#import <UIKit/UIKit.h>


#import "ScheduleManager.h"




@interface CalendarDayButton : UIButton
{
    
}


@property(nonatomic, strong) NSDateComponents *day;


@property(nonatomic) BOOL isBreakDay;

@property(nonatomic) BOOL isTaken;

@property(nonatomic) BOOL isSelected;

@property(nonatomic) BOOL isToday;

@property(nonatomic) DateStage stage;

- (void)resetState;
@end
