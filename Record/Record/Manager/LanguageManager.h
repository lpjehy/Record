//
//  LanguageManager.h
//  Reminder
//
//  Created by Jehy Fan on 16/5/15.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageManager : NSObject

+ (void)Initialize;


+ (NSString *)language;
+ (void)setLanguage:(NSString *)language;


+ (BOOL)isZH_Han;

+ (NSString *)languageName:(NSString *)language;

@end
