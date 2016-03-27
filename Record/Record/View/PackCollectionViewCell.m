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

#import "PillButton.h"

@interface PackCollectionViewCell(){
    UILabel *infoLabel;
    UILabel *daysLabel;
    
    NSMutableArray *dateArray;
    
    float itemHeight;
}
@end


@implementation PackCollectionViewCell


- (void)pilldayButtonPressed:(PillButton *)button {
    NSDate *date = button.day.theDate;
    if (!date.isEarlier) {
        [UIAlertView showMessage:@"不要着急哦，还没到那天呢~"];
        return;
    }
    
    NSString *record = [RecordManager selectRecord:date];
    if (record) {
        button.isTaken = NO;
        [RecordManager deleteRecord:date];
    } else {
        [RecordManager record:date];
        button.isTaken = YES;
    }
    
}


- (void)createWeekDayLayout {
    NSArray *weekdayArray = @[@"Mon", @"Tue", @"Wed", @"Thr", @"Fri", @"Sat", @"Sun"];
    
    
    
    for (int i = 0; i < weekdayArray.count; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] init];
        weekdayLabel.textColor = [UIColor whiteColor];
        weekdayLabel.frame = CGRectMake(20, 48 + itemHeight * i, 36, itemHeight);
        weekdayLabel.text = [weekdayArray validObjectAtIndex:i];
        [self.contentView addSubview:weekdayLabel];
    }
}


- (void)createDateView {
    
    NSInteger allNum = 28;
    
    float buttonWith = (self.width - 80) / 4;
    
    
    for (int i = 0; i < allNum; i++) {
        
        
        
        int r = i % 7;
        int q = i / 7;
        
        PillButton *pilldayButton = [[PillButton alloc] init];
        
        [pilldayButton addTarget:self action:@selector(pilldayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        pilldayButton.frame = CGRectMake(64 + buttonWith * q, 48 + itemHeight * r, buttonWith, itemHeight);
        
        [self.contentView addSubview:pilldayButton];
        
        [dateArray addObject:pilldayButton];
    }
}

- (void)createLayout {
    
    
    infoLabel = [[UILabel alloc] init];
    infoLabel.frame = CGRectMake(20, 20, self.width - 40, infoLabel.font.lineHeight);
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.text = @"Today is 11 of 20 days";
    [self.contentView addSubview:infoLabel];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.frame = CGRectMake(0, 0, self.width, self.height);
    backImageView.image = [UIImage imageNamed:@"BG_Pack.png"];
    
    [self.contentView addSubview:backImageView];
    
    
    itemHeight = ((ScreenHeight - 172) - 64) / 7;
    
    [self createWeekDayLayout];
    
    [self createDateView];
    
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        dateArray = [[NSMutableArray alloc] init];
        
        [self createLayout];
    }
    return self;
}

- (void)reloadData {
    
    NSInteger pillDayNum = [ScheduleManager pillDays];
    NSInteger allNum = [ScheduleManager getInstance].currentCycle;
    for (int i = 0; i < dateArray.count; i++) {
        PillButton *button = [dateArray validObjectAtIndex:i];
        
        
        NSDateComponents *components = [[ScheduleManager getInstance] dateInPack:self.tag day:i].components;
        [button setDay:components];
        
        
        if (i < pillDayNum) {
            button.hidden = NO;
            button.isPlacebo = NO;
        } else if (i < allNum) {
            button.hidden = NO;
            button.isPlacebo = YES;
        } else {
            button.hidden = YES;
        }
    }
}

@end
