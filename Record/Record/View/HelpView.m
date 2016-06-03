//
//  HelpView.m
//  Record
//
//  Created by Jehy Fan on 16/3/1.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "HelpView.h"

@interface HelpView () {
    UILabel *tapLabel;
    UIImageView *tapImageView;
    UILabel *swipeLabel;
    UIImageView *swipeImageView;
}

@end


static NSString *HelpPackViewHasShowedKey = @"HelpPackViewHasShowed";
static NSString *HelpCalendarViewHasShowedKey = @"HelpCalendarViewHasShowed";

@implementation HelpView



- (void)initView {
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.hidden = YES;
    self.backgroundColor = ColorTranslucenceDark;
    
    
    tapLabel = [[UILabel alloc] init];
    tapLabel.font = FontMiddle;
    tapLabel.textAlignment = NSTextAlignmentCenter;
    tapLabel.numberOfLines = 0;
    tapLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:tapLabel];
    
    tapImageView = [[UIImageView alloc] init];
    
    
    tapImageView.image = [UIImage imageNamed:@"Gesture_Tap.png"];
    [self addSubview:tapImageView];
    
    
    swipeLabel = [[UILabel alloc] init];
    swipeLabel.font = FontMiddle;
    swipeLabel.textAlignment = NSTextAlignmentCenter;
    swipeLabel.numberOfLines = 0;
    
    swipeLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:swipeLabel];
    
    swipeImageView = [[UIImageView alloc] init];
    [self addSubview:swipeImageView];
    
    
    if (ScreenHeight == ScreenHeight480) {
        tapLabel.frame = CGRectMake(10, 100, ScreenWidth - 20, tapLabel.font.lineHeight);
        tapImageView.frame = CGRectMake((ScreenWidth - 71) / 2, 150, 71, 107);
        swipeLabel.frame = CGRectMake(10, 310, ScreenWidth - 20, swipeLabel.font.lineHeight);
    } else {
        tapLabel.frame = CGRectMake(10, 150, ScreenWidth - 20, tapLabel.font.lineHeight);
        tapImageView.frame = CGRectMake((ScreenWidth - 71) / 2, 200, 71, 107);
        swipeLabel.frame = CGRectMake(10, 360, ScreenWidth - 20, swipeLabel.font.lineHeight);
    }
    
}

- (id)init {
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        
        [self initView];
    }
    
    
    return self;
}


+ (BOOL)PackHelpHasShowed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:HelpPackViewHasShowedKey];
}
+ (BOOL)CalendarHelpHasShowed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:HelpCalendarViewHasShowedKey];
}

- (void)showPackHelp {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HelpPackViewHasShowedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.superview bringSubviewToFront:self];
    
    self.hidden = NO;
    
    tapLabel.text = LocalizedString(@"help_take_pill");
    [tapLabel fixHeight];
    
    swipeLabel.text = LocalizedString(@"help_check_pack");
    [swipeLabel fixHeight];
    
    swipeImageView.image = [UIImage imageNamed:@"Gesture_Swipe_Right.png"];
    
    if (ScreenHeight == ScreenHeight480) {
        swipeImageView.frame = [swipeImageView.image frameInRect:CGRectMake((ScreenWidth - 100) / 2, 350, 100, 105)];
    } else {
        swipeImageView.frame = [swipeImageView.image frameInRect:CGRectMake((ScreenWidth - 100) / 2, 400, 100, 105)];
    }
    
}
- (void)showCalendarHelp {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HelpCalendarViewHasShowedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.hidden = NO;
    
    
    tapLabel.text = LocalizedString(@"help_edit_date");
    [tapLabel fixHeight];
    
    swipeLabel.text = LocalizedString(@"help_switch_month");
    [swipeLabel fixHeight];
    
    swipeImageView.image = [UIImage imageNamed:@"Gesture_Swipe_Down.png"];
    
    if (ScreenHeight == ScreenHeight480) {
        swipeImageView.frame = [swipeImageView.image frameInRect:CGRectMake((ScreenWidth - 100) / 2, 350, 100, 122)];
    } else {
        swipeImageView.frame = [swipeImageView.image frameInRect:CGRectMake((ScreenWidth - 100) / 2, 400, 100, 122)];
    }
    
}

- (void)hide {
    self.hidden = YES;
}






@end
