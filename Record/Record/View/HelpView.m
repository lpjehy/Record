//
//  HelpView.m
//  Record
//
//  Created by Jehy Fan on 16/3/1.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "HelpView.h"

@interface HelpView () {
    UIButton *closeButton;
}

@end


@implementation HelpView

@synthesize show;

+ (HelpView *)getInstance {
    static HelpView *instance = nil;
    if (instance == nil) {
        instance = [[HelpView alloc] init];
    }
    
    return instance;
}

+ (void)firstShow {
    
    NSString *HelpViewHasShowedKey = @"HelpViewHasShowed";
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:HelpViewHasShowedKey] == NO) {
        [[HelpView getInstance] setShow:YES];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HelpViewHasShowedKey];
    }
    
}

- (void)createLayout {
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.alpha = 0;
    self.backgroundColor = ColorTranslucenceLight;
    [KEY_WINDOW addSubview:self];
    
    
    closeButton = [[UIButton alloc] init];
    closeButton.frame = CGRectMake(ScreenWidth - 64, 12, 48, 48);
    [closeButton setTitle:@"跳过" forState:UIControlStateNormal];
    closeButton.backgroundColor = [UIColor blueColor];
    [closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
}

- (id)init {
    self = [super init];
    if (self) {
        [self createLayout];
        
        
        
    }
    
    
    return self;
}


- (void)setShow:(BOOL)s {
    show = s;
    
    if (show) {
        self.alpha = 1;
    } else {
        self.alpha = 0;
    }
    
}

- (BOOL)show {
    return show;
}

- (void)closeButtonPressed {
    self.show = NO;
}

@end
