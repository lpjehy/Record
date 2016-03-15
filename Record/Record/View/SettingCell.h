//
//  SettingCell.h
//  Record
//
//  Created by Jehy Fan on 16/3/9.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *SettingCellIdentifier = @"SettingCellIdentifier";

typedef NS_ENUM(NSInteger, SettingCellType) {
    SettingCellTypeNormal,//默认从0开始
    SettingCellTypeSwitch,
    SettingCellTypeText
};


@protocol SettingCellDelegate<NSObject>

@optional

// Display customization

- (void)settingCellSwitchChangedForItem:(NSString *)item value:(BOOL)value;
@end;

@interface SettingCell : UITableViewCell

@property(nonatomic) SettingCellType cellType;

@property(nonatomic, strong) NSString *item;
@property(nonatomic, strong) NSString *textValue;
@property(nonatomic, assign) BOOL boolValue;

@property(nonatomic, weak) id<SettingCellDelegate> delegate;

@end
