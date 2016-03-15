//
//  AppOnlineConfigUtil.h
//  Record
//
//  Created by Jehy Fan on 16/3/9.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *OnlineConfig_AppleReviewVersion = @"apple_review_version";
static NSString *OnlineConfig_AppId = @"appid";

@interface OnlineConfigUtil : NSObject

+ (void)update;

+ (NSString *)getValueForKey:(NSString *)key;

@end
