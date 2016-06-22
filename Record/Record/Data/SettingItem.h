//
//  SettingItem.h
//  Record
//
//  Created by Jehy Fan on 16/3/20.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, SettingType) {
    SettingTypeNormal,//默认从0开始
    SettingTypeSwitch,
    SettingTypeText,
    SettingTypeLinkedText,
};

@interface SettingItem : NSObject


@property(nonatomic, strong) NSString *item;
@property(nonatomic, assign) SettingType type;
@property(nonatomic, strong) NSString *textValue;
@property(nonatomic, strong) NSString *linkedText;
@property(nonatomic, assign) BOOL boolValue;
@property(nonatomic, assign) BOOL enable;


@end
