//
//  AnalyticsUtil.m
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "AnalyticsUtil.h"

#import "MobClick.h"


#import "GAI.h"
#import "GAIDictionaryBuilder.h"

#define MobClickAppKey     @"56e03190e0f55a2063000f80"

#define GAName           @""
#define GATrackingId     @""


@implementation AnalyticsUtil


+ (void)Initialize {
    
    // UM
    UMConfigInstance.appKey = MobClickAppKey;
    UMConfigInstance.channelId = nil;
    [MobClick startWithConfigure:UMConfigInstance];
    
    // GA
    [[GAI sharedInstance] trackerWithName:GAName
                               trackingId:GATrackingId];

}

+ (NSMutableDictionary *)getOnceActiveKeys {
    static NSMutableDictionary *keyDic = nil;
    if (keyDic == nil) {
        keyDic = [[NSMutableDictionary alloc] init];
    }
    return keyDic;
}




+ (void)viewAppear:(NSString *)view {
    //NSLog(@"%@ viewAppear", view);
    [MobClick beginLogPageView:view];
}
+ (void)viewDisAppear:(NSString *)view {
    //NSLog(@"%@ viewDisAppear", view);
    [MobClick endLogPageView:view];
}

+ (void)buttonClicked:(const char[])string {
    
    NSString *action = @"button_clicked";
    NSString *label = [NSString stringWithFormat:@"%s", string];
    
    [MobClick event:action label:label];
    
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                          action:action  // Event action (required)
                                                           label:label          // Event label
                                                           value:nil] build]];    // Event value
}

+ (void)event:(NSString *)eventId {
    [MobClick event:eventId];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"event"     // Event category (required)
                                                          action:eventId  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
}

+ (void)eventDistinguishInitial:(NSString *)eventId {
    
    if ([ActionManager countForAction:Action_APP_Active] == 1) {
        
        [AnalyticsUtil event:[NSString stringWithFormat:@"%@_initial", eventId]];
    } else {
        [AnalyticsUtil event:eventId];
    }
}

+ (void)eventDistinguishInitialAndOnceActive:(NSString *)eventId {
    NSMutableDictionary *keyDic = [[self class] getOnceActiveKeys];
    NSString *value = [keyDic valueForKey:eventId];
    if (value == nil) {
        if ([ActionManager countForAction:Action_APP_Active] == 1) {
            
            [AnalyticsUtil event:[NSString stringWithFormat:@"%@_initial", eventId]];
        } else {
            [AnalyticsUtil event:eventId];
        }
        
        [keyDic setObject:@"1" forKey:eventId];
    }
    
}

+ (void)beginEvent:(NSString *)eventId {
    [MobClick beginEvent:eventId];
}

+ (void)endEvent:(NSString *)eventId {
    [MobClick endEvent:eventId];
}

+ (void)beginEventDistinguishInitial:(NSString *)eventId {
    
    if ([ActionManager countForAction:Action_APP_Active] == 1) {
        [AnalyticsUtil beginEvent:[NSString stringWithFormat:@"%@_initial", eventId]];
    } else {
        [AnalyticsUtil beginEvent:eventId];
    }
}

+ (void)endEventDistinguishInitial:(NSString *)eventId {
    
    if ([ActionManager countForAction:Action_APP_Active] == 1) {
        
        
        [AnalyticsUtil endEvent:[NSString stringWithFormat:@"%@_initial", eventId]];
    } else {
        [AnalyticsUtil endEvent:eventId];
    }
}

@end
