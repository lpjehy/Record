//
//  ViewController.m
//  Record
//
//  Created by Jehy Fan on 16/3/1.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "MainViewController.h"
#import "SettingViewController.h"

#import "AdManager.h"

#import "HelpView.h"

#import "NotifyUtil.h"

#import "RecordManager.h"

#import "MessageManager.h"
#import "MessageViewDelegate.h"

#import "CalendarDayCell.h"
#import "CalendarMonthCollectionViewLayout.h"
#import "CalendarMonthHeaderView.h"

#import "Color.h"

#import "SettingViewController.h"

#import "HelpView.h"

#import "MessageManager.h"


#import "OnlineConfigUtil.h"

#import "CalendarViewDelegate.h"
#import "PackViewDelegate.h"

@import GoogleMobileAds;

#import "PackCollectionViewCell.h"

#import "StartView.h"



@interface MainViewController () <UIScrollViewDelegate> {
    
    UIScrollView *baseScrollView;
    
    UILabel *monthLabel;
    UILabel *tipLabel;
    
    UICollectionView *mainCollectionView;
    
    
    
    UIView *calendarView;
    UILabel *dateLabel;
    UIButton *todayButton;
    UICollectionView *calendarCollectionView;
    UITableView *messageTableView;
    
    
    
    int daynumber;//天数
    int optiondaynumber;//选择日期数量
    
    
    
    UIButton *helpButton;
    UIButton *mainButton;
    UIButton *settingButton;
    
    
    StartView *startView;
}

@end

@implementation MainViewController


- (void)helpButtonPressed {
    if (baseScrollView.contentOffset.y == 0) {
        [[HelpView getInstance] showPackHelp];
    } else {
        [[HelpView getInstance] showCalendarHelp];
    }
    
    
}

- (void)calendarButtonPressed {
    if (baseScrollView.contentOffset.y == 0) {
        
        [baseScrollView scrollToBottom:YES];
        
        [mainButton setTitle:@"Pack" forState:UIControlStateNormal];
    } else {
        [baseScrollView scrollToTop:YES];
        
        [mainButton setTitle:@"Calendar" forState:UIControlStateNormal];
        
        if (![HelpView CalendarHelpHasShowed]) {
            [[HelpView getInstance] showCalendarHelp];
        }
    }
    
    

}

- (void)settingButtonPressed {
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}


- (void)todayButtonPressed {
    [calendarCollectionView scrollToTop:YES];
}



- (void)createPackLayout {
    
    if (![HelpView PackHelpHasShowed]) {
        [[HelpView getInstance] showPackHelp];
    }
    
    monthLabel = [[UILabel alloc] init];
    monthLabel.textColor = [UIColor whiteColor];
    monthLabel.font = FontMax;
    monthLabel.frame = CGRectMake(20, 48, ScreenWidth - 40, FontMax.lineHeight);
    monthLabel.text = @"FEB-MAR";
    
    [baseScrollView addSubview:monthLabel];
    
    tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = FontNormal;
    tipLabel.frame = CGRectMake(20, 48 + FontMax.lineHeight, ScreenWidth - 40, FontNormal.lineHeight);
    tipLabel.text = @"current pack";
    
    [baseScrollView addSubview:tipLabel];
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 108, ScreenWidth - 40, ScreenHeight - 172)
                                            collectionViewLayout:flowLayout];
    mainCollectionView.pagingEnabled = YES;
    mainCollectionView.showsHorizontalScrollIndicator = NO;
    mainCollectionView.backgroundColor = [UIColor clearColor];
    [mainCollectionView registerClass:[PackCollectionViewCell class] forCellWithReuseIdentifier:PackCollectionViewCellIdentifier];
    mainCollectionView.delegate = [PackViewDelegate getInstance];
    mainCollectionView.dataSource = [PackViewDelegate getInstance];
    mainCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [baseScrollView addSubview:mainCollectionView];
}

- (void)createCalendarLayout {
    if (calendarView) {
        return;
    }
    
    
    
    calendarView = [[UIView alloc] init];
    calendarView.frame = CGRectMake(0, baseScrollView.height, ScreenWidth, baseScrollView.height);
    
    [baseScrollView addSubview:calendarView];
    
    
    dateLabel = [[UILabel alloc] init];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.frame = CGRectMake(128, 20, ScreenWidth - 256, 44);
    NSDateComponents *com = [NSDate date].components;
    dateLabel.text = [NSString stringWithFormat:@"%02zi/%zi", com.month, com.year];
    [calendarView addSubview:dateLabel];
    
    todayButton = [[UIButton alloc] init];
    todayButton.frame = CGRectMake(ScreenWidth - 74, 20, 64, 44);
    todayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [todayButton addTarget:self action:@selector(todayButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [todayButton setTitle:@"Today" forState:UIControlStateNormal];
    [calendarView addSubview:todayButton];
    
    daynumber = 365;
    optiondaynumber = 1;//选择一个后返回数据对象
    
    
    CalendarMonthCollectionViewLayout *layout = [CalendarMonthCollectionViewLayout new];
    
    calendarCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)
                                             collectionViewLayout:layout];
    
    [calendarCollectionView registerClass:[CalendarDayCell class] forCellWithReuseIdentifier:DayCell];//cell重用设置ID
    
    [calendarCollectionView registerClass:[CalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    //calendarCollectionView.pagingEnabled = YES;
    calendarCollectionView.backgroundColor = [UIColor clearColor];
    calendarCollectionView.frame = CGRectMake(0, 64, ScreenWidth, 300);
    calendarCollectionView.delegate = [CalendarViewDelegate getInstance];
    calendarCollectionView.dataSource = [CalendarViewDelegate getInstance];
    [calendarView addSubview:calendarCollectionView];
    
    messageTableView = [[UITableView alloc] init];
    messageTableView.frame = CGRectMake(0, 364, ScreenWidth, 260);
    messageTableView.dataSource = [MessageManager getInstance];
    messageTableView.backgroundColor = [UIColor clearColor];
    [calendarView addSubview:messageTableView];
    messageTableView.delegate = [MessageViewDelegate getInstance];
    
    
    [CalendarViewDelegate getInstance].calendarblock = ^(CalendarDayModel *model){
        
        dateLabel.text = [NSString stringWithFormat:@"%02zi/%zi", model.month, model.year];
    };
}

- (void)createLayout {
    
    
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    
    backgroundImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    backgroundImageView.image = [UIImage imageNamed:@"BG_Main.png"];
    [self.view addSubview:backgroundImageView];
    
    baseScrollView = [[UIScrollView alloc] init];
    baseScrollView.pagingEnabled = YES;
    baseScrollView.delegate = self;
    baseScrollView.showsVerticalScrollIndicator = NO;
    baseScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    baseScrollView.contentSize = CGSizeMake(ScreenWidth, baseScrollView.height * 2);
    [self.view addSubview:baseScrollView];
    
    
    [self createPackLayout];
    
    [self createCalendarLayout];
     
    float buttonWidth = (ScreenWidth - 120) / 3;
    
    helpButton = [[UIButton alloc] init];
    helpButton.frame = CGRectMake(40, ScreenHeight - 64, buttonWidth, 64);
    [helpButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setTitle:@"HELP" forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:helpButton];
    
    mainButton = [[UIButton alloc] init];
    mainButton.frame = CGRectMake(40 + 20 + buttonWidth, ScreenHeight - 64, buttonWidth, 64);
    [mainButton addTarget:self action:@selector(calendarButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [mainButton setTitle:@"Calendar" forState:UIControlStateNormal];
    [mainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:mainButton];

    
    settingButton = [[UIButton alloc] init];
    settingButton.frame = CGRectMake(40 + (20 + buttonWidth) * 2, ScreenHeight - 64, buttonWidth, 64);
    [settingButton addTarget:self action:@selector(settingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setTitle:@"SETTING" forState:UIControlStateNormal];
    [settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:settingButton];
    
    /*
    GADBannerView *bannerView = [[GADBannerView alloc] init];
    bannerView.backgroundColor = [UIColor blackColor];
    bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    bannerView.rootViewController = self;
    [bannerView loadRequest:[GADRequest request]];
    bannerView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    [self.view addSubview:bannerView];
     */

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createLayout];
    
    if (![StartView hasShowed]) {
        startView = [[StartView alloc] init];
        startView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [startView addTarget:self action:@selector(settingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:startView];
        
        
        baseScrollView.hidden = YES;
        helpButton.hidden = YES;
        mainButton.hidden = YES;
        settingButton.hidden = YES;
    }
   
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    /**/
    BOOL hideAnimated = YES;
    [self.navigationController setNavigationBarHidden:YES animated:hideAnimated];
    
    
    [mainCollectionView reloadData];
    [calendarCollectionView reloadData];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (startView) {
        startView.hidden = YES;
        
        baseScrollView.hidden = NO;
        helpButton.hidden = NO;
        mainButton.hidden = NO;
        settingButton.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == 0) {
        [mainButton setTitle:@"Calendar" forState:UIControlStateNormal];
    } else {
        [mainButton setTitle:@"Pack" forState:UIControlStateNormal];
        
        if (![HelpView CalendarHelpHasShowed]) {
            [[HelpView getInstance] showCalendarHelp];
        }
    }
}



@end
