//
//  SqlUtil.m
//  Record
//
//  Created by Jehy Fan on 16/3/3.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "SqlUtil.h"

#import <sqlite3.h>


#define DBNAME    @"main.sqlite"


@interface SqlUtil () {
    sqlite3 *db;
}

@end

@implementation SqlUtil

+ (SqlUtil *)getInstance {
    static SqlUtil *instance = nil;
    if (instance == nil) {
        instance = [[SqlUtil alloc] init];
    }
    
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [paths objectAtIndex:0];
        NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
        
        if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库打开失败");  
        }
    }
    
    return self;
}


-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        NSLog(@"sql error: %@", sql);
    }
}




- (NSArray *)selectWithSql:(NSString *)sql resultTypes:(NSArray *)types {
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSMutableArray *result = [NSMutableArray array];
            
            for (int i = 0; i < types.count; i++) {
                NSString *type = [types validObjectAtIndex:i];
                if ([type isEqualToString:SqlDataTypeInt]) {
                    int intValue = sqlite3_column_int(statement, i);
                    [result addObject:[NSString stringWithInt:intValue]];
                    
                } else if ([type isEqualToString:SqlDataTypeText]) {
                    char *charValue = (char*)sqlite3_column_text(statement, i);
                    NSString *text = [[NSString alloc] initWithUTF8String:charValue];
                    [result addObject:text];
                    
                }
            }
            
            [resultArray addObject:result];
            
        }
    }
    
    return resultArray;
}

@end
