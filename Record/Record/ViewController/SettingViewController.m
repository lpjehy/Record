//
//  SettingViewController.m
//  Record
//
//  Created by Jehy Fan on 16/3/3.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "SettingViewController.h"
#import "AudioManager.h"

#import "RecordData.h"

#import "NotifyManager.h"

#import "SettingCell.h"
#import "SettingOpenNotifyCell.h"

#import "ReminderManager.h"
#import "ScheduleManager.h"
#import "RefillManager.h"

#import "OnlineConfigUtil.h"

#import "TextEditViewController.h"
#import "SoundsViewController.h"
#import "LanguagesViewController.h"

#import "HelpView.h"

@import GoogleMobileAds;



#import "SettingItem.h"

#import "AdManager.h"

typedef NS_ENUM(NSInteger, PickerType) {
    PickerTypePillDays,//默认从0开始
    PickerTypeBreakDays,
    PickerTypeStartDate,
    PickerTypeRefillLeftPills,
    PickerTypeRefillCondition,
    PickerTypeRefillNotifyTime,
    PickerTypeNotifyTime
};

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate, SettingCellDelegate, TextEditViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate> {
    UITableView *mainTableView;
    
    UIPickerView *numberPickerView;
    UIButton *doneButton;
    UIButton *cancelButton;
    
    HelpView *helpView;
    
    PickerType currentPickerType;
    
    UIView *repeatCell;
    
    
    NSMutableArray *moduleArray;
    NSMutableDictionary *moduleDic;
    
    BOOL changedFromEveryDay;
    
}

@property(nonatomic, strong) NSString *appID;

@property(nonatomic) NSInteger initialPillsDay;
@property(nonatomic) NSInteger initialBreakDay;
@property(nonatomic, strong) NSString *initialStartDate;

@property(nonatomic) NSInteger finalPillsDay;
@property(nonatomic) NSInteger finalBreakDay;
@property(nonatomic, strong) NSString *finalStartDate;


@end


static NSString *Setting_Item_Take_Everyday = @"Setting_Item_Take_Everyday";
static NSString *Setting_Item_Pill_Days = @"Setting_Item_Pill_Days";
static NSString *Setting_Item_Break_Days = @"Setting_Item_Break_Days";
static NSString *Setting_Item_Take_Placebo_Pills = @"Setting_Item_Take_Placebo_Pills";
static NSString *Setting_Item_Start_Day = @"Setting_Item_Start_Day";


static NSString *Setting_Item_Refill_Switch = @"Setting_Item_Refill_Switch";
static NSString *Setting_Item_Refill_Left_Pill_Num = @"Setting_Item_Refill_Left_Pill_Num";
static NSString *Setting_Item_Refill_Notify_Pill_Num = @"Setting_Item_Refill_Notify_Pill_Num";
static NSString *Setting_Item_Refill_Notify_Time = @"Setting_Item_Refill_Notify_Time";
static NSString *Setting_Item_Refill_Notify_Sound = @"Setting_Item_Refill_Notify_Sound";


static NSString *Setting_Item_Auth_Guide_Alert = @"Setting_Item_Auth_Guide_Alert";

static NSString *Setting_Item_Remind_Take_Pill = @"Setting_Item_Remind_Take_Pill";
static NSString *Setting_Item_Remind_Take_Placebo_Pill = @"Setting_Item_Remind_Take_Placebo_Pill";
static NSString *Setting_Item_Notify_Alert_Body = @"Setting_Item_Notify_Alert_Body";
static NSString *Setting_Item_Notify_Time = @"Setting_Item_Notify_Time";
static NSString *Setting_Item_Notify_Repeat = @"Setting_Item_Notify_Repeat";
static NSString *Setting_Item_Notify_Sound = @"Setting_Item_Notify_Sound";
static NSString *Setting_Item_Language = @"Setting_Item_Language";



static NSInteger UIAlertViewTagDayConfirm = 0;
static NSInteger UIAlertViewTagTakePillEveryday = 1;
static NSInteger UIAlertViewTagConfirmNotificationAuthority = 2;





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
        
        
        [self addObserver];
        
    }
    
    return self;
}

- (void)dealloc {
    GADBannerView *bannerView = [AdManager settingView];
    [bannerView removeFromSuperview];
    bannerView.rootViewController = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRegisterUserNotificationSettings)
                                                 name:DidRegisterUserNotificationSettingsNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refillStateChanged)
                                                 name:RefillStateChangedNotification
                                               object:nil];
}

#pragma mark - Notifications
- (void)applicationDidBecomeActive {
    NSLog(@"SettringViewController applicationDidBecomeActive");
    
    [self reloadView];
}



- (void)didRegisterUserNotificationSettings {
    if ([NotifyManager hasAuthority]) {
        
        [NotifyManager resetRemindNotify];
        
        [NotifyManager resetActiveNotify];
        
        [self dismiss];
        
    } else {
        [AnalyticsUtil event:Event_Refuse_Notify];
        
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LocalizedString(@"auth_alert_title")
                                                            message:LocalizedString(@"auth_alert_message")
                                                           delegate:self
                                                  cancelButtonTitle:LocalizedString(@"auth_alert_notallow")
                                                  otherButtonTitles:LocalizedString(@"auth_alert_allow"), nil];
        alertView.tag = UIAlertViewTagConfirmNotificationAuthority;
        [alertView show];
        
    }
}

- (void)refillStateChanged {
    [self reloadView];
}


#pragma mark - view
- (void)reloadView {
    [moduleArray removeAllObjects];
    [moduleDic removeAllObjects];
    
    
    #pragma mark schedule
    NSMutableArray *array = [NSMutableArray array];
    
    SettingItem *item = [[SettingItem alloc] init];
    item.item = Setting_Item_Take_Everyday;
    item.type = SettingTypeSwitch;
    
    BOOL isEveryDay = [ScheduleManager isEveryday];
    item.boolValue = isEveryDay;
    item.enable = YES;
    [array addObject:item];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_Pill_Days;
    item.type = SettingTypeText;
    
    
    item.textValue = [NSString stringWithFormat:@"%zi %@", finalPillsDay, LocalizedString(@"unit_day")];
    item.enable = !isEveryDay;
    [array addObject:item];
    
    
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_Break_Days;
    item.type = SettingTypeText;
    item.textValue = [NSString stringWithFormat:@"%zi %@", finalBreakDay, LocalizedString(@"unit_day")];;
    item.enable = !isEveryDay;
    [array addObject:item];
    
    
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_Take_Placebo_Pills;
    item.type = SettingTypeSwitch;
    BOOL takePlaceboPills = [ScheduleManager takePlaceboPills];
    item.boolValue = takePlaceboPills;
    item.enable = !isEveryDay;
    [array addObject:item];
    
    
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_Start_Day;
    item.type = SettingTypeText;
    
    NSDate *date = finalStartDate.date;
    NSDateComponents *components = date.components;
    NSString *textValue = [NSString stringWithFormat:@"%@ %zi/%zi/%zi", components.weekDayText, components.month, components.day, components.year];
    item.textValue = textValue;
    item.enable = YES;
    [array addObject:item];
    
    
    
    [moduleArray addObject:@"setting_module_schedule"];
    [moduleDic setValue:array forKey:@"setting_module_schedule"];
    
    
    BOOL remindEnable = YES;
    if ([NotifyManager didRegisterUserNotificationSettings] && ![NotifyManager hasAuthority]) {
        
        
        remindEnable = NO;
        
    }
    
    /*
    #pragma mark refill
    array = [NSMutableArray array];
    
    
    BOOL shouldNotifyRefill = [RefillManager shouldNotify];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_Refill_Switch;
    item.type = SettingTypeSwitch;
    item.boolValue = shouldNotifyRefill;
    item.enable = remindEnable;
    [array addObject:item];
    
    if (shouldNotifyRefill) {
        item = [[SettingItem alloc] init];
        item.item = Setting_Item_Refill_Left_Pill_Num;
        item.type = SettingTypeText;
        item.textValue = [NSString stringWithInteger:[RefillManager leftPillNum]];
        item.enable = remindEnable;
        [array addObject:item];
    }
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_Refill_Notify_Pill_Num;
    item.type = SettingTypeText;
    
    NSInteger pillNum = [RefillManager notifyPillNum];
    NSString *text = [NSString stringWithFormat:LocalizedString(@"refill_pills_before"), [RefillManager notifyPillNum]];
    if (pillNum > 1 && ![LanguageManager isZH_Han]) {
        text = [text stringByAppendingString:@"s"];
    }
    item.textValue = text;
    item.enable = remindEnable && shouldNotifyRefill;
    [array addObject:item];
    
    if (shouldNotifyRefill) {
        item = [[SettingItem alloc] init];
        item.item = Setting_Item_Refill_Notify_Time;
        item.type = SettingTypeText;
        
        NSDate *nofityTime = [RefillManager notifyTime];
        components = nofityTime.components;
        NSString *daytime = LocalizedString(@"time_am");
     NSInteger hour = components.hour;
     if (hour > 12) {
     hour -= 12;
     daytime = LocalizedString(@"time_pm");
     } else if (hour == 0) {
     hour = 12;
     }
     item.textValue = [NSString stringWithFormat:@"%02zi:%02zi %@", hour, components.minute, daytime];
        item.enable = remindEnable;
        [array addObject:item];
        
        item = [[SettingItem alloc] init];
        item.item = Setting_Item_Refill_Notify_Sound;
        item.type = SettingTypeText;
        
        NSString *sound = [RefillManager notifySound];
        item.textValue = sound;
        item.enable = remindEnable;
        [array addObject:item];
        
    }
    
    
    [moduleArray addObject:@"setting_module_refill"];
    [moduleDic setValue:array forKey:@"setting_module_refill"];
    */
    
    #pragma mark remind
    array = [NSMutableArray array];
    
    if (!remindEnable) {
        item = [[SettingItem alloc] init];
        item.item = Setting_Item_Auth_Guide_Alert;
        [array addObject:item];
    }
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_Remind_Take_Pill;
    item.type = SettingTypeSwitch;
    
    BOOL shouldRemind = [ReminderManager shouldRemind];
    item.boolValue = shouldRemind;
    item.enable = remindEnable;
    [array addObject:item];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_Remind_Take_Placebo_Pill;
    item.type = SettingTypeSwitch;
    
    BOOL alsoRmind = [ReminderManager remindPlaceboPill];
    item.boolValue = alsoRmind;
    item.enable = remindEnable && shouldRemind && takePlaceboPills && !isEveryDay;
    [array addObject:item];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_Notify_Alert_Body;
    item.type = SettingTypeText;
    
    NSString *alertBody = [ReminderManager notifyAlertBody];
    item.textValue = alertBody;
    item.enable = remindEnable && shouldRemind;
    [array addObject:item];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_Notify_Time;
    item.type = SettingTypeText;
    
    NSDate *nofityTime = [ReminderManager notifyTime];
    components = nofityTime.components;
    NSString *daytime = LocalizedString(@"time_am");
    NSInteger hour = components.hour;
    if (hour >= 12) {
        if (hour > 12) {
            hour -= 12;
        }
        
        daytime = LocalizedString(@"time_pm");
    } else if (hour == 0) {
        hour = 12;
    }
    item.textValue = [NSString stringWithFormat:@"%02zi:%02zi %@", hour, components.minute, daytime];
    item.enable = remindEnable && shouldRemind;
    [array addObject:item];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_Notify_Repeat;
    item.type = SettingTypeSwitch;
    
    BOOL repeat = [ReminderManager remindRepeat];
    item.boolValue = repeat;
    item.enable = remindEnable && shouldRemind;
    [array addObject:item];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_Notify_Sound;
    item.type = SettingTypeText;
    
    NSString *sound = [ReminderManager notifySound];
    item.textValue = sound;
    item.enable = remindEnable && shouldRemind;
    [array addObject:item];

    
    [moduleArray addObject:@"setting_module_reminders"];
    [moduleDic setValue:array forKey:@"setting_module_reminders"];
    
    
    /*
    #pragma mark other
    
    array = [NSMutableArray array];
    
    item = [[SettingItem alloc] init];
    item.item = Setting_Item_Language;
    item.type = SettingTypeText;
    item.enable = YES;
    
    item.textValue = [LanguageManager languageName:[LanguageManager language]];
    
    [array addObject:item];
    
     
    
    [moduleArray addObject:@"setting_module_others"];
    [moduleDic setValue:array forKey:@"setting_module_others"];
    */
    
    [mainTableView reloadData];
}



- (void)doneButtonPressed {
    [AnalyticsUtil buttonClicked:__FUNCTION__];
    
    BOOL nochange = (initialPillsDay == finalPillsDay)
    && (initialBreakDay == finalBreakDay)
    && [initialStartDate isEqualToString:finalStartDate]
    && !changedFromEveryDay;
    
    if ([AppManager hasFirstSetDone] && nochange) {
        
        [self dismiss];
    } else {
        
        
        if ([ScheduleManager isEveryday]) {
            [self finishSetting];
            
        } else {
            
            NSString *text = nil;
            
            if (finalBreakDay > 1 && ![LanguageManager isZH_Han]) {
                text = LocalizedString(@"message_day_confirm_setting_bearkdays");
                if ([ScheduleManager takePlaceboPills]) {
                    text = LocalizedString(@"message_day_confirm_setting_placebopills");
                }
            } else {
                text = LocalizedString(@"message_day_confirm_setting_bearkday");
                if ([ScheduleManager takePlaceboPills]) {
                    text = LocalizedString(@"message_day_confirm_setting_placebopill");
                }
            }
            
            NSString *message = [NSString stringWithFormat:text, finalPillsDay, finalBreakDay];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:LocalizedString(@"button_title_cancel")
                                                      otherButtonTitles:LocalizedString(@"button_title_yes"), nil];
            alertView.tag = UIAlertViewTagDayConfirm;
            [alertView show];

        }
    }
}

/**
 *  进行设置收尾工作
 */
- (void)finishSetting {
    
    
    [ScheduleManager setPillDays:finalPillsDay
                       breakDays:finalBreakDay
                       startDate:finalStartDate.date];
    
    NSDate *finalDate = finalStartDate.date;
    NSDate *initialDate = initialStartDate.date;
    if ([finalDate isEarlierThan:initialDate]) {
        [[ScheduleManager getInstance] resetRecordFrom:finalDate toDate:initialDate];
    }
    
    [NotificationCenter postNotificationName:SettingChangedNotification object:nil];
    
    if (![AppManager hasFirstSetDone]) {
        /**
         *  第一次完成设置
         */
        [AppManager setFirstSetDone];
        
        [HelpView setNewUserForRepeatNotify];
        
        NSDate *notifyDate = [ReminderManager notifyTime];
        if (notifyDate.isEarlier) {
            [RecordData record:[NSDate date]];
        }
        
        //ios8  注册本地通知
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings *noteSetting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                       | UIUserNotificationTypeBadge
                                                       | UIUserNotificationTypeSound
                                                                                        categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:noteSetting];
            
            
        } else {
            
            [NotifyManager resetActiveNotify];
            
            [self dismiss];
        }
        
    } else {
        [self dismiss];
    }
}



#pragma mark - layout

- (void)createHeplView {
    if (helpView == nil) {
        helpView = [[HelpView alloc] init];
        helpView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self.view addSubview:helpView];
    }
}

- (void)createLayout {
    [self.navigationController setNavigationBarHidden:YES];
    
    UIButton *rightButton = [[UIButton alloc] init];
    rightButton.frame = CGRectMake(ScreenWidth - 64, 20, 64, 44);
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [rightButton setTitle:LocalizedString(@"button_title_done") forState:UIControlStateNormal];
    
    
    rightButton.titleLabel.font = FontNormal;
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
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
        [ReminderManager setRemindPlaceboPill:YES];
        
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if ([AppManager hasFirstSetDone] && ![NotifyManager hasAuthority]) {
        [mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:YES];
    } else if ([HelpView RepeatNotifyHelpShouldShowed]) {
        [mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:YES];
        
        
        
        [self createHeplView];
        [helpView showHelpRepeatNotifyWithImage:[UIImage imageWithView:repeatCell]];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - set change

- (void)settingCellSwitchChangedForItem:(SettingItem *)item value:(BOOL)value {
    
    
    if ([item.item isEqualToString:Setting_Item_Take_Everyday]) {
        if (value) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:LocalizedString(@"alert_message_takepilleveryday")
                                                               delegate:self
                                                      cancelButtonTitle:LocalizedString(@"button_title_cancel")
                                                      otherButtonTitles:LocalizedString(@"button_title_yes"), nil];
            alertView.tag = UIAlertViewTagTakePillEveryday;
            [alertView show];
            
            return;
        } else {
            [ScheduleManager setEveryday:NO];
            changedFromEveryDay = YES;
        }
        
        
    } else if ([item.item isEqualToString:Setting_Item_Take_Placebo_Pills]) {
        [ScheduleManager setTakePlaceboPills:value];
        
        if (value) {
            if ([ReminderManager shouldRemind]) {
                [ReminderManager setRemindPlaceboPill:YES];
            }
        } else {
            [ReminderManager setRemindPlaceboPill:NO];
        }
        
    } else if ([item.item isEqualToString:Setting_Item_Refill_Switch]) {
        [RefillManager setShouldNotify:value];
        return;
        
    } else if ([item.item isEqualToString:Setting_Item_Remind_Take_Pill]) {
        [ReminderManager setShouldRmind:value];
        if (value) {
            if ([ScheduleManager takePlaceboPills]) {
                [ReminderManager setRemindPlaceboPill:YES];
            }
        } else {
            
            [ReminderManager setRemindPlaceboPill:NO];
            [ReminderManager setRemindRepeat:NO];
        }
        
        
        
    } else if ([item.item isEqualToString:Setting_Item_Remind_Take_Placebo_Pill]) {
        [ReminderManager setRemindPlaceboPill:value];
        
    } else if ([item.item isEqualToString:Setting_Item_Notify_Repeat]) {
        [ReminderManager setRemindRepeat:value];
    }
    
    [self reloadView];
}

- (void)settingCellLinkClickedForItem:(SettingItem *)item {
    if ([item.item isEqualToString:Setting_Item_Auth_Guide_Alert]) {
        [NSURL openUrl:UIApplicationOpenSettingsURLString];
        
    }
}

- (void)textEditViewTextChanged:(NSString *)text {
    [ReminderManager setNotifyAlertBody:text];
    [self reloadView];
}


#pragma mark - picker

- (void)pikcerDoneButtonPressed {
    [AnalyticsUtil buttonClicked:__FUNCTION__];
    
    doneButton.hidden = YES;
    cancelButton.hidden = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.24];
    numberPickerView.originY = ScreenHeight + 32;
    
    [UIView commitAnimations];
    
    numberPickerView.tag = 0;
}

- (void)pickerConfirmButtonPressed {
    [AnalyticsUtil buttonClicked:__FUNCTION__];
    
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
        
        
    } else if (currentPickerType == PickerTypeRefillLeftPills) {
        
        [RefillManager setLeftPillNum:row + 1];
        
    } else if (currentPickerType == PickerTypeRefillCondition) {
        
        [RefillManager setNotifyPillNum:row + 1];
        
    } else if (currentPickerType == PickerTypeRefillNotifyTime
               || currentPickerType == PickerTypeNotifyTime) {
        
        NSInteger hour = [numberPickerView selectedRowInComponent:1] % 12 + 1;
        NSInteger minute = [numberPickerView selectedRowInComponent:2] % 60;
        NSInteger row = [numberPickerView selectedRowInComponent:3];
        if (row == 0) {
            if (hour == 12) {
                hour = 0;
            }
        } else {
            if (hour != 12) {
                hour += 12;
            }
        }
        
        NSString *dateString = [NSString stringWithFormat:@"%02zi:%02zi", hour, minute];
        
        if (currentPickerType == PickerTypeRefillNotifyTime) {
            [RefillManager setNotifyTime:dateString];
        } else {
            [ReminderManager setNotifyTime:dateString];
        }
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
        
    } else if (currentPickerType == PickerTypeRefillLeftPills) {
        [numberPickerView selectRow:[RefillManager leftPillNum] - 1 inComponent:0 animated:NO];
        
    } else if (currentPickerType == PickerTypeRefillCondition) {
        [numberPickerView selectRow:[RefillManager notifyPillNum] - 1 inComponent:0 animated:NO];
        
    } else if (currentPickerType == PickerTypeRefillNotifyTime
               || currentPickerType == PickerTypeNotifyTime) {
        
        NSDate *date = nil;
        if (currentPickerType == PickerTypeRefillNotifyTime) {
            date = [RefillManager notifyTime];
        } else {
            date = [ReminderManager notifyTime];
        }
        
        NSDateComponents *components = date.components;
        NSInteger hour = components.hour - 1;
        if (hour > 12) {
            hour -= 12;
            [numberPickerView selectRow:1 inComponent:3 animated:NO];
        }
        [numberPickerView selectRow:hour + 12 * 50 inComponent:1 animated:NO];
        [numberPickerView selectRow:components.minute + 60 * 50 inComponent:2 animated:NO];
        
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


#pragma mark - UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger number = 0;
    
    if (currentPickerType == PickerTypePillDays
        || currentPickerType == PickerTypeBreakDays
        || currentPickerType == PickerTypeRefillLeftPills
        || currentPickerType == PickerTypeRefillCondition) {
        number = 1;
        
    } else if (currentPickerType == PickerTypeStartDate
               || currentPickerType == PickerTypeNotifyTime
               || currentPickerType == PickerTypeRefillNotifyTime) {
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
        
    } else if (currentPickerType == PickerTypeRefillLeftPills) {
        number = MaxLeftPillNum;
        
    } else if (currentPickerType == PickerTypeRefillCondition) {
        number = [RefillManager leftPillNum];
        
    } else if (currentPickerType == PickerTypeRefillNotifyTime
               || currentPickerType == PickerTypeNotifyTime) {
        if (component == 1) {
            number = 12 * 100;
        } else if (component == 2) {
            number = 60 * 100;
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
        
    } else if (currentPickerType == PickerTypeRefillLeftPills) {
        title = [NSString stringWithInteger:row + 1];
        
    } else if (currentPickerType == PickerTypeRefillCondition) {
        title = [NSString stringWithInteger:row + 1];
        
    } else if (currentPickerType == PickerTypeRefillNotifyTime
               || currentPickerType == PickerTypeNotifyTime) {
        if (component == 1) {
            title = [NSString stringWithFormat:@"%zi", row % 12 + 1];
        } else if (component == 2) {
            title = [NSString stringWithFormat:@"%02zi", row % 60];
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
    
    if (currentPickerType == PickerTypeStartDate) {
        if (component == 0 || component == 4) {
            
            return (ScreenWidth - 72 * 3) / 2;
        } else {
            return 72;
        }
        
    }
    
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
    
    
    
    
    NSString *key = [moduleArray validObjectAtIndex:indexPath.section];
    NSArray *itemArray = [moduleDic validObjectForKey:key];
    SettingItem *item = [itemArray validObjectAtIndex:indexPath.row - 1];
    if ([item.item isEqualToString:Setting_Item_Auth_Guide_Alert]) {
        SettingOpenNotifyCell *cell = (SettingOpenNotifyCell *)[tableView dequeueReusableCellWithIdentifier:SettingOpenNotifyCellIdentifier];
        if(nil == cell) {
            cell = [[SettingOpenNotifyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SettingOpenNotifyCellIdentifier];
            cell.delegate = self;
        }
        
        [cell setItem:item];
        
        
        return cell;
    } else {
        SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:SettingCellIdentifier];
        if(nil == cell) {
            cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SettingCellIdentifier];
            cell.delegate = self;
        }
        
        [cell setItem:item];
        
        if ([item.item isEqualToString:Setting_Item_Notify_Repeat]) {
            repeatCell = cell;
        }
        
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [moduleArray validObjectAtIndex:indexPath.section];
    NSArray *itemArray = [moduleDic validObjectForKey:key];
    SettingItem *item = [itemArray validObjectAtIndex:indexPath.row - 1];
    if ([item.item isEqualToString:Setting_Item_Auth_Guide_Alert]) {
        return [SettingOpenNotifyCell cellHeight];
    } else {
        return [SettingCell cellHeight];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = [moduleArray validObjectAtIndex:indexPath.section];
    NSArray *itemArray = [moduleDic validObjectForKey:key];
    SettingItem *item = [itemArray validObjectAtIndex:indexPath.row - 1];
    
    if (!item.enable) {
        return;
    }
    
    if ([item.item isEqualToString:Setting_Item_Pill_Days]) {
        
        currentPickerType = PickerTypePillDays;
        [self showPickerView];
        
    } else if ([item.item isEqualToString:Setting_Item_Break_Days]) {

        currentPickerType = PickerTypeBreakDays;
        [self showPickerView];
    
    
    } else if ([item.item isEqualToString:Setting_Item_Start_Day]) {
        
        currentPickerType = PickerTypeStartDate;
        [self showPickerView];
        
    } else if ([item.item isEqualToString:Setting_Item_Refill_Left_Pill_Num]) {
        
        currentPickerType = PickerTypeRefillLeftPills;
        [self showPickerView];
        
        
    } else if ([item.item isEqualToString:Setting_Item_Refill_Notify_Pill_Num]) {
        
        currentPickerType = PickerTypeRefillCondition;
        [self showPickerView];
        
        
    } else if ([item.item isEqualToString:Setting_Item_Refill_Notify_Time]) {
        
        currentPickerType = PickerTypeRefillNotifyTime;
        [self showPickerView];
        
        
    } else if ([item.item isEqualToString:Setting_Item_Notify_Alert_Body]) {
        
        TextEditViewController *textEditViewController = [[TextEditViewController alloc] init];
        textEditViewController.text = [ReminderManager notifyAlertBody];
        textEditViewController.delegate = self;
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:textEditViewController];
        
        [self presentViewController:navController animated:YES completion:NULL];
        
        
    } else if ([item.item isEqualToString:Setting_Item_Notify_Time]) {
        
        currentPickerType = PickerTypeNotifyTime;
        [self showPickerView];
        
    } else if ([item.item isEqualToString:Setting_Item_Notify_Sound]
               || [item.item isEqualToString:Setting_Item_Refill_Notify_Sound]) {
        
        SoundsViewController *soundsViewController = [[SoundsViewController alloc] init];
        if ([item.item isEqualToString:Setting_Item_Notify_Sound]) {
            soundsViewController.type = SoundTypeRemind;
        } else {
            soundsViewController.type = SoundTypeRefill;
        }
        
        [self.navigationController pushViewController:soundsViewController animated:YES];
        
    } else if ([item.item isEqualToString:Setting_Item_Language]) {
        
        LanguagesViewController *languagesViewController = [[LanguagesViewController alloc] init];
        
        [self.navigationController pushViewController:languagesViewController animated:YES];
        
    }

    
    
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if (alertView.tag == UIAlertViewTagTakePillEveryday) {
        
        
        if ([buttonTitle isEqualToString:LocalizedString(@"button_title_yes")]) {
            //take everyday
            [ScheduleManager setEveryday:YES];
            
            [ScheduleManager setTakePlaceboPills:YES];
            
            BOOL shouldRminder = [ReminderManager shouldRemind];
            [ReminderManager setRemindPlaceboPill:shouldRminder];
            
            [NotificationCenter postNotificationName:SettingChangedNotification object:nil];
            
        } else {
            [ScheduleManager setEveryday:NO];
            
        }
        
        [self reloadView];
        
    } else if (alertView.tag == UIAlertViewTagDayConfirm) {
        
        if ([buttonTitle isEqualToString:LocalizedString(@"button_title_yes")]) {
            //完成设置
            [self finishSetting];
            
        }
        
    } else if (alertView.tag == UIAlertViewTagConfirmNotificationAuthority) {
        
        
        
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:LocalizedString(@"auth_alert_allow")]) {
            
            [self reloadView];
            
            [mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                                 atScrollPosition:UITableViewScrollPositionTop
                                         animated:YES];
            
        } else if ([title isEqualToString:LocalizedString(@"auth_alert_notallow")]) {
            
            [self dismiss];
        }
    }
    

    
    
}

@end
