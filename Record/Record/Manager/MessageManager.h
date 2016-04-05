//
//  MessageManager.h
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MessageManager : NSObject <UITableViewDataSource>

+ (void)createMessage:(NSString *)content;
+ (NSArray *)selectAllMessage;
+ (void)deleteMessage:(NSString *)serialid;

+ (MessageManager *)getInstance;

- (void)reloadData;
- (NSArray *)allMessage;

@end
