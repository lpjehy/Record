//
//  CalendarViewDelegate.m
//  Record
//
//  Created by Jehy Fan on 16/3/12.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "CalendarViewDelegate.h"


#import "CalendarMonthCollectionViewLayout.h"
#import "CalendarMonthHeaderView.h"
#import "CalendarDayCell.h"
//MODEL
#import "CalendarDayModel.h"

#import "ScheduleManager.h"
#import "RecordManager.h"

#import "CalendarMenuView.h"

@interface CalendarViewDelegate ()  {
    NSMutableDictionary *numberOfItemsInSection;
    NSMutableDictionary *monthInSection;
    NSMutableDictionary *daysInSection;
    NSMutableDictionary *firstDaysForSection;
    
    
    CalendarDayCell *seletedCell;
    
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

@synthesize today, selectedDay, startDay, currentSection;
@synthesize thisCollectionView;


- (id)init {
    self = [super init];
    if (self) {
        numberOfItemsInSection = [[NSMutableDictionary alloc] init];
        monthInSection = [[NSMutableDictionary alloc] init];
        daysInSection = [[NSMutableDictionary alloc] init];
        firstDaysForSection = [[NSMutableDictionary alloc] init];
        
        self.startDay = [ScheduleManager startDate].components;
        self.today = NSDate.components;
        self.currentSection = (today.year - startDay.year) * 12 + today.month - startDay.month;
    }
    
    return self;
}

- (void)reloadData {
    self.startDay = [ScheduleManager startDate].components;
    self.today = NSDate.components;
    self.currentSection = (today.year - startDay.year) * 12 + today.month - startDay.month;
    
    
    
    thisCollectionView.height = [self heightOfView];
    
    [thisCollectionView reloadData];
    [thisCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0
                                                                        inSection:currentSection]
                                   atScrollPosition:UICollectionViewScrollPositionNone
                                           animated:NO];
}

- (CGFloat)heightOfView {
    NSInteger numOfCell = [self collectionView:thisCollectionView numberOfItemsInSection:currentSection];
    return numOfCell / 7 * (ScreenWidth / 7);
}


- (NSDateComponents *)firstDayForSection:(NSInteger)section {

    NSString *key = [NSString stringWithInteger:section];
    NSDateComponents *firstDay = [firstDaysForSection validObjectForKey:key];
    if (firstDay == nil) {
        NSInteger month = startDay.month + section;
        NSInteger year = startDay.year;
        if (month <= 0) {
            month += 12;
            year--;
        } else if (month > 12) {
            month-= 12;
            year++;
        }
        
        firstDay = [NSDateComponents componentsWithYear:year month:month day:1];
        [firstDaysForSection setValue:firstDay forKey:key];
    }
   
    return firstDay;
}

- (NSArray *)daysInSection:(NSInteger)section {
   
    NSString *key = [NSString stringWithInteger:section];
    NSMutableArray *dayArray = [daysInSection validObjectForKey:key];
    if (dayArray == nil) {
        dayArray = [NSMutableArray array];
        
        NSDateComponents *firstDay = [self firstDayForSection:section];
        [dayArray addObject:firstDay];
        NSInteger num = [NSDateComponents numberOfDaysInMonth:firstDay.month year:firstDay.year];
        for (int i = 2; i <= num; i++) {
            NSDateComponents *day = [NSDateComponents componentsWithYear:firstDay.year month:firstDay.month day:i];
            [dayArray addObject:day];
        }
        
        
        [daysInSection setValue:dayArray forKey:key];
    }
    
    return dayArray;
}

#pragma mark - CollectionView代理方法

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return currentSection + 3;
}


//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSString *key = [NSString stringWithInteger:section];
    NSNumber *number = [numberOfItemsInSection validObjectForKey:key];
    if (number == nil) {
        NSInteger month = startDay.month + section;
        NSInteger year = startDay.year;
        if (month <= 0) {
            month += 12;
            year--;
        } else if (month > 12) {
            month-= 12;
            year++;
        }
        
        
        NSInteger days = [NSDateComponents numberOfDaysInMonth:month year:year];
        
        NSDateComponents *firstDay = [NSDateComponents componentsWithYear:year month:month day:1];
        
        if (firstDay.weekday != 7) {
            days += firstDay.weekday;
        }
        
        NSInteger q = days / 7;
        NSInteger r = days % 7;
        if (r != 0) {
            q++;
        }
        
        days = q * 7;
        
        number = [NSNumber numberWithInteger:days];
        [numberOfItemsInSection setValue:number forKey:key];
    }
   
    return number.integerValue;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
    
    NSArray *dayArray = [self daysInSection:indexPath.section];
    NSDateComponents *firstDay = dayArray.firstObject;
    NSDateComponents *components = [dayArray validObjectAtIndex:indexPath.row - firstDay.weekday + 1];
    cell.day = components;
    
    if (components) {
        BOOL isSelected = components.year == selectedDay.year && components.month == selectedDay.month && components.day == selectedDay.day;
        cell.isSelected = isSelected;
        
        
        seletedCell = cell;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        //NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        //CalendarDayModel *model = [month_Array objectAtIndex:15];
        
        UICollectionReusableView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        reusableview = monthHeader;
    }
    return reusableview;
    
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDayCell *cell = (CalendarDayCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.day == nil) {
        return;
    }
    if (cell.isFuture) {
        [UIAlertView showMessage:@"No hurry to take this pill, it's not the day yet!"];
        return;
    }
    self.selectedDay = cell.day;
    
    
    
    seletedCell.isSelected = NO;
    seletedCell = cell;
    
    cell.isSelected = YES;
    
    
    if (!cell.isPlacebo || [ScheduleManager takePlaceboPills] || [ScheduleManager isEveryday]) {
        [[CalendarMenuView getInstance] showInView:cell];
    }
    
    
    
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger section = (NSInteger)scrollView.contentOffset.y / (NSInteger)scrollView.height;
    //NSLog(@"y: %f", scrollView.contentOffset.y);
    if (section != currentSection) {
        currentSection = section;
        
        //[self reloadData];
        
        thisCollectionView.height = [self heightOfView];
        
        //NSLog(@"currentSection: %zi height: %f", currentSection, thisCollectionView.height);
    }

}

@end
