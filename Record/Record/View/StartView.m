//
//  StartView.m
//  Record
//
//  Created by Jehy Fan on 16/3/13.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "StartView.h"


@implementation StartView

- (id)init {
    self = [super init];
    if (self) {
        
        
        UILabel *hiLabel = [[UILabel alloc] init];
       
        hiLabel.textColor = [UIColor whiteColor];
        
        NSString *title = LocalizedString(@"start_hi");
        
        
        
        
        hiLabel.text = title;
        [self addSubview:hiLabel];
        
        UILabel *subTitleLabel = [[UILabel alloc] init];
        
        subTitleLabel.textColor = [UIColor whiteColor];
        subTitleLabel.numberOfLines = 2;
        
        
        subTitleLabel.text = LocalizedString(@"start_subtitle");
        [self addSubview:subTitleLabel];
        
        
        if ([title isEqualToString:@"Hi there"]) {
            hiLabel.font = FontLightMax;
            hiLabel.frame = CGRectMake(27.4, 54.3, ScreenWidth - 40, hiLabel.font.lineHeight);
            
            subTitleLabel.font = FontLightMiddle;
            subTitleLabel.frame = CGRectMake(27.4, 90, ScreenWidth - 40, subTitleLabel.font.lineHeight * 2 + 5);
        } else {
            hiLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24];
            hiLabel.frame = CGRectMake(26, 56, ScreenWidth - 40, hiLabel.font.lineHeight);
            
            
            subTitleLabel.font = FontLightMiddle;
            subTitleLabel.frame = CGRectMake(26, 95, ScreenWidth - 40, subTitleLabel.font.lineHeight * 2 + 5);
        }
        
        UIImageView *startImageView = [[UIImageView alloc] init];
        startImageView.frame = CGRectMake((ScreenWidth - 77) / 2, 280, 77, 125);
        startImageView.image = [UIImage imageNamed:@"Btn_Start.png"];
        
        [self addSubview:startImageView];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.font = FontLightMiddle;
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.numberOfLines = 2;
        tipLabel.frame = CGRectMake(20, 420, ScreenWidth - 40, tipLabel.font.lineHeight * 2);
        tipLabel.text = LocalizedString(@"start_tap");
        [self addSubview:tipLabel];
    }
    
    return self;
}


@end
