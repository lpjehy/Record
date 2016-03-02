//
//  ViewController.m
//  Record
//
//  Created by Jehy Fan on 16/3/1.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "PackViewController.h"

#import "HelpView.h"

@interface PackViewController () {
    
    UIButton *helpButton;
    UIButton *calendarButton;
    UIButton *settingButton;
}

@end

@implementation PackViewController


- (void)helpButtonPressed {
    [HelpView getInstance].show = YES;
}

- (void)calendarButtonPressed {
    
}

- (void)settingButtonPressed {
    
}

- (void)createLayout {
    
    float buttonWidth = (ScreenWidth - 120) / 3;
    
    helpButton = [[UIButton alloc] init];
    helpButton.frame = CGRectMake(40, ScreenHeight - 128, buttonWidth, 48);
    [helpButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setTitle:@"帮助" forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    helpButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:helpButton];
    
    calendarButton = [[UIButton alloc] init];
    calendarButton.frame = CGRectMake(40 + 20 + buttonWidth, ScreenHeight - 128, buttonWidth, 48);
    [calendarButton addTarget:self action:@selector(calendarButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [calendarButton setTitle:@"日历" forState:UIControlStateNormal];
    [calendarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    calendarButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:calendarButton];

    
    settingButton = [[UIButton alloc] init];
    settingButton.frame = CGRectMake(40 + (20 + buttonWidth) * 2, ScreenHeight - 128, buttonWidth, 48);
    [settingButton addTarget:self action:@selector(settingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    settingButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:settingButton];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
