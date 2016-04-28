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
    UIButton *confirmButton;
    
    PickerType currentPickerType;
    
    
    NSMutableArray *moduleArray;
    NSMutableDictionary *moduleDic;
    
    
    
}

@property(nonatomic, strong) NSString *appID;

@property(nonatomic, strong) NSString *initialPillsDay;
@property(nonatomic, strong) NSString *initialBreakDay;
@property(nonatomic, strong) NSString *initialStartDate;

@property(nonatomic, strong) NSString *finalPillsDay;
@property(nonatomic, strong) NSString *finalBreakDay;
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
        
        
    }
    
    return self;
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
    
    NSInteger pillday = [ScheduleManager pillDays];
    item.textValue = [NSString stringWithFormat:@"%zi %@", pillday, NSLocalizedString(@"day", nil)];
    item.enable = YES;
    [array addObject:item];
    
    if (initialPillsDay == nil) {
        self.initialPillsDay = item.textValue;
    }
    
    self.finalPillsDay = item.textValue;
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_BreakDays;
    item.type = SettingTypeText;
    
    NSInteger breakDay = [ScheduleManager breakDays];
    item.textValue = [NSString stringWithFormat:@"%zi %@", breakDay, NSLocalizedString(@"day", nil)];;
    item.enable = YES;
    [array addObject:item];
    
    if (initialBreakDay == nil) {
        self.initialBreakDay = item.textValue;
    }
    
    self.finalBreakDay = item.textValue;
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_TakePlaceboPills;
    item.type = SettingTypeSwitch;
    BOOL takePlaceboPills = [ScheduleManager takePlaceboPills];
    item.boolValue = takePlaceboPills;
    item.enable = !isEveryDay && breakDay != 0;
    [array addObject:item];
    
    
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_StartDay;
    item.type = SettingTypeText;
    
    NSDate *date = [ScheduleManager startDate];
    NSDateComponents *components = date.components;
    NSString *textValue = [NSString stringWithFormat:@"%@ %zi/%zi/%zi", components.weekDayText, components.month, components.day, components.year];
    item.textValue = textValue;
    item.enable = YES;
    [array addObject:item];
    
    if (initialStartDate == nil) {
        self.initialStartDate = item.textValue;
    }
    
    self.finalStartDate = item.textValue;
    
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
    
    if (!should || !takePlaceboPills) {
        alsoRmind = NO;
    }
    item.boolValue = alsoRmind;
    item.enable = should && takePlaceboPills;
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
    item.textValue = [nofityTime stringWithFormat:@"HH:mm"];
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
    
    
    if (appID && ![appID isEqualToString:@"0"]) {
        item = [[SettingItem alloc] init];
        item.item = Setting_Item_CheerUs;
        item.type = SettingTypeNormal;
        item.enable = YES;
        [array addObject:item];
        
        
        [moduleArray addObject:@"setting_module_others"];
        [moduleDic setValue:array forKey:@"setting_module_others"];
    }
    
    [mainTableView reloadData];
}

- (void)finishSetting {
    [self dismiss];
    
    
}

- (void)doneButtonPressed {
    
    doneButton.hidden = YES;
    confirmButton.hidden = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.24];
    numberPickerView.originY = ScreenHeight + 32;
    
    [UIView commitAnimations];
    
    numberPickerView.tag = 0;
}

- (void)showPickerView {
    [self createPickerView];
    
    doneButton.hidden = NO;
    confirmButton.hidden = NO;
    
    [numberPickerView reloadAllComponents];
    
    if (currentPickerType == PickerTypePillDays) {
        [numberPickerView selectRow:[ScheduleManager pillDays] - 5 inComponent:0 animated:NO];
    } else if (currentPickerType == PickerTypeBreakDays) {
        [numberPickerView selectRow:[ScheduleManager breakDays] inComponent:0 animated:NO];
    } else if (currentPickerType == PickerTypeStartDate) {
        NSDate *date = [ScheduleManager startDate];
        NSDateComponents *components = date.components;
        
        
        [numberPickerView selectRow:components.month - 1 inComponent:0 animated:NO];
        [numberPickerView selectRow:components.day - 1 inComponent:1 animated:NO];
        [numberPickerView selectRow:components.year - 2000 inComponent:2 animated:NO];
    } else if (currentPickerType == PickerTypeNotifyTime) {
        NSDate *date = [ReminderManager notificationTime];
        NSDateComponents *components = date.components;
        
        [numberPickerView selectRow:components.hour inComponent:0 animated:NO];
        [numberPickerView selectRow:components.minute inComponent:1 animated:NO];
        
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.24];
    
    numberPickerView.originY = ScreenHeight - numberPickerView.height;
    
    [UIView commitAnimations];
    
    numberPickerView.tag = 1;
}

- (void)confirmButtonPressed {
    
    NSInteger row = [numberPickerView selectedRowInComponent:0];
    if (currentPickerType == PickerTypePillDays) {
        [ScheduleManager setPillDays:row + 5];
        
    } else if (currentPickerType == PickerTypeBreakDays) {
        [ScheduleManager setSafeDays:row];
        
        
    } else if (currentPickerType == PickerTypeStartDate) {
        NSInteger year = [numberPickerView selectedRowInComponent:2] + 2000;
        NSInteger month = [numberPickerView selectedRowInComponent:0] + 1;
        NSInteger day = [numberPickerView selectedRowInComponent:1] + 1;
        
        NSString *dateString = [NSString stringWithFormat:@"%zi-%02zi-%02zi 00:00:00.0", year, month, day];
        
        [ScheduleManager setStartDate:dateString.date];
        
        
    } else if (currentPickerType == PickerTypeNotifyTime) {
        NSInteger hour = [numberPickerView selectedRowInComponent:0];
        NSInteger minute = [numberPickerView selectedRowInComponent:1];
        
        NSString *dateString = [NSString stringWithFormat:@"%02zi:%02zi", hour, minute];
        
        [ReminderManager setNotificationTime:dateString];
        
        
    }
    
    [self reloadView];
    
    
    [self doneButtonPressed];
    
    
}

- (void)createPickerView {
    if (numberPickerView == nil) {
        
        doneButton = [[UIButton alloc] init];
        doneButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        doneButton.hidden = YES;
        [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:doneButton];
        
        numberPickerView = [[UIPickerView alloc] init];
        numberPickerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240);
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
        cancelLabel.text = NSLocalizedString(@"button_title_cancel", nil);
        cancelLabel.frame = CGRectMake(10, 0, 128, 44);
        [buttonView addSubview:cancelLabel];
        
        UILabel *confirmLabel = [[UILabel alloc] init];
        confirmLabel.text = NSLocalizedString(@"button_title_done", nil);
        confirmLabel.frame = CGRectMake(ScreenWidth - 138, 0, 128, 44);
        confirmLabel.textAlignment = NSTextAlignmentRight;
        [buttonView addSubview:confirmLabel];
        
        
        confirmButton = [[UIButton alloc] init];
        [confirmButton addTarget:self action:@selector(confirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        confirmButton.hidden = YES;
        confirmButton.frame = CGRectMake(ScreenWidth - 64 - 10, ScreenHeight - numberPickerView.height - 44, 64, 44);
        [doneButton addSubview:confirmButton];
    }
}

- (void)closeButtonPressed {
    
    BOOL nochange = [initialPillsDay isEqualToString:finalPillsDay]
    && [initialBreakDay isEqualToString:finalBreakDay]
    && [initialStartDate isEqualToString:finalStartDate];
    
    if ([AppManager hasFirstSetDone] && nochange) {
        
        [self finishSetting];
    } else {
        [AppManager setFirstSetDone];
        
        
        NSString *text = NSLocalizedString(@"business_breakdays", nil);
        if ([ScheduleManager takePlaceboPills]) {
            text = NSLocalizedString(@"business_placebo_pilldays", nil);
        }
        
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"message_day_confirm_setting", nil), [ScheduleManager pillDays], [ScheduleManager breakDays], text];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"button_title_confirm", nil)
                                                  otherButtonTitles:NSLocalizedString(@"button_title_cancel", nil), nil];
        [alertView show];
    }
}

- (void)createLayout {
    [self.navigationController setNavigationBarHidden:YES];
    
    UIButton *rightButton = [[UIButton alloc] init];
    rightButton.frame = CGRectMake(ScreenWidth - 64, 20, 64, 44);
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [rightButton setTitle:NSLocalizedString(@"button_title_done", nil) forState:UIControlStateNormal];
    
    
    rightButton.titleLabel.font = FontNormal;
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:rightButton];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"navigation_title_setting", nil);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.frame = CGRectMake(64, 20, ScreenWidth - 128, 44);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    self.view.backgroundColor = [UIColor colorWithWhite:68 / 255.0 alpha:1];
    
    CGFloat currentY = 64;
    
    if ([AppManager hasFirstSetDone]) {
        GADBannerView *bannerView = [[GADBannerView alloc] init];
        bannerView.backgroundColor = [UIColor blackColor];
        bannerView.adUnitID = AdMobUnitIdSetting;
        bannerView.rootViewController = self;
        [bannerView loadRequest:[GADRequest request]];
        bannerView.frame = CGRectMake(0, 64, ScreenWidth, 64);
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
        
        [ReminderManager setShouldRmind:YES];
    }
    
    
    [self createLayout];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**/
    BOOL hideAnimated = YES;
    [self.navigationController setNavigationBarHidden:YES animated:hideAnimated];
    
    
    [self reloadView];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingCellSwitchChangedForItem:(SettingItem *)item value:(BOOL)value {
    
    
    if ([item.item isEqualToString:Setting_Item_TakeEveryday]) {
        [ScheduleManager setIsEveryday:value];
    } else if ([item.item isEqualToString:Setting_Item_TakePlaceboPills]) {
        [ScheduleManager setTakePlaceboPills:value];
    } else if ([item.item isEqualToString:Setting_Item_RemindTakePill]) {
        [ReminderManager setShouldRmind:value];
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
        number = 3;
    } else if (currentPickerType == PickerTypeNotifyTime) {
        number = 2;
    }
    
    return number;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger number = 0;
    if (currentPickerType == PickerTypePillDays) {
        number = MaxPillDays - 4;
    } else if (currentPickerType == PickerTypeBreakDays) {
        number = MaxBreakDays + 1;
    } else if (currentPickerType == PickerTypeStartDate) {
        if (component == 0) {
            
            number = 12;
        } else if (component == 1) {
            if (pickerView.tag == 0) {
                NSDateComponents *date = [ScheduleManager startDate].components;
                
                number = [NSDateComponents numberOfDaysInMonth:date.month year:date.year];
            } else {
                NSInteger month = [pickerView selectedRowInComponent:0] + 1;
                NSInteger year = [pickerView selectedRowInComponent:2] + 2000;
                number = [NSDateComponents numberOfDaysInMonth:month year:year];
            }
            
        } else {
            number = 100;
        }
        
    } else if (currentPickerType == PickerTypeNotifyTime) {
        if (component == 0) {
            number = 24;
        } else if (component == 1) {
            number = 60;
        }
        
    }
    
    return number;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = nil;
    if (currentPickerType == PickerTypePillDays) {
        title = [NSString stringWithInteger:row + 5];
        
    } else if (currentPickerType == PickerTypeBreakDays) {
        title = [NSString stringWithInteger:row];
    } else if (currentPickerType == PickerTypeStartDate) {
        if (component == 0) {
            
            title = [NSString stringWithFormat:@"%zi %@", row + 1, NSLocalizedString(@"date_unit_month", nil)];
        } else if (component == 1) {
            
            
            title = [NSString stringWithFormat:@"%zi %@", row + 1, NSLocalizedString(@"date_unit_day", nil)];
        } else {
            title = [NSString stringWithFormat:@"%zi %@", row + 2000, NSLocalizedString(@"date_unit_year", nil)];
        }
        
    } else if (currentPickerType == PickerTypeNotifyTime) {
        if (component == 0) {
            title = [NSString stringWithFormat:@"%zi %@", row, NSLocalizedString(@"date_unit_hour", nil)];
        } else if (component == 1) {
            title = [NSString stringWithFormat:@"%zi %@", row, NSLocalizedString(@"date_unit_minute", nil)];
        }
        
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (currentPickerType == PickerTypePillDays) {
        
    } else if (currentPickerType == PickerTypeBreakDays) {
        
    } else if (currentPickerType == PickerTypeStartDate) {
        [pickerView reloadComponent:1];
        
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
        
        
        NSString *title = NSLocalizedString([moduleArray validObjectAtIndex:indexPath.section], nil);
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
        
    }

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString(@"button_title_confirm", nil)]) {
        [self finishSetting];
        
        [NotificationCenter postNotificationName:SettingChangedNotification object:nil];
    }
}

@end
