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


+ (HelpView *)getInstance {
    static HelpView *instance = nil;
    if (instance == nil) {
        instance = [[HelpView alloc] init];
        
    }
    
    return instance;
}

- (void)initView {
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.hidden = YES;
    self.backgroundColor = ColorTranslucenceDark;
    [KEY_WINDOW addSubview:self];
    
    
    UIImageView *closeImageView = [[UIImageView alloc] init];
    closeImageView.frame = CGRectMake(ScreenWidth - 64, 12, 48, 48);
    closeImageView.image = [UIImage imageNamed:@""];
    [self addSubview:closeImageView];
    
    
    tapLabel = [[UILabel alloc] init];
    tapLabel.font = FontNormal;
    tapLabel.textAlignment = NSTextAlignmentCenter;
    tapLabel.frame = CGRectMake(0, 150, ScreenWidth, tapLabel.font.lineHeight);
    tapLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:tapLabel];
    
    tapImageView = [[UIImageView alloc] init];
    tapImageView.frame = CGRectMake((ScreenWidth - 71) / 2, 200, 71, 107);
    tapImageView.image = [UIImage imageNamed:@"Gesture_Tap.png"];
    [self addSubview:tapImageView];
    
    
    swipeLabel = [[UILabel alloc] init];
    swipeLabel.font = FontNormal;
    swipeLabel.textAlignment = NSTextAlignmentCenter;
    swipeLabel.frame = CGRectMake(0, 360, ScreenWidth, tapLabel.font.lineHeight);
    swipeLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:swipeLabel];
    
    swipeImageView = [[UIImageView alloc] init];
    [self addSubview:swipeImageView];
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
    
    self.hidden = NO;
    
    tapLabel.text = @"Tap to take pill, tap again to untake it";
    
    swipeLabel.text = @"Swipe to check incoming packs of pills";
    swipeImageView.image = [UIImage imageNamed:@"Gesture_Swipe_Right.png"];
    swipeImageView.frame = [swipeImageView.image frameInRect:CGRectMake((ScreenWidth - 100) / 2, 400, 100, 105)];
}
- (void)showCalendarHelp {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HelpCalendarViewHasShowedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.hidden = NO;
    
    
    tapLabel.text = @"Tap a date to edit";
    
    swipeLabel.text = @"Swipe up & down to switch mouth";
    swipeImageView.image = [UIImage imageNamed:@"Gesture_Swipe_Down.png"];
    swipeImageView.frame = [swipeImageView.image frameInRect:CGRectMake((ScreenWidth - 100) / 2, 400, 100, 122)];
}

- (void)hide {
    self.hidden = YES;
}






@end
