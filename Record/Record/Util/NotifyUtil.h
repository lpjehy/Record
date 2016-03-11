//
//  NotifyUtil.h
//  Record
//
//  Created by Jehy Fan on 16/3/3.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotifyUtil : NSObject

+ (void)notifyDate:(NSDate *)date alertBody:(NSString *)alertBody userInfo:(NSDictionary *)userInfo;

@end
