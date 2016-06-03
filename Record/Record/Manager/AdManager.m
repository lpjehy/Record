//
//  AdManager.m
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "AdManager.h"
#import "AdBannerView.h"

@implementation AdManager

+ (void)test {
   
}

+ (GADRequest *)request {
    static GADRequest *request = nil;
    if (request == nil) {
        request = [GADRequest request];
    }
    return request;
}

+ (GADBannerView *)settingView {
    static AdBannerView *view = nil;
    if (view == nil) {
        
        view = [[AdBannerView alloc] init];  
        view.adUnitID = AdMobUnitIdSetting;
        view.rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [view loadRequest:[AdManager request]];
        view.frame = CGRectMake(0, 64, ScreenWidth, 64);
    }
    
    
    return view;
}

@end
