//
//  SettingCell.m
//  Record
//
//  Created by Jehy Fan on 16/3/9.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "SettingCell.h"



@interface SettingCell() {
    UILabel *itemLabel;
    UILabel *valueLabel;
    UISwitch *valueSwitch;
    
}



@end

@implementation SettingCell

@synthesize cellType;

@synthesize currentItem;

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    // Initialization code
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        itemLabel = [[UILabel alloc] init];
        itemLabel.textColor = [UIColor whiteColor];
        itemLabel.font = FontNormal;
        itemLabel.adjustsFontSizeToFitWidth = YES;
        itemLabel.minimumScaleFactor = 0.7;
        itemLabel.frame = CGRectMake(15, 0, ScreenWidth * GoldenSectionPoint, 44);
        [self.contentView addSubview:itemLabel];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return 44;
}

- (void)setCellType:(SettingType)type {
    cellType = type;
    if (type == SettingTypeNormal) {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        valueLabel.hidden = YES;
        valueSwitch.hidden = YES;
        
    } else if (type == SettingTypeSwitch) {
        
        self.accessoryType = UITableViewCellAccessoryNone;
        
        valueLabel.hidden = YES;
        
        [self createSwitchView];
        valueSwitch.hidden = NO;
        
        itemLabel.width = valueSwitch.originX - 25;
        
    } else if (type == SettingTypeText) {
        [self createTextView];
        valueLabel.hidden = NO;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        valueSwitch.hidden = YES;
        
    }
    
}


#pragma mark - actions
-(void)switchAction
{
    BOOL boolValue = valueSwitch.on;
    if ([delegate respondsToSelector:@selector(settingCellSwitchChangedForItem:value:)]) {
        [delegate settingCellSwitchChangedForItem:self.currentItem value:boolValue];
    }
}


#pragma mark - layout
- (void)createSwitchView {
    if (valueSwitch == nil) {
        valueSwitch = [[UISwitch alloc] init];
        [valueSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
        if (ISPad) {
            valueSwitch.frame = CGRectMake(ScreenWidth - 96, 6, 40, 32);
        } else {
            valueSwitch.frame = CGRectMake(ScreenWidth - 64, 6, 40, 32);
        }
        
        [self.contentView addSubview:valueSwitch];
    }
}

- (void)createTextView {
    if (valueLabel == nil) {
        valueLabel = [[UILabel alloc] init];
        valueLabel.textAlignment = NSTextAlignmentRight;
        valueLabel.frame = CGRectMake(ScreenWidth - 156, 6, 128, 32);
        valueLabel.font = FontNormal;
        valueLabel.adjustsFontSizeToFitWidth = YES;
        valueLabel.minimumScaleFactor = 0.7;
        valueLabel.textColor = ColorTextGray;
        [self.contentView addSubview:valueLabel];
        
    }
}



- (void)setItem:(SettingItem *)item {
    self.currentItem = item;
    
    
    itemLabel.text = LocalizedString(item.item);
    
    
    self.cellType = item.type;
    
    if (item.enable) {
        itemLabel.textColor = [UIColor whiteColor];
        valueSwitch.enabled = YES;
        valueLabel.textColor = [UIColor whiteColor];
    } else {
        itemLabel.textColor = ColorTextGray;
        valueSwitch.enabled = NO;
        valueLabel.textColor = ColorTextGray;
    }
    
    
    if (cellType == SettingTypeNormal) {
        
        
        
    } else if (cellType == SettingTypeSwitch) {
        valueSwitch.on = item.boolValue;
        
    } else if (cellType == SettingTypeText) {
        if (item.textValue) {
            valueLabel.text = item.textValue;
            CGFloat textWidth = [valueLabel textSize].width;
            CGFloat maxWidth = ScreenWidth - itemLabel.textSize.width - itemLabel.originX - 44;
            if (textWidth > maxWidth) {
                textWidth = maxWidth;
                
            }
            
            if (ISPad) {
                valueLabel.originX = ScreenWidth - 64 - textWidth;
            } else {
                valueLabel.originX = ScreenWidth - 28 - textWidth;
            }
            
            
            valueLabel.width = textWidth;
        }

        
    }
    
    
}



@end
