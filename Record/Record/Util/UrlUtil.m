//
//  UrlUtil.m
//  Record
//
//  Created by Jehy Fan on 16/3/12.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "UrlUtil.h"

@implementation UrlUtil


+ (void)openUrl:(NSString *)url {
    if (![NSString isEmpty:url]) {
        
        
        if ([url hasPrefix:@"reminder://"]) {
            [UrlUtil dealAppUrl:url];
        } else {
            //[ViewControllerManager openWeb:url];
        }
    }

}

+ (void)dealAppUrl:(NSString *)url {
    
}

@end
