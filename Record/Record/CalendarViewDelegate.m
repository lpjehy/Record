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

@interface CalendarViewDelegate ()  {
    
}

@end

@implementation CalendarViewDelegate
+ (CalendarViewDelegate *)getInstance {
    static CalendarViewDelegate *instance = nil;
    if (instance == nil) {
        instance = [[CalendarViewDelegate alloc] init];
        
        
        
        
    }
    
    return instance;
}

@synthesize calendarMonth;


- (id)init {
    self = [super init];
    if (self) {
        NSDate *date = [NSDate date];
        
        NSDate *selectdate  = [NSDate date];
        
        
        self.Logic = [[CalendarLogic alloc]init];
        
        
        self.calendarMonth = [[NSMutableArray alloc] init];
        self.calendarMonth = [self.Logic reloadCalendarView:date selectDate:selectdate  needDays:365];
    }
    
    return self;
}

#pragma mark - CollectionView代理方法

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.calendarMonth.count;
}


//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:section];
    
    return monthArray.count;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
    
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
    
    CalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        //NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        //CalendarDayModel *model = [month_Array objectAtIndex:15];
        
        CalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        reusableview = monthHeader;
    }
    return reusableview;
    
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    CalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];
    
    [self.Logic selectLogic:model];
    
    
    
    
    [collectionView reloadData];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if (self.calendarblock) {
        NSInteger currentSection = scrollView.contentOffset.y / scrollView.height;
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:currentSection];
        CalendarDayModel *model = [month_Array objectAtIndex:15];
        
        self.calendarblock(model);//传递数组给上级
        
    }

}

@end
