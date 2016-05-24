//
//  LegendView.m
//  Record
//
//  Created by Jehy Fan on 16/3/26.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "LegendView.h"

@interface LegendView () {
    UILabel *legendLabel;
    UILabel *takedLabel;
    UILabel *untakenLabel;
    UILabel *placeboLabel;
    UILabel *untakenPlaceboLabel;
}

@end

@implementation LegendView

+ (LegendView *)getInstance {
    static LegendView *instance = nil;
    if (instance == nil) {
        instance = [[LegendView alloc] init];
        
        [[UIApplication sharedApplication].keyWindow addSubview:instance];
    }
    
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.hidden = YES;
        
        UIImageView *backImageView = [[UIImageView alloc] init];
        backImageView.layer.cornerRadius = 10;
        backImageView.clipsToBounds = YES;
        backImageView.image = [UIImage imageNamed:@"Calendar_BG_Legend.png"];
        backImageView.frame = CGRectMake((ScreenWidth - 270) / 2, (ScreenHeight - 240) / 2, 270, 240);
        [self addSubview:backImageView];
        
        
        legendLabel = [[UILabel alloc] init];
        
        legendLabel.font = FontMiddle;
        legendLabel.frame = CGRectMake(36, 15, 128, legendLabel.font.lineHeight);
        legendLabel.textColor = ColorGrayDark;
        [backImageView addSubview:legendLabel];
        
        takedLabel = [[UILabel alloc] init];
        
        takedLabel.font = FontMiddle;
        takedLabel.frame = CGRectMake(56, 64, 200, legendLabel.font.lineHeight);
        takedLabel.textColor = ColorTextDark;
        [backImageView addSubview:takedLabel];
        
        untakenLabel = [[UILabel alloc] init];
        
        untakenLabel.font = FontMiddle;
        untakenLabel.frame = CGRectMake(56, 104, 200, legendLabel.font.lineHeight);
        untakenLabel.textColor = ColorTextDark;
        [backImageView addSubview:untakenLabel];
        
        
        
        placeboLabel = [[UILabel alloc] init];
        
        placeboLabel.font = FontMiddle;
        placeboLabel.frame = CGRectMake(56, 140, 200, legendLabel.font.lineHeight);
        placeboLabel.textColor = ColorTextDark;
        [backImageView addSubview:placeboLabel];
        
        untakenPlaceboLabel = [[UILabel alloc] init];
        
        untakenPlaceboLabel.font = FontMiddle;
        untakenPlaceboLabel.frame = CGRectMake(56, 180, 200, legendLabel.font.lineHeight);
        untakenPlaceboLabel.textColor = ColorTextDark;
        [backImageView addSubview:untakenPlaceboLabel];
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        [self addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self setText];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged) name:LanguageChangedNotification object:nil];
    }
    
    return self;
}

- (void)setText {
    legendLabel.text = LocalizedString(@"button_title_legend");
    takedLabel.text = LocalizedString(@"legend_taked");
    untakenLabel.text = LocalizedString(@"legend_untaken");
    placeboLabel.text = LocalizedString(@"legend_placebo");
    untakenPlaceboLabel.text = LocalizedString(@"legend_untaken_placebo");
}

- (void)languageChanged {
    [self setText];
}

- (void)buttonPressed {
    self.hidden = YES;
}

- (void)show {
    [self.superview bringSubviewToFront:self];
    self.hidden = NO;
}


@end
