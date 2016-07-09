//
//  PackCollectionViewCell.m
//  Record
//
//  Created by Jehy Fan on 16/3/4.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "PackView.h"


#import "ScheduleManager.h"
#import "RecordData.h"
#import "AudioManager.h"

#import "RefillManager.h"

#import "PillButton.h"





@interface PackView(){
    
    UIImageView *backImageView;
    
    UILabel *infoLabel;
    UILabel *daysLabel;
    
    NSMutableArray *dateButtonArray;
    NSMutableArray *lineViewArray;
    NSMutableArray *weekdayLabelArray;
    
    float itemHeight;
    
    
}

@property(nonatomic, strong) NSDateComponents *firstDate;
@property(nonatomic, strong) NSDateComponents *lastDate;



@end


@implementation PackView

@synthesize firstDate, lastDate;

@synthesize packIndex, subPackIndex;

@synthesize timeInfo;

- (void)pilldayButtonPressed:(PillButton *)button {
    
    
    NSDate *date = button.day.theDayDate;
    
    if (!date.isEarlier) {
        [UIAlertView showMessage:LocalizedString(@"alert_message_nohurry")];
        return;
    }
    
    NSString *record = [RecordData selectRecord:date];
    if (record) {
        button.isTaken = NO;
        [RecordData deleteRecord:date];
    } else {
        [RecordData record:date];
        button.isTaken = YES;
        
        [ActionManager action:Action_Record];
                
    }
    
    [AudioManager Vibrate];
    
}


- (void)createWeekDayLayout {
    
    weekdayLabelArray = [[NSMutableArray alloc] init];
    
    float labelWidth = backImageView.width * 136 / 640;
    
    CGFloat baseY = 50;
    if (ISPad) {
        baseY = 80;
    } else if (ScreenHeight == ScreenHeight568) {
        baseY = 40;
    } else if (ScreenHeight == ScreenHeight480) {
        baseY = 32;
    }
    
    for (int i = 0; i < 7; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] init];
        weekdayLabel.textColor = [UIColor whiteColor];
        weekdayLabel.font = FontNormal;
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.frame = CGRectMake(backImageView.originX, baseY + itemHeight * i, labelWidth, itemHeight);
        [self addSubview:weekdayLabel];
        
        [weekdayLabelArray addObject:weekdayLabel];
    }
}


- (void)createDateView {
    
    float buttonWidth = backImageView.width * 120 / 640;
    float baseX = backImageView.originX + buttonWidth;
    float baseY = 48;
    if (ISPad) {
        baseY = 80;
    } else if (ScreenHeight == ScreenHeight568) {
        baseY = 40;
    } else if (ScreenHeight == ScreenHeight480) {
        baseY = 32;
    }
    
    
    for (int i = 0; i < MaxDaysOfPack; i++) {
        
        
        
        int r = i % 7;
        int q = i / 7;
        
        PillButton *pilldayButton = [[PillButton alloc] init];
        
        [pilldayButton addTarget:self action:@selector(pilldayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        pilldayButton.frame = CGRectMake(baseX + buttonWidth * q, baseY + itemHeight * r, buttonWidth, itemHeight);
        if (pilldayButton.originX < 0) {
            NSLog(@"%zi %zi %zi %f %f", i, packIndex, subPackIndex, buttonWidth, itemHeight);
        }
        [self addSubview:pilldayButton];
        
        [dateButtonArray addObject:pilldayButton];
        
        
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
    } else if (ScreenHeight == ScreenHeight480) {
        baseY = 10;
        baseX = 20;
    }
    
    infoLabel = [[UILabel alloc] init];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.frame = CGRectMake(baseX, baseY, self.width - baseX * 2, infoLabel.font.lineHeight);
    [self addSubview:infoLabel];
    
    
    
    
    daysLabel = [[UILabel alloc] init];
    daysLabel.frame = CGRectMake(baseX, baseY, self.width - baseX * 2, daysLabel.font.lineHeight);
    daysLabel.textColor = [UIColor whiteColor];
    daysLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:daysLabel];
    
    CGFloat backWidth = (self.width - 20);
    CGFloat backHeight = backWidth * 900 / 640;
    
    backImageView = [[UIImageView alloc] init];
    backImageView.frame = CGRectMake((self.width - backWidth) / 2, 0, backWidth, backHeight);
    backImageView.image = [UIImage imageNamed:@"BG_Pack.png"];
    
    [self addSubview:backImageView];
    
    if (ISPad) {
        itemHeight = (backHeight - 120) / 7;
    } else if (ScreenHeight == ScreenHeight568) {
        itemHeight = (backHeight - 56) / 7;
    } else if (ScreenHeight == ScreenHeight480) {
        itemHeight = (backHeight - 48) / 7;
    } else {
        itemHeight = (backHeight - 72) / 7;
    }
    
    
    [self createWeekDayLayout];
    
    [self createDateView];
    
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        dateButtonArray = [[NSMutableArray alloc] init];
        lineViewArray = [[NSMutableArray alloc] init];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refillStateChanged)
                                                     name:RefillStateChangedNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)refillStateChanged {
    [self resetInfo];
}


- (void)resetInfo {
    
    infoLabel.textColor = [UIColor whiteColor];
    
    if (packIndex == 0 && [RefillManager shouldNotify]) {
        NSInteger leftPillNum = [RefillManager leftPillNum];
        NSString *text = [NSString stringWithFormat:LocalizedString(@"refill_pills_left"), leftPillNum];
        if (leftPillNum == 1) {
            text = LocalizedString(@"refill_pill_left");
        }
        infoLabel.text = text;
        if (leftPillNum <= [RefillManager notifyPillNum]) {
            infoLabel.textColor = ColorTextRed;
        }
        
    } else {
        NSString *text = [NSString stringWithFormat:@"%zi.%zi-%zi.%zi", firstDate.month, firstDate.day, lastDate.month, lastDate.day];
        self.timeInfo = text;
        infoLabel.text = text;
    }
    
}

- (void)resetDays {
    if ([ScheduleManager isEveryday]) {
        daysLabel.text = nil;
    } else {
        daysLabel.text = [NSString stringWithFormat:@"%zi + %zi", [ScheduleManager pillDays], [ScheduleManager breakDays]];
    }
}

- (void)reloadData {
    
    [self createLayout];
    
    self.firstDate = nil;
    self.lastDate = nil;
    
    
    NSInteger pillDayNum = [ScheduleManager pillDays];
    NSInteger allNum = [ScheduleManager allDays];
    
    NSInteger lastPack = 0;
    NSInteger currentDayFromStart = [[ScheduleManager getInstance] currentDayFromStartDay];
    if (currentDayFromStart > allNum) {
        lastPack = 1;
    }
    
    
    
    
    
    if (allNum > MaxDaysOfPack) {
        
        NSInteger page = self.tag;
        NSInteger pageOfPack = allNum / MaxDaysOfPack + 1;
        
        
        packIndex = page / pageOfPack - lastPack;
        subPackIndex = page % pageOfPack;
        
    } else {
        packIndex = self.tag - lastPack;
        subPackIndex = 0;
    }
    
    for (UIView *lineView in lineViewArray) {
        lineView.hidden = YES;
    }
    
    for (PillButton *button in dateButtonArray) {
        button.day = nil;
    }
    
    [self resetDays];
    
    for (int i = 0; i < dateButtonArray.count; i++) {
        PillButton *button = [dateButtonArray validObjectAtIndex:i];
        
        NSInteger day = i + subPackIndex * MaxDaysOfPack;
        
        NSDateComponents *components = [[ScheduleManager getInstance] dateInPack:packIndex day:day].components;
        
        if (components) {
            
            if (i < 7) {
                UILabel *weekdayLabel = [weekdayLabelArray validObjectAtIndex:i];
                if (weekdayLabel) {
                    weekdayLabel.text = [NSDateComponents textForWeekday:components.weekday];
                }
            }
            
            button.day = components;
            
            
            
            if (firstDate == nil) {
                self.firstDate = components;
            }
            
            self.lastDate = components;
            
            if (day < pillDayNum) {
                
                button.isBreakDay = NO;
            } else if (day < allNum) {
                
                if (![ScheduleManager isEveryday]) {
                    button.isBreakDay = YES;
                } else {
                    button.isBreakDay = NO;
                }
                
            } else {
                
            }
            
            [button resetState];
            
            button.hidden = NO;
            
            /*
            NSInteger q = i / 7;
            if (q != 0) {
                UIImageView *lineImageView = [lineViewArray validObjectAtIndex:q - 1];
                if (lineImageView == nil) {
                    lineImageView = [[UIImageView alloc] init];
                    lineImageView.backgroundColor = [UIColor redColor];
                    lineImageView.frame = CGRectMake(button.originX, button.center.y, 1, itemHeight * 6);
                    
                    [self addSubview:lineImageView];
                    
                    [lineViewArray addObject:lineImageView];
                }
                
                lineImageView.hidden = NO;
            }
             */
        } else {
            
            
            
            button.hidden = YES;
        }
        
        
        
    }
    
    [self resetInfo];
}

@end
