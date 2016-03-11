//
//  MessageManager.m
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "MessageManager.h"

#import "SqlUtil.h"
#import "Message.h"

#import "MessageCell.h"

static NSString *SQL_CREATE_TABLE = @"CREATE TABLE IF NOT EXISTS MESSAGE (ID INTEGER PRIMARY KEY AUTOINCREMENT, createtime DATETIME, content TEXT, state INTEGER)";
static NSString *SQL_INSERT_MESSAGE = @"INSERT INTO MESSAGE ('content', 'createtime', 'state') VALUES ('%@', datetime('now', 'localtime'), 0)";
static NSString *SQL_DELETE_MESSAGE = @"DELETE FROM MESSAGE WHERE ID = '%@'";
static NSString *SQL_SELECT_MESSAGE = @"SELECT * FROM MESSAGE";

@interface MessageManager () 

@end

@implementation MessageManager

+ (void)createTable {
    [[SqlUtil getInstance] execSql:SQL_CREATE_TABLE];
}

+ (void)createMessage:(NSString *)content {
    
    [MessageManager createTable];
    
    [[SqlUtil getInstance] execSql:[NSString stringWithFormat:SQL_INSERT_MESSAGE, content]];
}

+ (NSArray *)selectAllMessage {
    
    [self createTable];
    
    NSMutableArray *array = [NSMutableArray array];
    
    
    NSArray *resultArray = [[SqlUtil getInstance] selectWithSql:SQL_SELECT_MESSAGE resultTypes:@[SqlDataTypeText, SqlDataTypeText, SqlDataTypeText, SqlDataTypeInt]];
    for (NSArray *result in resultArray) {
        Message *message = [[Message alloc] init];
        
        message.serialid = [result validObjectAtIndex:0];
        message.time = [result validObjectAtIndex:1];
        message.content = [result validObjectAtIndex:2];
        message.state = [[result validObjectAtIndex:3] integerValue];
        
        [array addObject:message];
        
       //NSLog(@"id: %@ time: %@ content: %@ state: %zi", message.serialid, message.time, message.content, message.state);
    }
    
    
    
    return array;
}

+ (void)deleteMessage:(NSString *)serialid {
    [self createTable];
    
    [[SqlUtil getInstance] execSql:[NSString stringWithFormat:SQL_DELETE_MESSAGE, serialid]];
}

+ (MessageManager *)getInstance {
    static MessageManager *instance = nil;
    if (instance == nil) {
        instance = [[MessageManager alloc] init];
    }
    
    
    return instance;
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [[MessageManager selectAllMessage] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:MessageCellCellIdentifier];
    if(nil == cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessageCellCellIdentifier];
    }
    
    NSArray *array = [MessageManager selectAllMessage];
    Message *message = [array validObjectAtIndex:indexPath.row];
    
    [cell setMessage:message];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

@end
