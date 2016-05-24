//
//  LanguageManager.m
//  Reminder
//
//  Created by Jehy Fan on 16/5/15.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "LanguageManager.h"

static NSString *AppLanguageKey = @"AppLanguage";


static NSString *AppLanguageBase = @"Base";
static NSString *AppLanguageHant = @"zh-Hant";
static NSString *AppLanguageHans = @"zh-Hans";
static NSString *AppLanguagePt = @"pt-PT";


@implementation LanguageManager


+ (void)Initialize
{
    if (![LanguageManager language]) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        NSLog(@"original language: %@", language);
        
        if ([language isEqualToString:AppLanguageHant]) {
            language = AppLanguageHant;
            
        } else if ([language hasPrefix:AppLanguageHans]) {
            language = AppLanguageHans;
            
        } else if ([language hasPrefix:@"pt"]) {
            language = AppLanguagePt;
            
        } else {
            language = AppLanguageBase;
        }
        
        
        [LanguageManager setLanguage:language];
    }
    
    NSLog(@"current language: %@", [LanguageManager language]);
    
    
    
    
}



/*
 Base
 
 
 */
+ (NSString *)language {
    return [[NSUserDefaults standardUserDefaults] objectForKey:AppLanguageKey];
}
+ (void)setLanguage:(NSString *)language {
    [[NSUserDefaults standardUserDefaults] setValue:language forKey:AppLanguageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isZH_Han {
    return [[[self class] language] hasPrefix:@"zh-Han"];
}


+ (NSString *)languageName:(NSString *)language {
    NSString *name = nil;
    if ([language isEqualToString:AppLanguageBase]) {
        name = @"English";
        
    } else if ([language isEqualToString:AppLanguageHans]) {
        name = @"中文(简体)";
        
    } else if ([language isEqualToString:AppLanguageHant]) {
        name = @"中文(繁體)";
        
    } else if ([language isEqualToString:AppLanguagePt]) {
        name = @"Português";
    }
    
    return name;
}



@end
