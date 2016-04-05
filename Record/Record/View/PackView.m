//
//  PackCollectionViewCell.m
//  Record
//
//  Created by Jehy Fan on 16/3/4.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "PackView.h"

#import "NotifyUtil.h"

#import "ScheduleManager.h"
#import "RecordManager.h"
#import "MessageManager.h"

#import "PillButton.h"

static NSInteger const MaxDaysOfPack = 28;

@interface PackView(){
    
    UIImageView *backImageView;
    
    UILabel *infoLabel;
    UILabel *daysLabel;
    
    NSMutableArray *dateArray;
    
    float itemHeight;
    
    NSInteger currentPack;
    BOOL isPack2;
}
@end


@implementation PackView


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
    NSArray *weekdayArray = @[@1, @2, @3, @4, @5, @6, @7];
    
    float labelWidth = backImageView.width * 136 / 640;
    
    CGFloat baseY = 48;
    if (ISPad) {
        baseY = 80;
    }
    
    for (int i = 0; i < weekdayArray.count; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] init];
        weekdayLabel.textColor = [UIColor whiteColor];
        weekdayLabel.font = FontNormal;
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.frame = CGRectMake(backImageView.originX, baseY + itemHeight * i, labelWidth, itemHeight);
        NSInteger weekday = [[weekdayArray validObjectAtIndex:i] integerValue];
        weekdayLabel.text = [NSDateComponents textForWeekday:weekday];
        [self addSubview:weekdayLabel];
    }
}


- (void)createDateView {
    
    NSInteger allNum = 28;
    
    float buttonWidth = backImageView.width * 120 / 640;
    float baseX = backImageView.originX + buttonWidth;
    float baseY = 48;
    if (ISPad) {
        baseY = 80;
    }
    
    
    for (int i = 0; i < allNum; i++) {
        
        
        
        int r = i % 7;
        int q = i / 7;
        
        PillButton *pilldayButton = [[PillButton alloc] init];
        
        [pilldayButton addTarget:self action:@selector(pilldayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        pilldayButton.frame = CGRectMake(baseX + buttonWidth * q, baseY + itemHeight * r, buttonWidth, itemHeight);
        
        [self addSubview:pilldayButton];
        
        [dateArray addObject:pilldayButton];
    }
}

- (void)createLayout {
    if (infoLabel != nil) {
        return;
    }
    
    CGFloat baseY = 20;
    CGFloat baseX = 30;
    if (ISPad) {
        baseY = 40;
        baseX = 60;
    }
    
    infoLabel = [[UILabel alloc] init];
    infoLabel.frame = CGRectMake(baseX, baseY, self.width - baseX * 2, infoLabel.font.lineHeight);
    [self addSubview:infoLabel];
    
    
    
    
    daysLabel = [[UILabel alloc] init];
    daysLabel.frame = CGRectMake(baseX, baseY, self.width - baseX * 2, daysLabel.font.lineHeight);
    daysLabel.textColor = [UIColor whiteColor];
    daysLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:daysLabel];
    
    CGFloat backWidth = (self.width - 40);
    CGFloat backHeight = backWidth * 900 / 640;
    
    backImageView = [[UIImageView alloc] init];
    backImageView.frame = CGRectMake((self.width - backWidth) / 2, 0, backWidth, backHeight);
    backImageView.image = [UIImage imageNamed:@"BG_Pack.png"];
    
    [self addSubview:backImageView];
    
    if (ISPad) {
        itemHeight = (backHeight - 120) / 7;
    } else {
        itemHeight = (backHeight - 72) / 7;
    }
    
    
    [self createWeekDayLayout];
    
    [self createDateView];
    
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        dateArray = [[NSMutableArray alloc] init];
        
        
    }
    return self;
}


- (void)resetInfo {
    if (currentPack == 0) {
        infoLabel.textColor = [UIColor whiteColor];
        NSString *text = NSLocalizedString(@"pack_current_pack", nil);
        if (isPack2) {
            text = [text stringByAppendingString:@" - 2"];
        }
        
        infoLabel.text = text;
        
    } else {
        infoLabel.textColor = [UIColor redColor];
        infoLabel.text = NSLocalizedString(@"pack_not_current_pack", nil);
    }
}

- (void)resetDays {
    if ([ScheduleManager isEveryday]) {
        daysLabel.text = [NSString stringWithInteger:[ScheduleManager allDays]];
    } else {
        daysLabel.text = [NSString stringWithFormat:@"%zi + %zi", [ScheduleManager pillDays], [ScheduleManager breakDays]];
    }
}

- (void)reloadData {
    
    [self createLayout];
    
    
    
    NSInteger pillDayNum = [ScheduleManager pillDays];
    NSInteger allNum = [ScheduleManager allDays];
    isPack2 = NO;
    if (allNum > MaxDaysOfPack) {
        currentPack = self.tag / 2;
        NSInteger r = self.tag % 2;
        if (r == 1) {
            isPack2 = YES;
        }
    } else {
        currentPack = self.tag;
    }
    
    
    [self resetInfo];
    [self resetDays];
    
    for (int i = 0; i < dateArray.count; i++) {
        PillButton *button = [dateArray validObjectAtIndex:i];
        
        NSInteger day = i;
        if (isPack2) {
            day += MaxDaysOfPack;
        }
        NSDateComponents *components = [[ScheduleManager getInstance] dateInPack:currentPack day:day].components;
        if (components) {
            [button setDay:components];
            
            
            if (day < pillDayNum) {
                button.hidden = NO;
                button.isBreakDay = NO;
            } else if (day < allNum) {
                button.hidden = NO;
                if (![ScheduleManager isEveryday]) {
                    button.isBreakDay = YES;
                } else {
                    button.isBreakDay = NO;
                }
                
            } else {
                button.hidden = YES;
            }
            
            [button resetState];
            
            button.hidden = NO;
        } else {
            button.hidden = YES;
        }
        
    }
}

@end
