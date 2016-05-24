//
//  AdView.m
//  Reminder
//
//  Created by Jehy Fan on 16/5/18.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "AdView.h"

@interface AdView () <GADBannerViewDelegate>

@end
@implementation AdView

- (id)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    
    return self;
}


/// Tells the delegate that an ad request successfully received an ad. The delegate may want to add
/// the banner view to the view hierarchy if it hasn't been added yet.
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    //NSLog(@"adViewDidReceiveAd");
}

/// Tells the delegate that an ad request failed. The failure is normally due to network
/// connectivity or ad availablility (i.e., no fill).
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
   // NSLog(@"didFailToReceiveAdWithError");
}

#pragma mark Click-Time Lifecycle Notifications

/// Tells the delegate that a full screen view will be presented in response to the user clicking on
/// an ad. The delegate may want to pause animations and time sensitive interactions.
- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    //NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)bannerView {
    //NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full screen view has been dismissed. The delegate should restart
/// anything paused while handling adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {
    //NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that the user click will open another app, backgrounding the current
/// application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
/// are called immediately before this method is called.
- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {
    //NSLog(@"adViewWillLeaveApplication");
    
    [AnalyticsUtil event:@"ad_clicked"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    //NSLog(@"touchesBegan");
}

@end
