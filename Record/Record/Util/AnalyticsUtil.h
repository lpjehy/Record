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

static NSString *Event_Refuse_Notify = @"refuse_notify";


static NSString *Event_view_calendar = @"view_calendar";

static NSString *Event_view_help_pack = @"view_help_pack";
static NSString *Event_view_help_calendar = @"view_help_calendar";

static NSString *Event_view_setting = @"view_setting";

static NSString *Event_view_future_pack = @"view_future_pack";

static NSString *Event_view_past_pack = @"view_past_pack";

static NSString *Event_back_to_current_pack_click = @"back_to_current_pack_click";
static NSString *Event_back_to_current_pack_swipe = @"back_to_current_pack_swipe";


@interface AnalyticsUtil : NSObject

+ (void)Initialize;

+ (NSMutableDictionary *)getOnceActiveKeys;

+ (void)viewAppear:(NSString *)view;
+ (void)viewDisAppear:(NSString *)view;

+ (void)buttonClicked:(const char[])string;

+ (void)event:(NSString *)eventId;
+ (void)eventDistinguishInitial:(NSString *)eventId;

+ (void)eventDistinguishInitialAndOnceActive:(NSString *)eventId;

+ (void)beginEvent:(NSString *)eventId;
+ (void)endEvent:(NSString *)eventId;

+ (void)beginEventDistinguishInitial:(NSString *)eventId;
+ (void)endEventDistinguishInitial:(NSString *)eventId;


@end
