//
//  SqlUtil.m
//  Record
//
//  Created by Jehy Fan on 16/3/3.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "SqlUtil.h"

#import "FMDB.h"


#define DBNAME    @"main.sqlite"


@interface SqlUtil () {
    FMDatabase *database;
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
        
        database = [FMDatabase databaseWithPath:database_path];
        if (![database open]) {
            
            NSLog(@"数据库打开失败");  
        }
    }
    
    return self;
}


- (BOOL)execSql:(NSString *)sql
{
    return [database executeUpdate:sql];
}




- (NSArray *)selectWithSql:(NSString *)sql {
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    FMResultSet *resultSet = [database executeQuery:sql];
    
    while (resultSet.next) {
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        for (NSString *culumn in resultSet.columnNameToIndexMap.allKeys) {
            
            [resultDic setValue:[resultSet stringForColumn:culumn] forKey:culumn];
        }
        
        [resultArray addObject:resultDic];
    }
    
    return resultArray;
}

@end
