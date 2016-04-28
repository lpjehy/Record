//
//  LegendView.m
//  Record
//
//  Created by Jehy Fan on 16/3/26.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "LegendView.h"

@interface LegendView () {
    
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
        
        
        UILabel *legendLabel = [[UILabel alloc] init];
        legendLabel.text = NSLocalizedString(@"button_title_legend", nil);
        legendLabel.font = FontMiddle;
        legendLabel.frame = CGRectMake(36, 15, 128, legendLabel.font.lineHeight);
        legendLabel.textColor = ColorGrayDark;
        [backImageView addSubview:legendLabel];
        
        UILabel *takedLabel = [[UILabel alloc] init];
        takedLabel.text = NSLocalizedString(@"legend_taked", nil);
        takedLabel.font = FontMiddle;
        takedLabel.frame = CGRectMake(56, 64, 200, legendLabel.font.lineHeight);
        takedLabel.textColor = ColorTextDark;
        [backImageView addSubview:takedLabel];
        
        UILabel *untakenLabel = [[UILabel alloc] init];
        untakenLabel.text = NSLocalizedString(@"legend_untaken", nil);
        untakenLabel.font = FontMiddle;
        untakenLabel.frame = CGRectMake(56, 104, 200, legendLabel.font.lineHeight);
        untakenLabel.textColor = ColorTextDark;
        [backImageView addSubview:untakenLabel];
        
        
        
        UILabel *placeboLabel = [[UILabel alloc] init];
        placeboLabel.text = NSLocalizedString(@"legend_placebo", nil);
        placeboLabel.font = FontMiddle;
        placeboLabel.frame = CGRectMake(56, 140, 200, legendLabel.font.lineHeight);
        placeboLabel.textColor = ColorTextDark;
        [backImageView addSubview:placeboLabel];
        
        UILabel *untakenPlaceboLabel = [[UILabel alloc] init];
        untakenPlaceboLabel.text = NSLocalizedString(@"legend_untaken_placebo", nil);
        untakenPlaceboLabel.font = FontMiddle;
        untakenPlaceboLabel.frame = CGRectMake(56, 180, 200, legendLabel.font.lineHeight);
        untakenPlaceboLabel.textColor = ColorTextDark;
        [backImageView addSubview:untakenPlaceboLabel];
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        [self addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)buttonPressed {
    self.hidden = YES;
}

- (void)show {
    [self.superview bringSubviewToFront:self];
    self.hidden = NO;
}


@end
