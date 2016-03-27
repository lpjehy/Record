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


@interface CalendarViewDelegate : NSObject<UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

+ (CalendarViewDelegate *)getInstance;

@property(nonatomic, strong) UICollectionView *thisCollectionView;
@property(nonatomic, assign) NSInteger currentSection;


@end
