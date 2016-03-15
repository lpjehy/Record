//
//  StartView.m
//  Record
//
//  Created by Jehy Fan on 16/3/13.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "StartView.h"

static NSString *StartViewShowedKey = @"StartViewShowed";

@implementation StartView

- (id)init {
    self = [super init];
    if (self) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:StartViewShowedKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UILabel *hiLabel = [[UILabel alloc] init];
        hiLabel.font = FontMax;
        hiLabel.textColor = [UIColor whiteColor];
        hiLabel.frame = CGRectMake(20, 64, ScreenWidth - 40, hiLabel.font.lineHeight);
        hiLabel.text = @"Hi there";
        [self addSubview:hiLabel];
        
        UILabel *subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.font = FontNormal;
        subTitleLabel.textColor = [UIColor whiteColor];
        subTitleLabel.numberOfLines = 2;
        subTitleLabel.frame = CGRectMake(20, 88, ScreenWidth - 40, subTitleLabel.font.lineHeight * 2 + 5);
        subTitleLabel.text = @"My reminder helps you\nnever miss your pill";
        [self addSubview:subTitleLabel];
        
        UIImageView *startImageView = [[UIImageView alloc] init];
        startImageView.frame = CGRectMake((ScreenWidth - 77) / 2, 280, 77, 125);
        startImageView.image = [UIImage imageNamed:@"Btn_Start.png"];
        
        [self addSubview:startImageView];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.font = FontNormal;
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.frame = CGRectMake(20, 420, ScreenWidth - 40, tipLabel.font.lineHeight * 2);
        tipLabel.text = @"Tip the button to set your Contraceptive pill";
        [self addSubview:tipLabel];
    }
    
    return self;
}

+ (BOOL)hasShowed {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:StartViewShowedKey];
}

@end
