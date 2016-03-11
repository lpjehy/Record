//
//  RecordManager.m
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "RecordManager.h"

#import "SqlUtil.h"


static NSString *SQL_CREATE_TABLE = @"CREATE TABLE IF NOT EXISTS RECORD (ID INTEGER PRIMARY KEY AUTOINCREMENT, createtime DATETIME)";

@implementation RecordManager

+ (void)record {
    //[[SqlUtil getInstance] insertData];
}

+ (void)view {
    //[[SqlUtil getInstance] test];
}

@end
