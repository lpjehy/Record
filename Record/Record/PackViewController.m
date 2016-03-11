//
//  ViewController.m
//  Record
//
//  Created by Jehy Fan on 16/3/1.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "PackViewController.h"
#import "CalendarHomeViewController.h"
#import "SettingViewController.h"

#import "AdManager.h"

#import "HelpView.h"

#import "NotifyUtil.h"

#import "RecordManager.h"

#import "MessageManager.h"


#import "OnlineConfigUtil.h"

@import GoogleMobileAds;

#import "PackCollectionViewCell.h"

@interface PackViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    
    UICollectionView *mainCollectionView;
    
    UIButton *helpButton;
    UIButton *calendarButton;
    UIButton *settingButton;
}

@end

@implementation PackViewController


- (void)helpButtonPressed {
    
    NSString *version = [OnlineConfigUtil getValueForKey:OnlineConfig_AppleReviewVersion];
    NSLog(@"version: %@", version);
    
    return;
    
    //[HelpView getInstance].show = YES;
    
}

- (void)calendarButtonPressed {
    CalendarHomeViewController *chvc = [[CalendarHomeViewController alloc]init];
    
    chvc.calendartitle = @"日历";
    
    [chvc setAirPlaneToDay:365 ToDateforString:nil];//飞机初始化方法
    
    
    
    chvc.calendarblock = ^(CalendarDayModel *model){
        
        NSLog(@"\n---------------------------");
        NSLog(@"1星期 %@",[model getWeek]);
        NSLog(@"2字符串 %@",[model toString]);
        NSLog(@"3节日  %@",model.holiday);
        
        
    };
    
    [self.navigationController pushViewController:chvc animated:YES];

}

- (void)settingButtonPressed {
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    
    
    [self presentViewController:settingViewController animated:YES completion:NULL];
}

- (void)createLayout {
    
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 148)
                                            collectionViewLayout:flowLayout];
    mainCollectionView.pagingEnabled = YES;
    mainCollectionView.backgroundColor = [UIColor clearColor];
    [mainCollectionView registerClass:[PackCollectionViewCell class] forCellWithReuseIdentifier:PackCollectionViewCellIdentifier];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    mainCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.view addSubview:mainCollectionView];
    
     
    float buttonWidth = (ScreenWidth - 120) / 3;
    
    helpButton = [[UIButton alloc] init];
    helpButton.frame = CGRectMake(40, ScreenHeight - 128, buttonWidth, 48);
    [helpButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setTitle:@"Help" forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    helpButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:helpButton];
    
    calendarButton = [[UIButton alloc] init];
    calendarButton.frame = CGRectMake(40 + 20 + buttonWidth, ScreenHeight - 128, buttonWidth, 48);
    [calendarButton addTarget:self action:@selector(calendarButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [calendarButton setTitle:@"Calendar" forState:UIControlStateNormal];
    [calendarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    calendarButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:calendarButton];

    
    settingButton = [[UIButton alloc] init];
    settingButton.frame = CGRectMake(40 + (20 + buttonWidth) * 2, ScreenHeight - 128, buttonWidth, 48);
    [settingButton addTarget:self action:@selector(settingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setTitle:@"Setting" forState:UIControlStateNormal];
    [settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    settingButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:settingButton];
    
    GADBannerView *bannerView = [[GADBannerView alloc] init];
    bannerView.backgroundColor = [UIColor blackColor];
    bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    bannerView.rootViewController = self;
    [bannerView loadRequest:[GADRequest request]];
    bannerView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    [self.view addSubview:bannerView];

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

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PackCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PackCollectionViewCellIdentifier
                                                                              forIndexPath:indexPath];
    
    
    if (indexPath.row == 0){
        //打开相机
    } else {
        
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.width - 10, collectionView.height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

@end
