//
//  SettingOpenNotifyCell.m
//  Reminder
//
//  Created by Jehy Fan on 16/6/11.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "SettingOpenNotifyCell.h"


@interface SettingOpenNotifyCell() {
    
    UILabel *itemLabel;
    UILabel *subTitleLabel;
    
    UIImageView *firstIconImageView;
    UILabel *openLabel;
    UIButton *settingButton;
    
    UIImageView *secondIconImageView;
    UILabel *selectLabel;
    UILabel *notificationLabel;
    
    UIImageView *thirdIconImageView;
    UILabel *thirdLabel;
}

@end

@implementation SettingOpenNotifyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    // Initialization code
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *alertImageView = [[UIImageView alloc] init];
        alertImageView.image = [UIImage imageNamed:@"Icon_alert.png"];
        alertImageView.frame = CGRectMake(15, 8, 27, 27);
        
        [self.contentView addSubview:alertImageView];
        
        itemLabel = [[UILabel alloc] init];
        itemLabel.textColor = [UIColor whiteColor];
        itemLabel.font = FontNormal;
        itemLabel.adjustsFontSizeToFitWidth = YES;
        itemLabel.minimumScaleFactor = 0.7;
        itemLabel.frame = CGRectMake(55, 0, ScreenWidth - 55, 44);
        [self.contentView addSubview:itemLabel];
        
        CGFloat currentY = 44;
        
        subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.textColor = [UIColor whiteColor];
        subTitleLabel.font = FontNormal;
        subTitleLabel.adjustsFontSizeToFitWidth = YES;
        subTitleLabel.minimumScaleFactor = 0.7;
        subTitleLabel.numberOfLines = 2;
        subTitleLabel.frame = CGRectMake(15, currentY, ScreenWidth - 30, 44);
        subTitleLabel.text = LocalizedString(@"Setting_Item_Auth_Guide_Subtitle");
        [self.contentView addSubview:subTitleLabel];
        
        currentY += 44;
        
        firstIconImageView = [[UIImageView alloc] init];
        firstIconImageView.image = [UIImage imageNamed:@"Icon_guide-1.png"];
        firstIconImageView.frame = CGRectMake(15, currentY + 8, 28, 28);
        
        [self.contentView addSubview:firstIconImageView];
        
        
        openLabel =  [[UILabel alloc] init];
        openLabel.frame = CGRectMake(55, currentY, ScreenWidth - 70, 44);
        openLabel.font = FontNormal;
        openLabel.textColor = [UIColor whiteColor];
        openLabel.text = LocalizedString(@"Setting_Item_Auth_Guide_Step1_Open");
        [self.contentView addSubview:openLabel];
        
        settingButton =  [[UIButton alloc] init];
        [settingButton addTarget:self action:@selector(settingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        settingButton.titleLabel.font = FontNormal;
        [settingButton setTitleColor:[UIColor colorWithR:80 g:227 b:194 a:1] forState:UIControlStateNormal];
        [settingButton setTitle:LocalizedString(@"Setting_Item_Auth_Guide_Step1_Setting") forState:UIControlStateNormal];
        settingButton.frame = CGRectMake(openLabel.originX + openLabel.textSize.width, currentY, settingButton.titleSize.width, 44);
        [self.contentView addSubview:settingButton];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithR:80 g:227 b:194 a:1];
        lineView.frame = CGRectMake(0, (44 + settingButton.titleLabel.font.lineHeight) / 2, settingButton.titleSize.width, 1);
        [settingButton addSubview:lineView];
        
        currentY += 44;
        
        
        secondIconImageView = [[UIImageView alloc] init];
        secondIconImageView.image = [UIImage imageNamed:@"Icon_guide-2.png"];
        secondIconImageView.frame = CGRectMake(15, currentY + 8, 28, 28);
        
        [self.contentView addSubview:secondIconImageView];
        
        
        selectLabel =  [[UILabel alloc] init];
        selectLabel.frame = CGRectMake(55, currentY, ScreenWidth - 70, 44);
        selectLabel.font = FontNormal;
        selectLabel.textColor = [UIColor whiteColor];
        selectLabel.text = LocalizedString(@"Setting_Item_Auth_Guide_Step2_Choose");
        [self.contentView addSubview:selectLabel];
        
        notificationLabel =  [[UILabel alloc] init];
        notificationLabel.font = [UIFont boldSystemFontOfSize:14];
        notificationLabel.textColor = [UIColor whiteColor];
        notificationLabel.text = LocalizedString(@"Setting_Item_Auth_Guide_Step2_Notification");
        notificationLabel.frame = CGRectMake(selectLabel.originX + selectLabel.textSize.width, currentY, notificationLabel.textSize.width, 44);
        [self.contentView addSubview:notificationLabel];
        
        currentY += 44;
        
        thirdIconImageView = [[UIImageView alloc] init];
        thirdIconImageView.image = [UIImage imageNamed:@"Icon_guide-3.png"];
        thirdIconImageView.frame = CGRectMake(15, currentY + 13, 28, 17);
        
        [self.contentView addSubview:thirdIconImageView];
        
        thirdLabel = [[UILabel alloc] init];
        thirdLabel.textColor = [UIColor whiteColor];
        thirdLabel.font = FontNormal;
        thirdLabel.adjustsFontSizeToFitWidth = YES;
        thirdLabel.minimumScaleFactor = 0.7;
        thirdLabel.frame = CGRectMake(55, currentY, ScreenWidth - 70, 44);
        thirdLabel.text = LocalizedString(@"Setting_Item_Auth_Guide_Step3");
        [self.contentView addSubview:thirdLabel];
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)settingButtonPressed {
    if ([self.delegate respondsToSelector:@selector(settingCellLinkClickedForItem:)]) {
        [self.delegate settingCellLinkClickedForItem:self.currentItem];
    }
}




- (void)setItem:(SettingItem *)item {
    self.currentItem = item;
    
    
    itemLabel.text = LocalizedString(item.item);
    
    
    
    
    
    
}

+ (CGFloat)cellHeight {
    return 5 * 44;
}
@end
