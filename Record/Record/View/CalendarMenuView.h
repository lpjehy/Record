//
//  CalendarMenuView.h
//  Record
//
//  Created by Jehy Fan on 16/3/26.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CalendarDayButton.h"



@interface CalendarMenuView : UIButton

+ (CalendarMenuView *)getInstance;

- (void)showInView:(CalendarDayButton *)cell;

@end
