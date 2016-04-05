//
//  PillButton.h
//  Record
//
//  Created by Jehy Fan on 16/3/15.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PillButton : UIButton


@property(nonatomic, strong) NSDateComponents *day;

@property(nonatomic) BOOL isBreakDay;
@property(nonatomic) BOOL isToday;
@property(nonatomic) BOOL isTaken;

- (void)resetState;


@end
