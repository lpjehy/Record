//
//  ActionManager.m
//  Reminder
//
//  Created by Jehy Fan on 16/6/10.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "ActionManager.h"

@implementation ActionManager


+ (void)action:(NSString *)action {
    
    NSInteger count = [[self class] countForAction:action];
    count++;
    NSLog(@"action %@ %zi", action, count);
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:action];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)countForAction:(NSString *)action {
    return [[NSUserDefaults standardUserDefaults] integerForKey:action];
}

@end
