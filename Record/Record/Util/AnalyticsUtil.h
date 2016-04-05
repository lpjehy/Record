//
//  AnalyticsUtil.h
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString *Event_First_Opened = @"first_opened";
static NSString *Event_First_Opened_By_Reminder = @"first_opened_by_reminder";
static NSString *Event_First_Pack_Showed = @"first_pack_showed";
static NSString *Event_First_Set_Done = @"first_set_done";
static NSString *Event_First_Take_By_Reminder = @"first_take_by_reminder";

@interface AnalyticsUtil : NSObject

+ (void)Initialize;

+ (void)viewAppear:(NSString *)view;
+ (void)viewDisAppear:(NSString *)view;

+ (void)event:(NSString *)eventId;
@end
