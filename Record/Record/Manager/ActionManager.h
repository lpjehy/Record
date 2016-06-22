//
//  ActionManager.h
//  Reminder
//
//  Created by Jehy Fan on 16/6/10.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  对用户行为进行本地统计
 */

static NSString *Action_APP_Init = @"Action_APP_Init";
static NSString *Action_APP_Active = @"Action_APP_Active";

static NSString *Action_Record = @"Action_Record";

@interface ActionManager : NSObject

+ (void)action:(NSString *)action;
+ (NSInteger)countForAction:(NSString *)action;

@end
