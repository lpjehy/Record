//
//  RecordManager.h
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>









@interface RecordData : NSObject

+ (void)record:(NSDate *)date;

+ (NSString *)selectRecord:(NSDate *)date;
+ (NSArray *)selectRecordFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;

+ (void)deleteRecord:(NSDate *)date;

@end
