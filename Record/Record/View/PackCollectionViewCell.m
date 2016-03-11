//
//  PackCollectionViewCell.m
//  Record
//
//  Created by Jehy Fan on 16/3/4.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "PackCollectionViewCell.h"

#import "NotifyUtil.h"

#import "ScheduleManager.h"
#import "RecordManager.h"
#import "MessageManager.h"

@interface PackCollectionViewCell(){
    UILabel *infoLabel;
    float itemHeight;
}
@end


@implementation PackCollectionViewCell


- (void)pilldayButtonPressed:(UIButton *)button {
    [MessageManager createMessage:button.currentTitle];
}


- (void)createWeekDayLayout {
    NSArray *weekdayArray = @[@"Mon", @"Tue", @"Wed", @"Thr", @"Fri", @"Sat", @"Sun"];
    
    
    
    for (int i = 0; i < weekdayArray.count; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] init];
        weekdayLabel.backgroundColor = ColorGrayDark;
        weekdayLabel.frame = CGRectMake(5, 35 + itemHeight * i, 64, itemHeight);
        weekdayLabel.text = [weekdayArray validObjectAtIndex:i];
        [self.contentView addSubview:weekdayLabel];
    }
}

- (void)createPillDayLayout {
    NSInteger pillDayNum = [ScheduleManager pillDays];
    
    float buttonWith = (ScreenWidth - 100) / 4 + 5;
    
    
    for (int i = 0; i < pillDayNum; i++) {
        
        int r = i % 7;
        int q = i / 7;
        
        UIButton *pilldayButton = [[UIButton alloc] init];
        
        [pilldayButton addTarget:self action:@selector(pilldayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        pilldayButton.backgroundColor = ColorGrayDark;
        pilldayButton.frame = CGRectMake(72 + buttonWith * q, 35 + itemHeight * r, buttonWith, itemHeight);
        [pilldayButton setTitle:[NSString stringWithInt:i + 1] forState:UIControlStateNormal];
        [self.contentView addSubview:pilldayButton];
    }
}

- (void)createSaveDayLayout {
    NSInteger pillDayNum = [ScheduleManager pillDays];
    NSInteger saveDayNum = [ScheduleManager safeDays];
    
    
    
    float buttonWith = (ScreenWidth - 100) / 4 + 5;
    
    
    for (int i = 0; i < saveDayNum; i++) {
        
        
        
        int r = (pillDayNum + i) % 7;
        int q = ((int)pillDayNum + i) / 7;
        
        UIButton *pilldayButton = [[UIButton alloc] init];
        
        [pilldayButton addTarget:self action:@selector(pilldayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        pilldayButton.backgroundColor = [UIColor blueColor];
        pilldayButton.frame = CGRectMake(72 + buttonWith * q, 35 + itemHeight * r, buttonWith, itemHeight);
        [pilldayButton setTitle:[NSString stringWithInt:i + 1] forState:UIControlStateNormal];
        [self.contentView addSubview:pilldayButton];
    }
}

- (void)createLayout {
    infoLabel = [[UILabel alloc] init];
    infoLabel.backgroundColor = [UIColor yellowColor];
    infoLabel.frame = CGRectMake(5, 5, ScreenWidth - 20, infoLabel.font.lineHeight);
    infoLabel.text = @"21 pills left";
    [self.contentView addSubview:infoLabel];
    
    itemHeight = ((ScreenHeight - 148) - 35) / 7;
    
    [self createWeekDayLayout];
    
    [self createPillDayLayout];
    
    [self createSaveDayLayout];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createLayout];
    }
    return self;
}

@end
