//
//  SettingViewController.m
//  Record
//
//  Created by Jehy Fan on 16/3/3.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "SettingViewController.h"

#import "SettingCell.h"
#import "ReminderManager.h"
#import "ScheduleManager.h"

#import "OnlineConfigUtil.h"

#import "TextEditViewController.h"
#import "WebViewController.h"

typedef NS_ENUM(NSInteger, PickerType) {
    PickerTypePillDays,//默认从0开始
    PickerTypeSafeDays,
    PickerTypeStartDate,
    PickerTypeNotifyTime,
    PickerTypeNotifySound
};

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate, SettingCellDelegate, TextEditViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    UITableView *mainTableView;
    
    UIPickerView *numberPickerView;
    UIButton *doneButton;
    
    PickerType currentPickerType;
}

@property(nonatomic, strong) NSString *appID;

@end



@implementation SettingViewController

@synthesize appID;

- (id)init {
    self = [super init];
    if (self) {
        self.appID = [OnlineConfigUtil getValueForKey:OnlineConfig_AppId];
        
        
        
    }
    
    return self;
}

- (void)doneButtonPressed {
    doneButton.hidden = YES;
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.24];
    numberPickerView.originY = ScreenHeight;
    
    [UIView commitAnimations];
}

- (void)showPickerView {
    [self createPickerView];
    
    doneButton.hidden = NO;
    
    [numberPickerView reloadAllComponents];
    
    if (currentPickerType == PickerTypePillDays) {
        [numberPickerView selectRow:[ScheduleManager pillDays] - 1 inComponent:0 animated:NO];
    } else if (currentPickerType == PickerTypeSafeDays) {
        [numberPickerView selectRow:[ScheduleManager safeDays] - 1 inComponent:0 animated:NO];
    } else if (currentPickerType == PickerTypeStartDate) {
        NSDate *date = [ScheduleManager startDate];
        NSDateComponents *components = date.components;
        
        [numberPickerView selectRow:components.year - 2000 inComponent:0 animated:NO];
        [numberPickerView selectRow:components.month - 1 inComponent:1 animated:NO];
        [numberPickerView selectRow:components.day - 1 inComponent:2 animated:NO];
    } else if (currentPickerType == PickerTypeNotifyTime) {
        NSDate *date = [ReminderManager notificationTime];
        NSDateComponents *components = date.components;
        
        [numberPickerView selectRow:components.hour inComponent:0 animated:NO];
        [numberPickerView selectRow:components.minute inComponent:1 animated:NO];
        
    } else if (currentPickerType == PickerTypeNotifySound) {
        
        
        [numberPickerView selectRow:0 inComponent:0 animated:NO];
    }
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.24];
    numberPickerView.originY = ScreenHeight - numberPickerView.height;
    
    [UIView commitAnimations];
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
        
        [self.view addSubview:numberPickerView];
        
    }
}

- (void)createLayout {
    [self.navigationController setNavigationBarHidden:YES];
    
    UIButton *rightButton = [[UIButton alloc] init];
    rightButton.frame = CGRectMake(ScreenWidth - 64, 20, 64, 44);
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [rightButton setTitle:@"Close" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FontNormal;
    [rightButton setTitleColor:ColorTextLight forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:rightButton];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Setting";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.frame = CGRectMake(64, 20, ScreenWidth - 128, 44);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    self.view.backgroundColor = [UIColor colorWithWhite:68 / 255.0 alpha:1];
    
    mainTableView = [[UITableView alloc] init];
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self createLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**/
    BOOL hideAnimated = YES;
    [self.navigationController setNavigationBarHidden:YES animated:hideAnimated];
    
    
    
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

- (void)settingCellSwitchChangedForItem:(NSString *)item value:(BOOL)value {
    if ([item isEqualToString:@"Take everyday"]) {
        [ScheduleManager setIsEveryday:value];
    } else if ([item isEqualToString:@"Also remind me when I Take placebo pill"]) {
        [ReminderManager setRemindInSafeDays:value];
    }
}

- (void)textEditViewTextChanged:(NSString *)text {
    [ReminderManager setNotificationAlertBody:text];
    [mainTableView reloadData];
}

#pragma mark - UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger number = 0;
    
    if (currentPickerType == PickerTypePillDays || currentPickerType == PickerTypeSafeDays) {
        number = 1;
    } else if (currentPickerType == PickerTypeStartDate) {
        number = 3;
    } else if (currentPickerType == PickerTypeNotifyTime) {
        number = 2;
    } else if (currentPickerType == PickerTypeNotifySound) {
        number = 1;
    }
    
    return number;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger number = 0;
    if (currentPickerType == PickerTypePillDays) {
        number = 21;
    } else if (currentPickerType == PickerTypeSafeDays) {
        number = 7;
    } else if (currentPickerType == PickerTypeStartDate) {
        if (component == 0) {
            number = 100;
        } else if (component == 1) {
            number = 12;
        } else {
            NSInteger month = [pickerView selectedRowInComponent:1] + 1;
            NSInteger year = [pickerView selectedRowInComponent:0] + 2000;
            number = [NSDateComponents numberOfDaysInMonth:month year:year];
        }
        
    } else if (currentPickerType == PickerTypeNotifyTime) {
        if (component == 0) {
            number = 24;
        } else if (component == 1) {
            number = 60;
        }
        
    } else if (currentPickerType == PickerTypeNotifySound) {
        number = 1;
        
    }
    
    return number;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = nil;
    if (currentPickerType == PickerTypePillDays || currentPickerType == PickerTypeSafeDays) {
        title = [NSString stringWithInteger:row + 1];
    } else if (currentPickerType == PickerTypeStartDate) {
        if (component == 0) {
            title = [NSString stringWithFormat:@"%zi年", row + 2000];
        } else if (component == 1) {
            title = [NSString stringWithFormat:@"%zi月", row + 1];
        } else {
            title = [NSString stringWithFormat:@"%zi日", row + 1];
        }
        
    } else if (currentPickerType == PickerTypeNotifyTime) {
        if (component == 0) {
            title = [NSString stringWithFormat:@"%zi时", row];
        } else if (component == 1) {
            title = [NSString stringWithFormat:@"%zi分", row];
        }
        
    } else if (currentPickerType == PickerTypeNotifySound) {
        title = [ReminderManager notificationSound];
        
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger tableviewrow = currentPickerType + 1;
    NSInteger section = 0;
    if (currentPickerType == PickerTypePillDays) {
        [ScheduleManager setPillDays:row + 1];
        
    } else if (currentPickerType == PickerTypeSafeDays) {
        [ScheduleManager setSafeDays:row + 1];
        
        
    } else if (currentPickerType == PickerTypeStartDate) {
        NSInteger year = [pickerView selectedRowInComponent:0] + 2000;
        NSInteger month = [pickerView selectedRowInComponent:1] + 1;
        NSInteger day = [pickerView selectedRowInComponent:2] + 1;
        
        NSString *dateString = [NSString stringWithFormat:@"%zi-%02zi-%02zi 00:00:00.0", year, month, day];
        NSDate *date = dateString.date;
        [ScheduleManager setStartDate:date.timeIntervalSince1970];
        
        [pickerView reloadComponent:2];
        
    } else if (currentPickerType == PickerTypeNotifyTime) {
        NSInteger hour = [pickerView selectedRowInComponent:0];
        NSInteger minute = [pickerView selectedRowInComponent:1];
        
        NSString *dateString = [NSString stringWithFormat:@"%@ %02zi:%02zi:00.0", [[NSDate date] stringWithFormat:@"yyyy-MM-dd"], hour, minute];
        NSLog(@"time %@", dateString);
        NSDate *date = dateString.date;
        [ReminderManager setNotificationTime:date.timeIntervalSince1970];
        
        section = 1;
        tableviewrow = 2;
        
    } else if (currentPickerType == PickerTypeNotifySound) {
        
        //[ReminderManager setStartDate:[pickerView ]];
        
        section = 1;
        tableviewrow = 3;
        
    }
    
    [mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tableviewrow inSection:section]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithWhite:105 / 255.0 alpha:1];
    lineView.frame = CGRectMake(0, 0, ScreenWidth, 0.5);
    [headerView addSubview:lineView];
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.textColor = [UIColor colorWithWhite:161 / 255.0 alpha:1];
    headerLabel.font = FontMiddle;
    headerLabel.frame = CGRectMake(15, 20, ScreenWidth - 30, 44);
    if (section == 0) {
        headerLabel.text = @"Schedule";
    } else if (section == 1) {
        headerLabel.text = @"Reminders";
    } else {
        headerLabel.text = @"Others";
    }
    [headerView addSubview:headerLabel];

    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 4;
    } else {
        if (appID && ![appID isEqualToString:@"0"]) {
            return 2;
        }
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:SettingCellIdentifier];
    if(nil == cell) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SettingCellIdentifier];
        cell.delegate = self;
    }
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.item = @"Take everyday";
            cell.cellType = SettingCellTypeSwitch;
            cell.boolValue = [ScheduleManager isEveryday];
        } else if (indexPath.row == 1) {
            cell.item = @"Take pill days";
            cell.cellType = SettingCellTypeText;
            cell.textValue = [NSString stringWithFormat:@"%zi days", [ScheduleManager pillDays]];
            
        } else if (indexPath.row == 2) {
            cell.item = @"Break or placebo pill days";
            cell.cellType = SettingCellTypeText;
            cell.textValue = [NSString stringWithFormat:@"%zi days", [ScheduleManager safeDays]];
            
        } else if (indexPath.row == 3) {
            cell.item = @"Start take current pack at";
            cell.cellType = SettingCellTypeText;
            
            NSDate *date = [ScheduleManager startDate];
            NSDateComponents *components = date.components;
            cell.textValue = [NSString stringWithFormat:@"%@ %zi/%zi/%zi", components.weekDayText, components.month, components.day, components.year];
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.item = @"Also remind me when I Take placebo pill";
            cell.cellType = SettingCellTypeSwitch;
            cell.boolValue = [ReminderManager remindInSafeDays];
        } else if (indexPath.row == 1) {
            cell.item = @"Notification";
            cell.cellType = SettingCellTypeText;
            cell.textValue = [ReminderManager notificationAlertBody];
        } else if (indexPath.row == 2) {
            cell.item = @"Time";
            cell.cellType = SettingCellTypeText;
            cell.textValue = [[ReminderManager notificationTime] stringWithFormat:@"HH:mm"];
        } else {
            cell.item = @"Sound";
            cell.cellType = SettingCellTypeText;
            cell.textValue = [ReminderManager notificationSound];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.item = @"About us";
            
        } else {
            cell.item = @"Cheer us";
        }
        
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            currentPickerType = PickerTypePillDays;
            [self showPickerView];
        } else if (indexPath.row == 2) {
            currentPickerType = PickerTypeSafeDays;
            [self showPickerView];
        } else if (indexPath.row == 3) {
            currentPickerType = PickerTypeStartDate;
            [self showPickerView];
            
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            
            
            TextEditViewController *textEditViewController = [[TextEditViewController alloc] init];
            textEditViewController.text = [ReminderManager notificationAlertBody];
            textEditViewController.delegate = self;
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:textEditViewController];
            
            [self presentViewController:navController animated:YES completion:NULL];
        } else if (indexPath.row == 2) {
            currentPickerType = PickerTypeNotifyTime;
            [self showPickerView];
        } else if (indexPath.row == 3) {
            currentPickerType = PickerTypeNotifySound;
            [self showPickerView];
            
        }
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            WebViewController *webViewController = [[WebViewController alloc] init];
            webViewController.baseUrl = @"http://lpjehy.github.io/reminder/aboutus.html";
            [self.navigationController pushViewController:webViewController animated:YES];
        } else if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appID]]];
        }
        
    }

}


@end
