//
//  AppManager.h
//  Imager
//
//  Created by Jehy Fan on 16/2/24.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AnalyticsUtil.h"

@interface AppManager : NSObject

+ (void)Initialize;

+ (BOOL)hasFirstOpened;
+ (BOOL)hasFirstSetDone;
+ (BOOL)hasFirstPackShowed;
+ (BOOL)hasFirstOpenedByReminder;
+ (BOOL)isFirstOpeningByReminder;
+ (BOOL)hasFirstTakeByReminder;

+ (void)setFirstOpened;
+ (void)setFirstSetDone;
+ (void)setFirstPackShowed;
+ (void)setFirstOpenedByReminder;
+ (void)setFirstTakeByReminder;
+ (void)setFirstOpeningByReminder:(BOOL)is;

+ (NSString *)language;
+ (void)setLanguage:(NSString *)language;

@end
