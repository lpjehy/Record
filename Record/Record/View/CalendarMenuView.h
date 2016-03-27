//
//  CalendarMenuView.h
//  Record
//
//  Created by Jehy Fan on 16/3/26.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CalendarDayCell.h"

typedef void (^CalendarMenuBlock)(void);

@interface CalendarMenuView : UIButton

+ (CalendarMenuView *)getInstance;

- (void)showInView:(CalendarDayCell *)cell;

@end