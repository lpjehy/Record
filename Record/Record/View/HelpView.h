//
//  HelpView.h
//  Record
//
//  Created by Jehy Fan on 16/3/1.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpView : UIButton

+ (HelpView *)getInstance;

+ (BOOL)PackHelpHasShowed;
+ (BOOL)CalendarHelpHasShowed;

- (void)showPackHelp;
- (void)showCalendarHelp;

@end
