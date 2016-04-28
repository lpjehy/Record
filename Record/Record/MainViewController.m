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


#import "LegendView.h"

#import "RecordManager.h"

#import "MessageManager.h"
#import "MessageViewDelegate.h"

#import "CalendarDayButton.h"


#import "SettingViewController.h"

#import "HelpView.h"

#import "MessageManager.h"
#import "ScheduleManager.h"


#import "OnlineConfigUtil.h"

#import "CalendarViewDelegate.h"

@import GoogleMobileAds;

#import "PackView.h"

#import "StartView.h"

#import "WebViewController.h"

static NSInteger ScrollViewTagBase = 0;
static NSInteger ScrollViewTagPack = 1;

@interface MainViewController () <UIScrollViewDelegate> {
    
    HelpView *helpView;
    
    UIScrollView *baseScrollView;
    
    UILabel *monthLabel;
    UILabel *tipLabel;
    UIButton *rightButton;
    
    UIScrollView *packScrollView;
    
    NSInteger currentPage;
    
    
    NSInteger currentPack;
    NSInteger currentSubPack;
    
    NSMutableArray *packViewArray;
    
    UIView *calendarView;
    UILabel *dateLabel;
    UIButton *todayButton;
    UIScrollView *calendarScrollView;
    UITableView *messageTableView;
    
    
    
    
    
    
    UIButton *helpButton;
    UIButton *mainButton;
    UIButton *settingButton;
    
    
    StartView *startView;
}

@end

@implementation MainViewController


- (id)init {
    self = [super init];
    if (self) {
        [NotificationCenter addObserver:self
                                                 selector:@selector(calendarMonthChanged:)
                                                     name:CalendarMonthChangedNotification
                                                   object:nil];
        
        
        [NotificationCenter addObserver:self
                                                 selector:@selector(settingChanged)
                                                     name:SettingChangedNotification
                                                   object:nil];
        
        
        
    }
    
    return self;
}

- (void)settingChanged {
    [baseScrollView scrollToTop:NO];
    
}

- (void)calendarMonthChanged:(NSNotification *)notification {
    NSDateComponents *day = [notification.userInfo validObjectForKey:@"day"];
    if (day) {
        dateLabel.text = [NSString stringWithFormat:@"%02zi/%zi", day.month, day.year];
    }
}

- (void)rightButtonPressed {
    rightButton.hidden = YES;
    [packScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    NSInteger page = (NSInteger)packScrollView.contentOffset.x / (NSInteger)packScrollView.width;
    
    NSInteger allNum = [ScheduleManager allDays];
    if (allNum > MaxDaysOfPack) {
        NSInteger pageOfPack = allNum / MaxDaysOfPack + 1;
        
        currentSubPack = page % pageOfPack;
        currentPack = page / pageOfPack;
        
    } else {
        currentPack = page;
        currentSubPack = 0;
    }
    
    if (currentPage != page) {
        currentPage = page;
        [self reloadPackData];
    }
    
    
    NSDateComponents *today = [ScheduleManager getInstance].today;
    monthLabel.text = [NSString stringWithFormat:@"%@ %zi", [NSDateComponents descriptionOfMonth:today.month], today.day];
    
    tipLabel.text = [NSString stringWithFormat:NSLocalizedString(@"message_day_info", nil), [ScheduleManager getInstance].currentPackDay, [ScheduleManager allDays]];
    tipLabel.hidden = NO;
    rightButton.hidden = YES;
}

- (void)helpButtonPressed {
    if (baseScrollView.contentOffset.y == 0) {
        [helpView showPackHelp];
    } else {
        [helpView showCalendarHelp];
    }
    
    
}



- (void)calendarButtonPressed {
    
    
    
    if (baseScrollView.contentOffset.y == 0) {
        
        [baseScrollView scrollToBottom:YES];
        
        [mainButton setBackgroundImage:[UIImage imageNamed:@"Btn_Packs.png"] forState:UIControlStateNormal];
        
        if (![HelpView CalendarHelpHasShowed]) {
            [helpView showCalendarHelp];
        }
        
    } else {
        [baseScrollView scrollToTop:YES];
        
        [mainButton setBackgroundImage:[UIImage imageNamed:@"Btn_Calendar.png"] forState:UIControlStateNormal];
        
        
    }
    
    

}

- (void)settingButtonPressed {
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)legendButtonPressed {
    [[LegendView getInstance] show];
}

- (void)todayButtonPressed {
    [[CalendarViewDelegate getInstance] scrollToToday];
}


- (void)lastButtonPressed {
    [calendarScrollView setContentOffset:CGPointMake(0, [[CalendarViewDelegate getInstance] contentOffsetYForMonth:[CalendarViewDelegate getInstance].currentMonth - 1]) animated:YES];
    
}

- (void)nextButtonPressed {
    [calendarScrollView setContentOffset:CGPointMake(0, [[CalendarViewDelegate getInstance] contentOffsetYForMonth:[CalendarViewDelegate getInstance].currentMonth + 1]) animated:YES];
}


- (void)createPackLayout {
    
    
    
    packViewArray = [[NSMutableArray alloc] init];
    
    monthLabel = [[UILabel alloc] init];
    monthLabel.textColor = [UIColor whiteColor];
    monthLabel.font = FontMax;
    monthLabel.frame = CGRectMake(20, 48, ScreenWidth - 40, FontMax.lineHeight);
    
    
    [baseScrollView addSubview:monthLabel];
    
    tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = FontNormal;
    tipLabel.frame = CGRectMake(20, 48 + FontMax.lineHeight, ScreenWidth - 40, FontNormal.lineHeight);
    
    
    [baseScrollView addSubview:tipLabel];
    
    NSDateComponents *today = [ScheduleManager getInstance].today;
    monthLabel.text = [NSString stringWithFormat:@"%@ %zi", [NSDateComponents descriptionOfMonth:today.month], today.day];
    
    tipLabel.text = [NSString stringWithFormat:NSLocalizedString(@"message_day_info", nil), [ScheduleManager getInstance].currentPackDay, [ScheduleManager allDays]];
    
    rightButton = [[UIButton alloc] init];
    rightButton.frame = CGRectMake(ScreenWidth - 132, 48, 128, 32);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitle:NSLocalizedString(@"pack_button_current_pack", nil) forState:UIControlStateNormal];
    rightButton.hidden = YES;
    [rightButton addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [baseScrollView addSubview:rightButton];
    
    packScrollView = [[UIScrollView alloc] init];
    if (ISPad) {
        packScrollView.frame = CGRectMake(80, 108, ScreenWidth - 160, ScreenHeight - 172);
    } else {
        packScrollView.frame = CGRectMake(20, 108, ScreenWidth - 40, ScreenHeight - 172);
    }
    
    
    packScrollView.clipsToBounds = NO;
    packScrollView.pagingEnabled = YES;
    packScrollView.showsHorizontalScrollIndicator = NO;
    packScrollView.backgroundColor = [UIColor clearColor];
    packScrollView.delegate = self;
    packScrollView.tag = ScrollViewTagPack;
    [baseScrollView addSubview:packScrollView];
    [self reloadPackData];
}

- (void)createCalendarLayout {
    if (calendarView) {
        return;
    }
    
    
    
    calendarView = [[UIView alloc] init];
    calendarView.frame = CGRectMake(0, baseScrollView.height, ScreenWidth, baseScrollView.height);
    
    [baseScrollView addSubview:calendarView];
    
    UIButton *legendButton = [[UIButton alloc] init];
    [legendButton setTitle:NSLocalizedString(@"button_title_legend", nil) forState:UIControlStateNormal];
    [legendButton setTitleColor:ColorGrayDark forState:UIControlStateNormal];
    legendButton.frame = CGRectMake(0, 20, 64, 44);
    legendButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    legendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [legendButton addTarget:self action:@selector(legendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [calendarView addSubview:legendButton];
    
    UIButton *lastButton = [[UIButton alloc] init];
    lastButton.frame = CGRectMake(64, 20, 64, 44);
    [lastButton setImage:[UIImage imageNamed:@"Arrow_White_Left.png"] forState:UIControlStateNormal];
    lastButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    lastButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [lastButton addTarget:self action:@selector(lastButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [calendarView addSubview:lastButton];
    
    
    UIButton *nextButton = [[UIButton alloc] init];
    nextButton.frame = CGRectMake(ScreenWidth - 128, 20, 64, 44);
    [nextButton setImage:[UIImage imageNamed:@"Arrow_White_Right.png"] forState:UIControlStateNormal];
    nextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    nextButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [calendarView addSubview:nextButton];
    
    dateLabel = [[UILabel alloc] init];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.frame = CGRectMake(128, 20, ScreenWidth - 256, 44);
    NSDateComponents *com = NSDate.components;
    dateLabel.text = [NSString stringWithFormat:@"%02zi/%zi", com.month, com.year];
    [calendarView addSubview:dateLabel];
    
    todayButton = [[UIButton alloc] init];
    todayButton.frame = CGRectMake(ScreenWidth - 64, 20, 64, 44);
    todayButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    todayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [todayButton addTarget:self action:@selector(todayButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [todayButton setTitle:NSLocalizedString(@"button_title_today", nil) forState:UIControlStateNormal];
    [calendarView addSubview:todayButton];
    
    
    
    
    CGFloat size = ScreenWidth / 7;
    
    GADBannerView *bannerView = [[GADBannerView alloc] init];
    bannerView.backgroundColor = [UIColor blackColor];
    bannerView.adUnitID = AdMobUnitIdCalendar;
    bannerView.rootViewController = self;
    [bannerView loadRequest:[GADRequest request]];
    bannerView.frame = CGRectMake(0, 64, ScreenWidth, size);
    [calendarView addSubview:bannerView];
    
    CGFloat currentY = 64 + size;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = ColorGrayDark;
    lineView.frame = CGRectMake(0, currentY, ScreenWidth, 0.5);
    [calendarView addSubview:lineView];
    
    NSArray *weekdayArray = @[@7, @1, @2, @3, @4, @5, @6];
    
    for (int i = 0; i < 7; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] init];
        weekdayLabel.font = FontMiddle;
        weekdayLabel.textColor = ColorGrayLight;
        weekdayLabel.frame = CGRectMake(size * i, currentY, size, 35);
        NSInteger weekday = [[weekdayArray validObjectAtIndex:i] integerValue];
        weekdayLabel.text = [NSDateComponents textForWeekday:weekday];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        [calendarView addSubview:weekdayLabel];
        
        if (i > 0) {
            lineView = [[UIView alloc] init];
            lineView.backgroundColor = ColorGrayDark;
            lineView.frame = CGRectMake(size * i, currentY, 0.5, 35);
            [calendarView addSubview:lineView];
        }
    }
    
    
    currentY += 35;
    
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = ColorGrayDark;
    lineView.frame = CGRectMake(0, currentY, ScreenWidth, 0.5);
    [calendarView addSubview:lineView];
    
    
    
    
    calendarScrollView = [[UIScrollView alloc] init];
    
    calendarScrollView.backgroundColor = [UIColor clearColor];
    
    [CalendarViewDelegate getInstance].thisScrollView = calendarScrollView;
    calendarScrollView.delegate = [CalendarViewDelegate getInstance];
    [calendarView addSubview:calendarScrollView];
    calendarScrollView.frame = CGRectMake(0, currentY, ScreenWidth, size * 5);
    
    for (int i = 1; i < 7; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = ColorGrayDark;
        lineView.frame = CGRectMake(size * i, currentY, 0.5, calendarScrollView.height);
        
        [calendarView addSubview:lineView];
    }
    
    
    
    currentY += calendarScrollView.height;
    
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = ColorGrayDark;
    lineView.frame = CGRectMake(0, currentY, ScreenWidth, 0.5);
    
    [calendarView addSubview:lineView];
    
    messageTableView = [[UITableView alloc] init];
    messageTableView.frame = CGRectMake(0, currentY, ScreenWidth, calendarView.height - currentY);
    messageTableView.dataSource = [MessageManager getInstance];
    messageTableView.backgroundColor = [UIColor clearColor];
    messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [calendarView addSubview:messageTableView];
    messageTableView.delegate = [MessageViewDelegate getInstance];
    
    
}

- (void)createLayout {
    
    
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    
    backgroundImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    backgroundImageView.image = [UIImage imageNamed:@"BG_Main.png"];
    [self.view addSubview:backgroundImageView];
    
    baseScrollView = [[UIScrollView alloc] init];
    baseScrollView.pagingEnabled = YES;
    baseScrollView.scrollEnabled = NO;
    baseScrollView.delegate = self;
    baseScrollView.showsVerticalScrollIndicator = NO;
    baseScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 90);
    baseScrollView.contentSize = CGSizeMake(ScreenWidth, baseScrollView.height * 2);
    [self.view addSubview:baseScrollView];
    
    
    [self createPackLayout];
    
    [self createCalendarLayout];
     
    float buttonWidth = (ScreenWidth - 120) / 3;
    
    helpButton = [[UIButton alloc] init];
    helpButton.frame = CGRectMake(40, ScreenHeight - 80, buttonWidth, 70);
    [helpButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setTitle:NSLocalizedString(@"button_title_help", nil) forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:helpButton];
    
    mainButton = [[UIButton alloc] init];
    mainButton.frame = CGRectMake((ScreenWidth - 70) / 2, ScreenHeight - 80, 70, 70);
    [mainButton addTarget:self action:@selector(calendarButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [mainButton setBackgroundImage:[UIImage imageNamed:@"Btn_Calendar.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:mainButton];

    
    settingButton = [[UIButton alloc] init];
    settingButton.frame = CGRectMake(40 + (20 + buttonWidth) * 2, ScreenHeight - 80, buttonWidth, 70);
    [settingButton addTarget:self action:@selector(settingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setTitle:NSLocalizedString(@"button_title_setting", nil) forState:UIControlStateNormal];
    [settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:settingButton];
    
    helpView = [[HelpView alloc] init];
    helpView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:helpView];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createLayout];
    
    if (![AppManager hasFirstOpened]) {
        [AppManager setFirstOpened];
        
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
    
    if (![AppManager hasFirstPackShowed]) {
        [AppManager setFirstPackShowed];
    }
    
    if ([AppManager hasFirstSetDone] && ![HelpView PackHelpHasShowed]) {
        [helpView showPackHelp];
    }
    
    /**/
    BOOL hideAnimated = YES;
    [self.navigationController setNavigationBarHidden:YES animated:hideAnimated];
    
    [self reloadPackData];
    [[CalendarViewDelegate getInstance] reloadData];
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


- (void)reloadPackData {
    NSInteger pagenum = currentPage + 3;
    
    for (int i = 0; i < pagenum; i++) {
        PackView *packView = [packViewArray validObjectAtIndex:i];
        if (packView == nil) {
            packView = [[PackView alloc] init];
            packView.frame = CGRectMake(packScrollView.width * i, 0, packScrollView.width, packScrollView.height);
            packView.tag = i;
            
            [packScrollView addSubview:packView];
            
            [packViewArray addObject:packView];
        }
        
        
        [packView reloadData];
    }
    
    
    packScrollView.contentSize = CGSizeMake(packScrollView.width * pagenum, packScrollView.height);
    
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == ScrollViewTagPack) {
        NSInteger page = (NSInteger)scrollView.contentOffset.x / (NSInteger)scrollView.width;
        
        NSInteger allNum = [ScheduleManager allDays];
        if (allNum > MaxDaysOfPack) {
            NSInteger pageOfPack = allNum / MaxDaysOfPack + 1;
            
            currentSubPack = page % pageOfPack;
            currentPack = page / pageOfPack;
            
        } else {
            currentPack = page;
            currentSubPack = 0;
        }
        
        if (currentPage != page) {
            currentPage = page;
            [self reloadPackData];
        }
        
        
    }
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == ScrollViewTagBase) {
        
    } else if (scrollView.tag == ScrollViewTagPack) {
        
        
        
        if (currentPack == 0) {
            NSDateComponents *today = [ScheduleManager getInstance].today;
            monthLabel.text = [NSString stringWithFormat:@"%@ %zi", [NSDateComponents descriptionOfMonth:today.month], today.day];
            
            tipLabel.text = [NSString stringWithFormat:NSLocalizedString(@"message_day_info", nil), [ScheduleManager getInstance].currentPackDay, [ScheduleManager allDays]];
            tipLabel.hidden = NO;
            rightButton.hidden = YES;
        } else {
            
            monthLabel.text = NSLocalizedString(@"pack_in_future", nil);
            
            tipLabel.hidden = YES;
            rightButton.hidden = NO;
        }
    }
    
}



@end
