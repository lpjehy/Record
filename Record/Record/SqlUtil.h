//
//  SqlUtil.h
//  Record
//
//  Created by Jehy Fan on 16/3/3.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString *SqlDataTypeInt = @"int";
static NSString *SqlDataTypeText = @"text";

@interface SqlUtil : NSObject

+ (SqlUtil *)getInstance;


- (void)execSql:(NSString *)sql;



- (NSArray *)selectWithSql:(NSString *)sql resultTypes:(NSArray *)types;

@end
