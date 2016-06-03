//
//  CalendarMenuView.m
//  Record
//
//  Created by Jehy Fan on 16/3/26.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "CalendarMenuView.h"

#import "RecordData.h"
#import "MessageManager.h"

@interface CalendarMenuView () {
    UIView *backView;
    UIButton *takeButton;
    UIButton *cancelButton;
}

@property(nonatomic, weak) CalendarDayButton *theCell;


@end

@implementation CalendarMenuView

@synthesize theCell;

+ (CalendarMenuView *)getInstance {
    static CalendarMenuView *instance = nil;
    if (instance == nil) {
        instance = [[CalendarMenuView alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:instance];
        
    }
    
    return instance;
}

- (void)showInView:(CalendarDayButton *)button {
    [self.superview bringSubviewToFront:self];
    self.hidden = NO;
    
    self.theCell = button;
    NSString *title = LocalizedString(@"button_title_take");
    if (button.isTaken) {
        title = LocalizedString(@"button_title_untake");
    }
    
    [takeButton setTitle:title forState:UIControlStateNormal];
    
    UIScrollView *superView = (UIScrollView *)button.superview;
    CGFloat centerX = button.center.x + 32;
    if (centerX >= ScreenWidth - button.width / 2) {
        centerX = ScreenWidth - button.width;
    }
    
    
    CGPoint center = CGPointMake(centerX, button.center.y - superView.contentOffset.y + 32 + superView.originY);
    
    
    
    backView.center = center;
}

- (id)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, 0, 75, 80);
        backView.layer.cornerRadius = 5;
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        takeButton = [[UIButton alloc] init];
        takeButton.frame = CGRectMake(0, 0, backView.width, 40);
        takeButton.titleLabel.font = FontNormal;
        [takeButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
        [takeButton addTarget:self action:@selector(takeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:takeButton];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = ColorGrayDark;
        lineView.frame = CGRectMake(0, 40, backView.width, 0.5);
        
        [backView addSubview:lineView];
        
        cancelButton = [[UIButton alloc] init];
        cancelButton.frame = CGRectMake(0, 40, backView.width, 40);
        cancelButton.titleLabel.font = FontNormal;
        [cancelButton setTitle:LocalizedString(@"button_title_cancel") forState:UIControlStateNormal];
        [cancelButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:cancelButton];
        
        [self addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged) name:LanguageChangedNotification object:nil];
    }
    
    return self;
}

- (void)languageChanged {
    [cancelButton setTitle:LocalizedString(@"button_title_cancel") forState:UIControlStateNormal];
}

- (void)takeButtonPressed {
    self.hidden = YES;
    
    theCell.isTaken = !theCell.isTaken;
    [theCell resetState];
    if (theCell.isTaken) {
        [RecordData record:theCell.day.theDate];
    } else {
        [RecordData deleteRecord:theCell.day.theDate];
    }
    [[MessageManager getInstance] reloadData];
}

- (void)cancelButtonPressed {
    self.hidden = YES;
}

@end
