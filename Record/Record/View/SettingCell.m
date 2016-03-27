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
    UIImageView *accessImageView;
    UISwitch *valueSwitch;
    
    
}

@property(nonatomic, strong) SettingItem *currentItem;

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
        itemLabel.font = FontSmall;
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

- (void)setCellType:(SettingType)type {
    if (type == SettingTypeNormal) {
        valueLabel.hidden = YES;
        accessImageView.hidden = YES;
        
        valueSwitch.hidden = YES;
    } else if (type == SettingTypeSwitch) {
        valueLabel.hidden = YES;
        accessImageView.hidden = YES;
        
        [self createSwitchView];
        valueSwitch.hidden = NO;
    } else if (type == SettingTypeText) {
        [self createTextView];
        valueLabel.hidden = NO;
        accessImageView.hidden = NO;
        
        valueSwitch.hidden = YES;
    }
}


-(void)switchAction
{
    BOOL boolValue = valueSwitch.on;
    if ([delegate respondsToSelector:@selector(settingCellSwitchChangedForItem:value:)]) {
        [delegate settingCellSwitchChangedForItem:self.currentItem value:boolValue];
    }
}

- (void)createSwitchView {
    if (valueSwitch == nil) {
        valueSwitch = [[UISwitch alloc] init];
        [valueSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
        valueSwitch.frame = CGRectMake(ScreenWidth - 64, 6, 40, 32);
        [self.contentView addSubview:valueSwitch];
    }
}

- (void)createTextView {
    if (valueLabel == nil) {
        valueLabel = [[UILabel alloc] init];
        valueLabel.textAlignment = NSTextAlignmentRight;
        valueLabel.frame = CGRectMake(ScreenWidth - 148, 6, 128, 32);
        valueLabel.font = FontSmall;
        valueLabel.textColor = ColorTextGray;
        [self.contentView addSubview:valueLabel];
        
        accessImageView = [[UIImageView alloc] init];
        accessImageView.backgroundColor = [UIColor grayColor];
        accessImageView.frame = CGRectMake(ScreenWidth - 20, 10, 5, 24);
        [self.contentView addSubview:accessImageView];
    }
}

- (void)setItem:(SettingItem *)item {
    self.currentItem = item;
    
    
    itemLabel.text = NSLocalizedString(item.item, nil);
    
    
    self.cellType = item.type;
    
    if (item.textValue) {
        valueLabel.text = item.textValue;
        CGFloat textWidth = [valueLabel textSize].width;
        CGFloat maxWidth = ScreenWidth - itemLabel.textSize.width - itemLabel.originX - 50;
        if (textWidth > maxWidth) {
            textWidth = maxWidth;
            
        }
        
        valueLabel.originX = ScreenWidth - 25 - textWidth;
        valueLabel.width = textWidth;
    }
    
    
    valueSwitch.on = item.boolValue;
    
    if (item.enable) {
        valueSwitch.enabled = YES;
        valueLabel.textColor = [UIColor whiteColor];
    } else {
        valueSwitch.enabled = NO;
        valueLabel.textColor = ColorTextGray;
    }
    
    
    if (cellType == SettingTypeNormal) {
        
    } else if (cellType == SettingTypeSwitch) {
        
    } else if (cellType == SettingTypeText) {
        
    }
}



@end
