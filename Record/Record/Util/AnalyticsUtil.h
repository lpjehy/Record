//
//  AnalyticsUtil.h
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticsUtil : NSObject

+ (void)Initialize;

+ (void)viewAppear:(NSString *)view;
+ (void)viewDisAppear:(NSString *)view;
@end
