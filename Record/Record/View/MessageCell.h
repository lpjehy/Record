//
//  MessageCell.h
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Message.h"


static NSString *MessageCellCellIdentifier = @"MessageCellCellIdentifier";

@interface MessageCell : UITableViewCell



- (void)setMessage:(Message *)message;

@end
