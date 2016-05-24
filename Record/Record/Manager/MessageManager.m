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

#import "ScheduleManager.h"
#import "RecordManager.h"




static NSString *SQL_CREATE_TABLE = @"CREATE TABLE IF NOT EXISTS MESSAGE (ID INTEGER PRIMARY KEY AUTOINCREMENT, createtime DATETIME, content TEXT, state INTEGER)";
static NSString *SQL_INSERT_MESSAGE = @"INSERT INTO MESSAGE ('content', 'createtime', 'state') VALUES ('%@', datetime('now', 'localtime'), 0)";
static NSString *SQL_DELETE_MESSAGE = @"DELETE FROM MESSAGE WHERE ID = '%@'";
static NSString *SQL_SELECT_MESSAGE = @"SELECT * FROM MESSAGE";

@interface MessageManager () {
    NSMutableArray *messageArray;
}

@end

@implementation MessageManager

+ (void)createTable {
    [[SqlUtil getInstance] execSql:SQL_CREATE_TABLE];
}

+ (void)createMessage:(NSString *)content {
    if (content == nil) {
        return;
    }
    [MessageManager createTable];
    
    [[SqlUtil getInstance] execSql:[NSString stringWithFormat:SQL_INSERT_MESSAGE, content]];
}

+ (NSArray *)selectAllMessage {
    
    [self createTable];
    
    NSMutableArray *array = [NSMutableArray array];
    
    
    NSArray *resultArray = [[SqlUtil getInstance] selectWithSql:SQL_SELECT_MESSAGE];
    for (NSDictionary *result in resultArray) {
        Message *message = [[Message alloc] init];
        
        message.serialid = [result validObjectForKey:@"id"];
        message.time = [result validObjectForKey:@"createtime"];
        message.content = [result validObjectForKey:@"content"];
        message.state = [[result validObjectForKey:@"state"] integerValue];
        
        [array addObject:message];
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

@synthesize messageTableView;

- (id)init {
    self = [super init];
    if (self) {
        messageArray = [[NSMutableArray alloc] init];
        
        [self reloadData];
    }
    
    return self;
}

- (void)reloadData {
    [messageArray removeAllObjects];
    
    
    NSString *firstMessage = [[ScheduleManager getInstance] todayInfo];
    if (firstMessage) {
        [messageArray addObject:firstMessage];
    }
    
    
    NSDate *startDate = [ScheduleManager startDate];
    for (int i = (int)[ScheduleManager getInstance].currentDayFromStartDay - 1; i >= 0; i--) {
        NSDate *date = [NSDate dateWithTimeInterval:TimeIntervalDay * i sinceDate:startDate];
        
        BOOL isBreakDay = [[ScheduleManager getInstance] isPlaceboDay:date.components];
        if (isBreakDay && ![ScheduleManager takePlaceboPills]) {
            continue;
        }
        
        
        NSString *record = [RecordManager selectRecord:date];
        if (record == nil) {
            NSDateComponents *day = date.components;
            NSString *message = [NSString stringWithFormat:@"%zi/%zi  %@", day.month, day.day, LocalizedString(@"message_missed")];
            [messageArray addObject:message];
        }
    }
    
    
    if (messageTableView) {
        [messageTableView reloadData];
    }
}

- (NSArray *)allMessage {
    
    
    return messageArray;
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [[[MessageManager getInstance] allMessage] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:MessageCellCellIdentifier];
    if(nil == cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessageCellCellIdentifier];
    }
    
    NSArray *array = [[MessageManager getInstance] allMessage];
    NSString *message = [array validObjectAtIndex:indexPath.row];
    
    [cell setMessage:message];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return [MessageCell cellHeight];
}

@end
