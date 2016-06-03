//
//  Message.h
//  Record
//
//  Created by Jehy Fan on 16/3/6.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property(nonatomic, strong) NSString *serialid;
@property(nonatomic, strong) NSString *time;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, assign) NSInteger state;

@end
