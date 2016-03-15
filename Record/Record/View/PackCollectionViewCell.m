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
    
    NSMutableArray *dateArray;
    
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
        
        UIButton *pilldayButton = [[UIButton alloc] init];
        
        [pilldayButton addTarget:self action:@selector(pilldayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        pilldayButton.frame = CGRectMake(64 + buttonWith * q, 48 + itemHeight * r, buttonWith, itemHeight);
        
        [pilldayButton setTitle:[NSString stringWithInt:i + 1] forState:UIControlStateNormal];
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
    NSInteger safeDayNum = [ScheduleManager safeDays];
    
    NSInteger allNum = pillDayNum + safeDayNum;
    for (int i = 0; i < dateArray.count; i++) {
        UIButton *button = [dateArray validObjectAtIndex:i];
        
        if (i < pillDayNum) {
            button.hidden = NO;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else if (i < allNum) {
            button.hidden = NO;
            [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        } else {
            button.hidden = YES;
        }
    }
}

@end
