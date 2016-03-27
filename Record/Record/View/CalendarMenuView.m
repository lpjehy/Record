//
//  CalendarMenuView.m
//  Record
//
//  Created by Jehy Fan on 16/3/26.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "CalendarMenuView.h"

#import "RecordManager.h"

@interface CalendarMenuView () {
    UIView *backView;
    UIButton *takeButton;
    UIButton *cancelButton;
}

@property(nonatomic, weak) CalendarDayCell *theCell;


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

- (void)showInView:(CalendarDayCell *)cell {
    [self.superview bringSubviewToFront:self];
    self.hidden = NO;
    
    self.theCell = cell;
    NSString *title = @"take";
    if (cell.isTaken) {
        title = @"untake";
    }
    
    [takeButton setTitle:title forState:UIControlStateNormal];
    
    UIScrollView *superView = (UIScrollView *)cell.superview;
    
    CGPoint center = CGPointMake(cell.center.x + 32, cell.center.y - superView.contentOffset.y + 32 + 64);
    
    backView.center = CGPointMake(center.x, center.y);
}

- (id)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, 0, 64, 64);
        backView.layer.cornerRadius = 5;
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        takeButton = [[UIButton alloc] init];
        takeButton.frame = CGRectMake(0, 0, backView.width, 32);
        takeButton.titleLabel.font = FontSmall;
        [takeButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
        [takeButton addTarget:self action:@selector(takeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:takeButton];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = ColorGrayDark;
        lineView.frame = CGRectMake(0, 32, backView.width, 0.5);
        
        [backView addSubview:lineView];
        
        cancelButton = [[UIButton alloc] init];
        cancelButton.frame = CGRectMake(0, 32, backView.width, 32);
        cancelButton.titleLabel.font = FontSmall;
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:ColorTextDark forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:cancelButton];
        
        [self addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

- (void)takeButtonPressed {
    self.hidden = YES;
    
    theCell.isTaken = !theCell.isTaken;
    [theCell resetState];
    if (theCell.isTaken) {
        [RecordManager record:theCell.day.theDate];
    } else {
        [RecordManager deleteRecord:theCell.day.theDate];
    }
}

- (void)cancelButtonPressed {
    self.hidden = YES;
}

@end
