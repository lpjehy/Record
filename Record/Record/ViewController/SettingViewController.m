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

#import "TextEditViewController.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate, SettingCellDelegate, TextEditViewDelegate> {
    UITableView *mainTableView;
}

@end

@implementation SettingViewController

- (void)createLayout {
    [self.navigationController setNavigationBarHidden:YES];
    
    UIButton *rightButton = [[UIButton alloc] init];
    rightButton.frame = CGRectMake(ScreenWidth - 64, 20, 64, 44);
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [rightButton setTitle:@"Close" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FontNormal;
    [rightButton setTitleColor:ColorTextGray forState:UIControlStateNormal];
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
        return 2;
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
            cell.textValue = [NSString stringWithFormat:@"%zi %zi/%zi/%zi", components.weekday, components.month, components.day, components.year];
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
            cell.textValue = [[ReminderManager notificationTime] stringWithFormat:@"mm:ss"];
        } else {
            cell.item = @"Sound";
            cell.cellType = SettingCellTypeText;
            cell.textValue = [ReminderManager notificationSound];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.item = @"Cheer us";
        } else {
            cell.item = @"About us";
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
            
        } else if (indexPath.row == 2) {
            
        } else if (indexPath.row == 3) {
            
            
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            
            
            TextEditViewController *textEditViewController = [[TextEditViewController alloc] init];
            textEditViewController.text = [ReminderManager notificationAlertBody];
            textEditViewController.delegate = self;
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:textEditViewController];
            
            [self presentViewController:navController animated:YES completion:NULL];
        } else if (indexPath.row == 2) {
            
        } else if (indexPath.row == 3) {
            
            
        }
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
            
        }
        
    }

}


@end
