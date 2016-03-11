//
//  AppOnlineConfigUtil.m
//  Record
//
//  Created by Jehy Fan on 16/3/9.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "OnlineConfigUtil.h"

#import "UMOnlineConfig.h"

#define MobClickAppKey     @"56e03190e0f55a2063000f80"

@implementation OnlineConfigUtil

+ (void)update {
    [UMOnlineConfig updateOnlineConfigWithAppkey:MobClickAppKey];
    [UMOnlineConfig setLogEnabled:YES];
}

+ (NSString *)getValueForKey:(NSString *)key {
    return [UMOnlineConfig getConfigParams:key];
}

@end
