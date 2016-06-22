//
//  AnalyticsUtil.m
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "AnalyticsUtil.h"

#import "MobClick.h"


#define MobClickAppKey     @"56e03190e0f55a2063000f80"




@implementation AnalyticsUtil


+ (void)Initialize {
    UMConfigInstance.appKey = MobClickAppKey;
    UMConfigInstance.channelId = nil;
    [MobClick startWithConfigure:UMConfigInstance];
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
    [MobClick event:@"button_clicked" label:[NSString stringWithFormat:@"%s", string]];
}

+ (void)event:(NSString *)eventId {
    [MobClick event:eventId];
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
