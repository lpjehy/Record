//
//  SettingViewController.m
//  Record
//
//  Created by Jehy Fan on 16/3/3.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "SettingViewController.h"
#import "AudioManager.h"

#import "SettingCell.h"
#import "ReminderManager.h"
#import "ScheduleManager.h"

#import "OnlineConfigUtil.h"

#import "TextEditViewController.h"
#import "WebViewController.h"
#import "SoundsViewController.h"
#import "LanguagesViewController.h"



@import GoogleMobileAds;



#import "SettingItem.h"

#import "AdManager.h"

typedef NS_ENUM(NSInteger, PickerType) {
    PickerTypePillDays,//默认从0开始
    PickerTypeBreakDays,
    PickerTypeStartDate,
    PickerTypeNotifyTime};

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate, SettingCellDelegate, TextEditViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate> {
    UITableView *mainTableView;
    
    UIPickerView *numberPickerView;
    UIButton *doneButton;
    UIButton *cancelButton;
    
    PickerType currentPickerType;
    
    
    NSMutableArray *moduleArray;
    NSMutableDictionary *moduleDic;
    
    
    
}

@property(nonatomic, strong) NSString *appID;

@property(nonatomic) NSInteger initialPillsDay;
@property(nonatomic) NSInteger initialBreakDay;
@property(nonatomic, strong) NSString *initialStartDate;

@property(nonatomic) NSInteger finalPillsDay;
@property(nonatomic) NSInteger finalBreakDay;
@property(nonatomic, strong) NSString *finalStartDate;

@end


static NSString *Setting_Item_TakeEveryday = @"Setting_Item_TakeEveryday";
static NSString *Setting_Item_PillDays = @"Setting_Item_PillDays";
static NSString *Setting_Item_BreakDays = @"Setting_Item_BeakDays";
static NSString *Setting_Item_TakePlaceboPills = @"Setting_Item_TakePlaceboPills";
static NSString *Setting_Item_StartDay = @"Setting_Item_StartDay";
static NSString *Setting_Item_RemindTakePill = @"Setting_Item_RemindTakePill";
static NSString *Setting_Item_RemindTakePlaceboPill = @"Setting_Item_RmindTakePlaceboPill";
static NSString *Setting_Item_NotifyAlertBody = @"Setting_Item_NotifyAlertBody";
static NSString *Setting_Item_NotifyTime = @"Setting_Item_NotifyTime";
static NSString *Setting_Item_NotifySound = @"Setting_Item_NotifySound";
static NSString *Setting_Item_Language = @"Setting_Item_Language";
static NSString *Setting_Item_CheerUs = @"Setting_Item_CheerUs";

@implementation SettingViewController

@synthesize appID;

@synthesize initialPillsDay, initialBreakDay, initialStartDate;
@synthesize finalPillsDay, finalBreakDay, finalStartDate;


- (id)init {
    self = [super init];
    if (self) {
        self.appID = [OnlineConfigUtil getValueForKey:OnlineConfig_AppId];
        
        moduleArray = [[NSMutableArray alloc] init];
        moduleDic = [[NSMutableDictionary alloc] init];
        
        self.initialPillsDay = [ScheduleManager pillDays];
        self.finalPillsDay = initialPillsDay;
        
        self.initialBreakDay = [ScheduleManager breakDays];
        self.finalBreakDay = initialBreakDay;
        
        self.initialStartDate = [ScheduleManager startDate].string;
        self.finalStartDate = initialStartDate;
    }
    
    return self;
}

- (void)dealloc {
    GADBannerView *bannerView = [AdManager settingView];
    [bannerView removeFromSuperview];
    bannerView.rootViewController = nil;
}

- (void)reloadView {
    [moduleArray removeAllObjects];
    [moduleDic removeAllObjects];
    
    NSMutableArray *array = [NSMutableArray array];
    
    SettingItem *item = [[SettingItem alloc] init];
    item.item = Setting_Item_TakeEveryday;
    item.type = SettingTypeSwitch;
    
    BOOL isEveryDay = [ScheduleManager isEveryday];
    item.boolValue = isEveryDay;
    item.enable = YES;
    [array addObject:item];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_PillDays;
    item.type = SettingTypeText;
    
    
    item.textValue = [NSString stringWithFormat:@"%zi %@", finalPillsDay, LocalizedString(@"day")];
    item.enable = !isEveryDay;
    [array addObject:item];
    
    
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_BreakDays;
    item.type = SettingTypeText;
    item.textValue = [NSString stringWithFormat:@"%zi %@", finalBreakDay, LocalizedString(@"day")];;
    item.enable = !isEveryDay;
    [array addObject:item];
    
    
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_TakePlaceboPills;
    item.type = SettingTypeSwitch;
    BOOL takePlaceboPills = [ScheduleManager takePlaceboPills];
    item.boolValue = takePlaceboPills;
    item.enable = !isEveryDay;
    [array addObject:item];
    
    
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_StartDay;
    item.type = SettingTypeText;
    
    NSDate *date = finalStartDate.date;
    NSDateComponents *components = date.components;
    NSString *textValue = [NSString stringWithFormat:@"%@ %zi/%zi/%zi", components.weekDayText, components.month, components.day, components.year];
    item.textValue = textValue;
    item.enable = YES;
    [array addObject:item];
    
    
    
    [moduleArray addObject:@"setting_module_schedule"];
    [moduleDic setValue:array forKey:@"setting_module_schedule"];
    
    
    array = [NSMutableArray array];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_RemindTakePill;
    item.type = SettingTypeSwitch;
    
    BOOL should = [ReminderManager shouldRmind];
    item.boolValue = should;
    item.enable = YES;
    [array addObject:item];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_RemindTakePlaceboPill;
    item.type = SettingTypeSwitch;
    
    BOOL alsoRmind = [ReminderManager remindInSafeDays];
    item.boolValue = alsoRmind;
    item.enable = should && takePlaceboPills && !isEveryDay;
    [array addObject:item];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_NotifyAlertBody;
    item.type = SettingTypeText;
    
    NSString *alertBody = [ReminderManager notificationAlertBody];
    item.textValue = alertBody;
    item.enable = should;
    [array addObject:item];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_NotifyTime;
    item.type = SettingTypeText;
    
    NSDate *nofityTime = [ReminderManager notificationTime];
    components = nofityTime.components;
    NSString *daytime = LocalizedString(@"time_am");
    NSInteger hour = components.hour;
    if (hour > 12) {
        hour -= 12;
        daytime = LocalizedString(@"time_pm");
    }
    item.textValue = [NSString stringWithFormat:@"%zi:%zi %@", hour, components.minute, daytime];
    item.enable = should;
    [array addObject:item];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_NotifySound;
    item.type = SettingTypeText;
    
    NSString *sound = [ReminderManager notificationSound];
    if ([sound isEqualToString:UILocalNotificationDefaultSoundName]) {
        sound = SoundNameDefault;
    }
    item.textValue = sound;
    item.enable = should;
    [array addObject:item];
    
    [moduleArray addObject:@"setting_module_reminders"];
    [moduleDic setValue:array forKey:@"setting_module_reminders"];
    
    
    array = [NSMutableArray array];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_Language;
    item.type = SettingTypeText;
    item.enable = YES;
    
    item.textValue = [LanguageManager languageName:[LanguageManager language]];
    
    [array addObject:item];
    
    if (appID && ![appID isEqualToString:@"0"]) {
        item = [[SettingItem alloc] init];
        item.item = Setting_Item_CheerUs;
        item.type = SettingTypeNormal;
        item.enable = YES;
        [array addObject:item];
        
        
        
    }
    
    [moduleArray addObject:@"setting_module_others"];
    [moduleDic setValue:array forKey:@"setting_module_others"];
    /**/
    
    [mainTableView reloadData];
}



- (void)closeButtonPressed {
    
    BOOL nochange = (initialPillsDay == finalPillsDay)
    && (initialBreakDay == finalBreakDay)
    && [initialStartDate isEqualToString:finalStartDate];
    
    if ([AppManager hasFirstSetDone] && nochange) {
        
        [self finishSetting];
    } else {
        if (![AppManager hasFirstSetDone]) {
            [AnalyticsUtil event:Event_First_Set_Done];
        }
        
        
        NSString *text = LocalizedString(@"business_breakdays");
        if ([ScheduleManager takePlaceboPills]) {
            text = LocalizedString(@"business_placebo_pilldays");
        }
        
        if (finalBreakDay > 1 && ![LanguageManager isZH_Han]) {
            text = [text stringByAppendingString:@"s"];
        }
        
        NSString *message = [NSString stringWithFormat:LocalizedString(@"message_day_confirm_setting"), finalPillsDay, finalBreakDay, text];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:LocalizedString(@"button_title_cancel")
                                                  otherButtonTitles:LocalizedString(@"button_title_yes"), nil];
        [alertView show];
    }
}


- (void)finishSetting {
    [self dismiss];
    
    

}

#pragma mark - picker

- (void)pikcerDoneButtonPressed {
    
    doneButton.hidden = YES;
    cancelButton.hidden = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.24];
    numberPickerView.originY = ScreenHeight + 32;
    
    [UIView commitAnimations];
    
    numberPickerView.tag = 0;
}

- (void)pickerConfirmButtonPressed {
    
    NSInteger row = [numberPickerView selectedRowInComponent:0];
    if (currentPickerType == PickerTypePillDays) {
        
        self.finalPillsDay = row + 5;
        
    } else if (currentPickerType == PickerTypeBreakDays) {
        
        self.finalBreakDay = row + 1;
        
    } else if (currentPickerType == PickerTypeStartDate) {
        NSInteger year = [numberPickerView selectedRowInComponent:3] + 2000;
        NSInteger month = [numberPickerView selectedRowInComponent:1] + 1;
        NSInteger day = [numberPickerView selectedRowInComponent:2] + 1;
        
        NSString *dateString = [NSString stringWithFormat:@"%zi-%02zi-%02zi 00:00:00.0", year, month, day];
        NSDate *theDate = dateString.date;
        if (!theDate.isEarlier) {
            theDate = [NSDate date].dayDate;
        }
        
        self.finalStartDate = theDate.string;
        
    } else if (currentPickerType == PickerTypeNotifyTime) {
        NSInteger hour = [numberPickerView selectedRowInComponent:1];
        NSInteger minute = [numberPickerView selectedRowInComponent:2];
        NSInteger row = [numberPickerView selectedRowInComponent:3];
        if (row == 1) {
            hour += 12;
        }
        
        NSString *dateString = [NSString stringWithFormat:@"%02zi:%02zi", hour, minute];
        
        [ReminderManager setNotificationTime:dateString];
        
        
    }
    
    [self reloadView];
    
    
    [self pikcerDoneButtonPressed];
    
    
}


- (void)showPickerView {
    [self createPickerView];
    
    doneButton.hidden = NO;
    cancelButton.hidden = NO;
    
    [numberPickerView reloadAllComponents];
    
    if (currentPickerType == PickerTypePillDays) {
        [numberPickerView selectRow:[ScheduleManager pillDays] - 5 inComponent:0 animated:NO];
    } else if (currentPickerType == PickerTypeBreakDays) {
        [numberPickerView selectRow:[ScheduleManager breakDays] - 1 inComponent:0 animated:NO];
    } else if (currentPickerType == PickerTypeStartDate) {
        NSDate *date = [ScheduleManager startDate];
        NSDateComponents *components = date.components;
        
        
        [numberPickerView selectRow:components.month - 1 inComponent:1 animated:NO];
        [numberPickerView selectRow:components.day - 1 inComponent:2 animated:NO];
        [numberPickerView selectRow:components.year - 2000 inComponent:3 animated:NO];
    } else if (currentPickerType == PickerTypeNotifyTime) {
        NSDate *date = [ReminderManager notificationTime];
        NSDateComponents *components = date.components;
        NSInteger hour = components.hour;
        if (hour > 12) {
            hour -= 12;
            [numberPickerView selectRow:1 inComponent:3 animated:NO];
        }
        [numberPickerView selectRow:hour inComponent:1 animated:NO];
        [numberPickerView selectRow:components.minute inComponent:2 animated:NO];
        
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.24];
    
    numberPickerView.originY = ScreenHeight - numberPickerView.height;
    
    [UIView commitAnimations];
    
    numberPickerView.tag = 1;
}


- (void)createPickerView {
    if (numberPickerView == nil) {
        
        doneButton = [[UIButton alloc] init];
        doneButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        doneButton.hidden = YES;
        [doneButton addTarget:self action:@selector(pickerConfirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:doneButton];
        
        numberPickerView = [[UIPickerView alloc] init];
        numberPickerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 216.0);
        numberPickerView.delegate = self;
        numberPickerView.dataSource = self;
        numberPickerView.backgroundColor = [UIColor whiteColor];
        numberPickerView.clipsToBounds = NO;
        [self.view addSubview:numberPickerView];
        
        
        UIView *buttonView = [[UIView alloc] init];
        
        buttonView.backgroundColor = [UIColor whiteColor];
        buttonView.frame = CGRectMake(0, -32, ScreenWidth, 44);
        [numberPickerView addSubview:buttonView];
        
        UILabel *cancelLabel = [[UILabel alloc] init];
        cancelLabel.text = LocalizedString(@"button_title_cancel");
        cancelLabel.frame = CGRectMake(10, 0, 128, 44);
        [buttonView addSubview:cancelLabel];
        
        UILabel *confirmLabel = [[UILabel alloc] init];
        confirmLabel.text = LocalizedString(@"button_title_done");
        confirmLabel.frame = CGRectMake(ScreenWidth - 138, 0, 128, 44);
        confirmLabel.textAlignment = NSTextAlignmentRight;
        [buttonView addSubview:confirmLabel];
        
        
        cancelButton = [[UIButton alloc] init];
        [cancelButton addTarget:self action:@selector(pikcerDoneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.hidden = YES;
        cancelButton.frame = CGRectMake(0, ScreenHeight - numberPickerView.height - 44, 64, 44);
        [doneButton addSubview:cancelButton];
    }
}


#pragma mark - layout

- (void)createLayout {
    [self.navigationController setNavigationBarHidden:YES];
    
    UIButton *rightButton = [[UIButton alloc] init];
    rightButton.frame = CGRectMake(ScreenWidth - 64, 20, 64, 44);
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [rightButton setTitle:LocalizedString(@"button_title_done") forState:UIControlStateNormal];
    
    
    rightButton.titleLabel.font = FontNormal;
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:rightButton];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = LocalizedString(@"navigation_title_setting");
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.frame = CGRectMake(64, 20, ScreenWidth - 128, 44);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    self.view.backgroundColor = [UIColor colorWithWhite:68 / 255.0 alpha:1];
    
    
    CGFloat currentY = 64;
    
    
    
    if ([AppManager hasFirstSetDone]) {
        GADBannerView *bannerView = [AdManager settingView];
        
        bannerView.rootViewController = self;
        
        [self.view addSubview:bannerView];
        
        
        currentY += 64;
    }
    
    
    
    mainTableView = [[UITableView alloc] init];
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.frame = CGRectMake(0, currentY, ScreenWidth, ScreenHeight - currentY);
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![AppManager hasFirstSetDone]) {
        
        
        
        [ScheduleManager setTakePlaceboPills:YES];
        
        [ReminderManager setShouldRmind:YES];
        [ReminderManager setRemindInSafeDays:YES];
        
    }
    
    
    [self createLayout];
    
    /**/
    BOOL hideAnimated = YES;
    [self.navigationController setNavigationBarHidden:YES animated:hideAnimated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    [self reloadView];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingCellSwitchChangedForItem:(SettingItem *)item value:(BOOL)value {
    
    
    if ([item.item isEqualToString:Setting_Item_TakeEveryday]) {
        if (value) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:LocalizedString(@"alert_message_takepilleveryday")
                                                               delegate:self
                                                      cancelButtonTitle:LocalizedString(@"button_title_cancel")
                                                      otherButtonTitles:LocalizedString(@"button_title_yes"), nil];
            alertView.tag = value;
            [alertView show];
            
            return;
        } else {
            [ScheduleManager setIsEveryday:value];
        }
        
        
    } else if ([item.item isEqualToString:Setting_Item_TakePlaceboPills]) {
        [ScheduleManager setTakePlaceboPills:value];
        
        if (value) {
            if ([ReminderManager shouldRmind]) {
                [ReminderManager setRemindInSafeDays:YES];
            }
        } else {
            [ReminderManager setRemindInSafeDays:NO];
        }
        
    } else if ([item.item isEqualToString:Setting_Item_RemindTakePill]) {
        [ReminderManager setShouldRmind:value];
        
        if (!value) {
            [ReminderManager setRemindInSafeDays:NO];
        }
    } else if ([item.item isEqualToString:Setting_Item_RemindTakePlaceboPill]) {
        [ReminderManager setRemindInSafeDays:value];
    }
    
    [self reloadView];
}

- (void)textEditViewTextChanged:(NSString *)text {
    [ReminderManager setNotificationAlertBody:text];
    [self reloadView];
}

#pragma mark - UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger number = 0;
    
    if (currentPickerType == PickerTypePillDays || currentPickerType == PickerTypeBreakDays) {
        number = 1;
    } else if (currentPickerType == PickerTypeStartDate) {
        number = 5;
    } else if (currentPickerType == PickerTypeNotifyTime) {
        number = 5;
    }
    
    return number;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger number = 0;
    if (currentPickerType == PickerTypePillDays) {
        number = MaxPillDays - 4;
    } else if (currentPickerType == PickerTypeBreakDays) {
        number = MaxBreakDays;
    } else if (currentPickerType == PickerTypeStartDate) {
        if (component == 1) {
            
            number = 12;
        } else if (component == 2) {
            if (pickerView.tag == 0) {
                NSDateComponents *date = [ScheduleManager startDate].components;
                
                number = [NSDateComponents numberOfDaysInMonth:date.month year:date.year];
            } else {
                NSInteger month = [pickerView selectedRowInComponent:1] + 1;
                NSInteger year = [pickerView selectedRowInComponent:3] + 2000;
                number = [NSDateComponents numberOfDaysInMonth:month year:year];
            }
            
        } else if (component == 3) {
            number = [NSDate date].components.year - 2000 + 1;
        }
        
    } else if (currentPickerType == PickerTypeNotifyTime) {
        if (component == 1) {
            number = 12;
        } else if (component == 2) {
            number = 60;
        } else if (component == 3) {
            number = 2;
        }
        
    }
    
    return number;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = nil;
    if (currentPickerType == PickerTypePillDays) {
        title = [NSString stringWithInteger:row + 5];
        
    } else if (currentPickerType == PickerTypeBreakDays) {
        title = [NSString stringWithInteger:row + 1];
    } else if (currentPickerType == PickerTypeStartDate) {
        if (component == 1) {
            
            title = [NSDateComponents descriptionOfMonth:row + 1];
        } else if (component == 2) {
            
            
            title = [NSString stringWithFormat:@"%zi", row + 1];
        } else if (component == 3) {
            title = [NSString stringWithFormat:@"%zi", row + 2000];
        }
        
    } else if (currentPickerType == PickerTypeNotifyTime) {
        if (component == 1) {
            title = [NSString stringWithFormat:@"%zi", row];
        } else if (component == 2) {
            title = [NSString stringWithFormat:@"%zi", row];
        } else if (component == 3) {
            if (row == 0) {
                title = LocalizedString(@"time_am");
            } else {
                title = LocalizedString(@"time_pm");
            }
        }
        
    }
    
    return title;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 64;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (currentPickerType == PickerTypePillDays) {
        
    } else if (currentPickerType == PickerTypeBreakDays) {
        
    } else if (currentPickerType == PickerTypeStartDate) {
        [pickerView reloadComponent:2];
        
    } else if (currentPickerType == PickerTypeNotifyTime) {
        
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return moduleArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UIView *headerView = [[UIView alloc] init];

    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = [moduleArray validObjectAtIndex:section];
    NSArray *itemArray = [moduleDic validObjectForKey:key];
    return itemArray.count + 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if(nil == cell) {
            cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            cell.textLabel.textColor = [UIColor colorWithWhite:161 / 255.0 alpha:1];
            cell.textLabel.font = FontMiddle;
            
            
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(15, 44, ScreenWidth, 0.5);
            lineView.backgroundColor = ColorGrayDark;
            [cell.contentView addSubview:lineView];
        }
        
        
        NSString *title = LocalizedString([moduleArray validObjectAtIndex:indexPath.section]);
        cell.textLabel.text = title;
        
        
        return cell;
        
    }
    
    
    SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:SettingCellIdentifier];
    if(nil == cell) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SettingCellIdentifier];
        cell.delegate = self;
    }
    
    NSString *key = [moduleArray validObjectAtIndex:indexPath.section];
    NSArray *itemArray = [moduleDic validObjectForKey:key];
    SettingItem *item = [itemArray validObjectAtIndex:indexPath.row - 1];
    
    [cell setItem:item];
    
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = [moduleArray validObjectAtIndex:indexPath.section];
    NSArray *itemArray = [moduleDic validObjectForKey:key];
    SettingItem *item = [itemArray validObjectAtIndex:indexPath.row - 1];
    
    if (!item.enable) {
        return;
    }
    
    if ([item.item isEqualToString:Setting_Item_PillDays]) {
        
        currentPickerType = PickerTypePillDays;
        [self showPickerView];
        
    } else if ([item.item isEqualToString:Setting_Item_BreakDays]) {

        currentPickerType = PickerTypeBreakDays;
        [self showPickerView];
    
    
    } else if ([item.item isEqualToString:Setting_Item_StartDay]) {
        
        currentPickerType = PickerTypeStartDate;
        [self showPickerView];
        
    } else if ([item.item isEqualToString:Setting_Item_NotifyAlertBody]) {
        
        TextEditViewController *textEditViewController = [[TextEditViewController alloc] init];
        textEditViewController.text = [ReminderManager notificationAlertBody];
        textEditViewController.delegate = self;
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:textEditViewController];
        
        [self presentViewController:navController animated:YES completion:NULL];
        
        
    } else if ([item.item isEqualToString:Setting_Item_NotifyTime]) {
        
        currentPickerType = PickerTypeNotifyTime;
        [self showPickerView];
        
    } else if ([item.item isEqualToString:Setting_Item_NotifySound]) {
        
        SoundsViewController *soundsViewController = [[SoundsViewController alloc] init];
        
        
        [self.navigationController pushViewController:soundsViewController animated:YES];
        
    } else if ([item.item isEqualToString:Setting_Item_CheerUs]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appID]]];
        
    } else if ([item.item isEqualToString:Setting_Item_Language]) {
        
        LanguagesViewController *languagesViewController = [[LanguagesViewController alloc] init];
        
        [self.navigationController pushViewController:languagesViewController animated:YES];
        
    }

    
    
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:LocalizedString(@"button_title_yes")]) {
        
        if ([alertView.message isEqualToString:LocalizedString(@"alert_message_takepilleveryday")]) {
            //take everyday
            [ScheduleManager setIsEveryday:alertView.tag];
            
            [ScheduleManager setTakePlaceboPills:YES];
            
            BOOL shouldRminder = [ReminderManager shouldRmind];
            [ReminderManager setRemindInSafeDays:shouldRminder];
            
            
            [self reloadView];
            
        } else {
            
            //完成设置
            [self finishSetting];
            
            
            
            if (![AppManager hasFirstSetDone]) {
                //ios8  注册本地通知
                if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
                    UIUserNotificationSettings *noteSetting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                               | UIUserNotificationTypeBadge
                                                               | UIUserNotificationTypeSound
                                                                                                categories:nil];
                    [[UIApplication sharedApplication] registerUserNotificationSettings:noteSetting];
                }
            }
            
            
            [AppManager setFirstSetDone];
            
            [ScheduleManager setPillDays:finalPillsDay
                               breakDays:finalBreakDay
                               startDate:finalStartDate.date];
            
            NSDate *finalDate = finalStartDate.date;
            NSDate *initialDate = initialStartDate.date;
            if ([finalDate isEarlierThan:initialDate]) {
                [[ScheduleManager getInstance] resetRecordFrom:finalDate toDate:initialDate];
            }
            
            [NotificationCenter postNotificationName:SettingChangedNotification object:nil];
            
        }
        
    } else {
        if ([alertView.message isEqualToString:LocalizedString(@"alert_message_takepilleveryday")]) {
            [ScheduleManager setIsEveryday:NO];
            [self reloadView];
            
        }
    }
}

@end
