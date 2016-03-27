//
//  SqlUtil.h
//  Record
//
//  Created by Jehy Fan on 16/3/3.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SqlUtil : NSObject

+ (SqlUtil *)getInstance;


- (BOOL)execSql:(NSString *)sql;



- (NSArray *)selectWithSql:(NSString *)sql;

@end
