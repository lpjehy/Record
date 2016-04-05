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
    [MobClick startWithAppkey:MobClickAppKey
                 reportPolicy:BATCH
                    channelId:nil];
}

+ (void)viewAppear:(NSString *)view {
    //NSLog(@"%@ viewAppear", view);
    [MobClick beginLogPageView:view];
}
+ (void)viewDisAppear:(NSString *)view {
    //NSLog(@"%@ viewDisAppear", view);
    [MobClick endLogPageView:view];
}


+ (void)event:(NSString *)eventId {
    [MobClick event:eventId];
}

@end
