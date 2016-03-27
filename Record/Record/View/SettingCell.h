//
//  SettingCell.h
//  Record
//
//  Created by Jehy Fan on 16/3/9.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *SettingCellIdentifier = @"SettingCellIdentifier";

#import "SettingItem.h"

@protocol SettingCellDelegate<NSObject>

@optional

// Display customization

- (void)settingCellSwitchChangedForItem:(SettingItem *)item value:(BOOL)value;
@end;

@interface SettingCell : UITableViewCell

@property(nonatomic) SettingType cellType;



@property(nonatomic, weak) id<SettingCellDelegate> delegate;

- (void)setItem:(SettingItem *)item;

@end
