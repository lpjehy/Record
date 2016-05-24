//
//  AdManager.h
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GoogleMobileAds;

static NSString *AdMobUnitIdCalendar = @"ca-app-pub-8261113346738623/5067220599";
static NSString *AdMobUnitIdSetting = @"ca-app-pub-8261113346738623/6543953791";

@interface AdManager : NSObject

+ (void)test;

+ (GADRequest *)request;

+ (GADBannerView *)settingView;

@end
