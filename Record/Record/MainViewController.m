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

#import "AdBannerView.h"
#import "SnoozeView.h"
#import "FeedBackView.h"

#import "RecordData.h"


#import "CalendarDayButton.h"


#import "SettingViewController.h"

#import "HelpView.h"
#import "MessageCell.h"

#import "MessageManager.h"
#import "ScheduleManager.h"
#import "ReminderManager.h"

#import "NotifyManager.h"


#import "OnlineConfigUtil.h"

#import "CalendarViewDelegate.h"



#import "PackView.h"

#import "StartView.h"



static NSInteger ScrollViewTagBase = 0;
static NSInteger ScrollViewTagPack = 1;

@interface MainViewController () <UIScrollViewDelegate> {
    
    HelpView *helpView;
    
    UIScrollView *baseScrollView;
    
    UILabel *packTitleLabel;
    UILabel *packSubTitleLabel;
    UIButton *packRightButton;
    
    GADBannerView *bannerView;
    
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
    
    UIImageView *settingAlertImageView;
    
    StartView *startView;
    
    
    BOOL shouldCheckTodayPack;
    BOOL moveToTodayAnimate;
    
    CGFloat todayPackX;
}

@end

@implementation MainViewController


- (id)init {
    self = [super init];
    if (self) {
        
        
        [self addObserver];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)addObserver {
    [NotificationCenter addObserver:self
                           selector:@selector(calendarMonthChanged:)
                               name:CalendarMonthChangedNotification
                             object:nil];
    
    
    [NotificationCenter addObserver:self
                           selector:@selector(settingChanged)
                               name:SettingChangedNotification
                             object:nil];
    
    [NotificationCenter addObserver:self
                           selector:@selector(todayPackSetted:)
                               name:TodayPackSettedNotification
                             object:nil];
    
    [NotificationCenter addObserver:self
                           selector:@selector(checkSetting)
                               name:DidRegisterUserNotificationSettingsNotification
                             object:nil];
    
    [NotificationCenter addObserver:self
                           selector:@selector(checkSetting)
                               name:HelpRepeatNotifyShowedNotification
                             object:nil];
        
    [NotificationCenter addObserver:self
                           selector:@selector(checkSnooze)
                               name:CheckSnoozeNotification
                             object:nil];
    
    
    [NotificationCenter addObserver:self
                           selector:@selector(pillStateChanged:)
                               name:PillStateChangedNotification
                             object:nil];
    
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(currentLocaleDidChange)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

#pragma apllication

- (void)applicationDidBecomeActive {
    
    
    
    [self performSelector:@selector(checkView) withObject:nil afterDelay:1];
    
    if (baseScrollView.contentOffset.y != 0) {
        //显示日历中
        [AnalyticsUtil beginEventDistinguishInitial:Event_view_calendar];
    }
    
    
    
}

- (void)applicationWillResignActive {
    if (baseScrollView.contentOffset.y != 0) {
        //显示日历中
        [AnalyticsUtil endEventDistinguishInitial:Event_view_calendar];
    }
}


- (void)currentLocaleDidChange {
    NSLog(@"currentLocaleDidChange");
}




#pragma bussness
- (void)settingChanged {
    [baseScrollView scrollToTop:NO];
    
    NSInteger currentPackIndex = 0;
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[ScheduleManager startDate]];
    NSInteger days = interval / TimeIntervalDay;
    if (days > [ScheduleManager allDays]) {
        //有上一药板
        currentPackIndex = 1;
        
        if ([ScheduleManager allDays] > MaxDaysOfPack) {
            //一个周期有两个子药板
            currentPackIndex = 2;
        }
    }
        
    NSInteger currentPackX = currentPackIndex * packScrollView.width;
    if (packScrollView.contentOffset.x != currentPackX) {
        [packScrollView setContentOffset:CGPointMake(currentPackX, 0)];
    }
    
    shouldCheckTodayPack = YES;
    moveToTodayAnimate = YES;
    
}

- (void)todayPackSetted:(NSNotification *)notification {
    
    todayPackX = [[notification.userInfo validObjectForKey:@"DestX"] floatValue];
    if (shouldCheckTodayPack && packScrollView) {
        shouldCheckTodayPack = NO;
        
        [self performSelector:@selector(scrollToTodayPack) withObject:nil afterDelay:.64];
    }
}

- (void)scrollToTodayPack {
    if (packScrollView.contentOffset.x == todayPackX) {
        return;
    }
    
    [packScrollView setContentOffset:CGPointMake(todayPackX, 0) animated:moveToTodayAnimate];
    if (moveToTodayAnimate) {
        [self performSelector:@selector(resetPackInfo) withObject:nil afterDelay:.37];
    } else {
        [self resetPackInfo];
    }
    
}

- (void)calendarMonthChanged:(NSNotification *)notification {
    NSDateComponents *day = [notification.userInfo validObjectForKey:@"day"];
    if (day) {
        dateLabel.text = [NSString stringWithFormat:@"%02zi/%zi", day.month, day.year];
    }
}

- (void)pillStateChanged:(NSNotification *)notification {
    
    NSString *type = [notification.userInfo valueForKey:@"type"];
    NSString *time = [notification.userInfo valueForKey:@"time"];
    if ([type isEqualToString:@"insert"]) {
        // 吃药
        
        if ([time isEqualToString:[ScheduleManager getInstance].today.theDay]) {
            [[SnoozeView getInstance] cancel];
            
            [NotifyManager resetRemindNotify];
            
            
            if ([FeedBackView shouldShow]) {
                [[FeedBackView getInstance] performSelector:@selector(showInView:) withObject:baseScrollView afterDelay:0.4];
            }
        } else {
            
        }        
        
    } else {
        // 取消吃药
        if ([time isEqualToString:[ScheduleManager getInstance].today.theDay]) {
            
            if ([ReminderManager canSnooze]) {
                [[SnoozeView getInstance] showInView:baseScrollView];
            } else {
                [[SnoozeView getInstance] cancel];
            }
            
            [NotifyManager resetRemindNotify];
        } else {
            
        }
    }
    
    
    
    [[MessageManager getInstance] reloadData];
    
}

#pragma mark - Functions

- (void)packRightButtonPressed {
    [AnalyticsUtil buttonClicked:__FUNCTION__];
    
    [AnalyticsUtil event:Event_back_to_current_pack_click];
    
    moveToTodayAnimate = YES;
    [self scrollToTodayPack];
    
    
    packRightButton.hidden = YES;
    
    
    NSInteger page = (NSInteger)todayPackX / (NSInteger)packScrollView.width;
    
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
    
    
    [self resetPackInfo];
}

- (void)helpButtonPressed {
    [AnalyticsUtil buttonClicked:__FUNCTION__];
    
    if (baseScrollView.contentOffset.y == 0) {
        
        [helpView showPackHelp];
    } else {
        [helpView showCalendarHelp];
    }
    
    
}



- (void)mainButtonPressed {
    [AnalyticsUtil buttonClicked:__FUNCTION__];
    
    
    if (baseScrollView.contentOffset.y == 0) {
        
        
        
        [baseScrollView scrollToBottom:YES];
        
        [mainButton setBackgroundImage:[UIImage imageNamed:@"Btn_Packs.png"] forState:UIControlStateNormal];
        
        if (![HelpView CalendarHelpHasShowed]) {
            [helpView showCalendarHelp];
        }
        
        [AnalyticsUtil beginEventDistinguishInitial:Event_view_calendar];
        
        
    } else {
        
        [baseScrollView scrollToTop:YES];
        
        [mainButton setBackgroundImage:[UIImage imageNamed:@"Btn_Calendar.png"] forState:UIControlStateNormal];
        
        
        [AnalyticsUtil endEventDistinguishInitial:Event_view_calendar];
    }
    
    

}

- (void)settingButtonPressed {
    [AnalyticsUtil buttonClicked:__FUNCTION__];
    
    [AnalyticsUtil eventDistinguishInitial:Event_view_setting];
    
    
    
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)legendButtonPressed {
    [AnalyticsUtil buttonClicked:__FUNCTION__];
    
    [[LegendView getInstance] show];
}

- (void)todayButtonPressed {
    [AnalyticsUtil buttonClicked:__FUNCTION__];
    
    [[CalendarViewDelegate getInstance] scrollToToday];
}


- (void)lastButtonPressed {
    [AnalyticsUtil buttonClicked:__FUNCTION__];
    
    [calendarScrollView setContentOffset:CGPointMake(0, [[CalendarViewDelegate getInstance] contentOffsetYForMonth:[CalendarViewDelegate getInstance].currentMonth - 1]) animated:YES];
    
}

- (void)nextButtonPressed {
    [AnalyticsUtil buttonClicked:__FUNCTION__];
    
    [calendarScrollView setContentOffset:CGPointMake(0, [[CalendarViewDelegate getInstance] contentOffsetYForMonth:[CalendarViewDelegate getInstance].currentMonth + 1]) animated:YES];
}

#pragma mark - view

- (void)checkView {
    [self performSelector:@selector(checkSetting) withObject:nil afterDelay:1];
    
    
    [self reloadView];
    
    
}

- (void)checkSnooze {
    if ([ReminderManager canSnooze]) {
        
        [[SnoozeView getInstance] showInView:baseScrollView];
    } else {
        [[SnoozeView getInstance] cancel];
    }
}

- (void)checkSetting {
    
    if ([AppManager shouldShowRedPoint] && settingButton) {
        [self createSettingAlertLayout];
        
        
        CGFloat labelX = settingButton.originX + (settingButton.width - settingButton.titleSize.width) / 2;
        CGFloat endx = labelX - 24;
        CGFloat size = 0;
        if (endx >= (ScreenWidth + 70) / 2 + 2) {
            //如果红点未触碰到日历按钮
            
            settingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            settingButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            
            size = 27;
            labelX -= size + 2;
        } else {
            settingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            settingButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
            
            size = 24;
            labelX = ScreenWidth - 2 - settingButton.titleSize.width - size - 1;
            
        }
        settingAlertImageView.frame = CGRectMake(labelX, settingButton.originY + (settingButton.height - size) / 2, size, size);
        
        if (settingAlertImageView.alpha == 0) {
            [UIView animateWithDuration:0.24 animations:^{
                settingAlertImageView.alpha = 1;
            } completion:^(BOOL finished) {
                [settingAlertImageView animatExpandWithRange:0.2];
            }];
        } else {
            [settingAlertImageView animatExpandWithRange:0.2];
        }

    } else {
        settingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        settingButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        if (settingAlertImageView) {
            
            [UIView animateWithDuration:0.24 animations:^{
                settingAlertImageView.alpha = 0;
            }];
        }
    }
    
}

#pragma mark - data
- (void)reloadView {
    
    [self resetPackInfo];
    
    [self reloadPackData];
    [[CalendarViewDelegate getInstance] reloadData];
    [[MessageManager getInstance] reloadData];
}

- (void)resetPackInfo {
    
    NSInteger packViewIndex = packScrollView.contentOffset.x / (NSInteger)packScrollView.width;
    PackView *view = [packViewArray validObjectAtIndex:packViewIndex];
    
    if (view.packIndex < 0) {
        packTitleLabel.text = LocalizedString(@"pack_in_previous");
        
        
        PackView *view = [packViewArray validObjectAtIndex:currentPack];
        packSubTitleLabel.text = view.timeInfo;
        packSubTitleLabel.hidden = NO;
        
        packRightButton.hidden = NO;
        
        if ([ReminderManager canSnooze]) {
            [[SnoozeView getInstance] hide];
        } else {
            [[SnoozeView getInstance] cancel];
        }
        
    } else if (view.packIndex == 0) {
        
        //设置主标题
        NSDateComponents *today = [ScheduleManager getInstance].today;
        
        NSString *title = [NSString stringWithFormat:@"%@ %zi%@", [NSDateComponents descriptionOfMonth:today.month], today.day, LocalizedString(@"pack_title_unit_day")];
        if ([LanguageManager isZH_Han]) {
            title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        packTitleLabel.text = title;
        
        if ([ScheduleManager isEveryday]) {
            packSubTitleLabel.text = LocalizedString(@"pack_sub_title_take_everyday");
        } else {
            packSubTitleLabel.text = [[ScheduleManager getInstance] todayInfo];
        }
        
        
        packSubTitleLabel.hidden = NO;
        packRightButton.hidden = YES;
        
        
        if ([ReminderManager canSnooze]) {
            
            static NSDate *firstTime = nil;
            if (firstTime == nil) {
                firstTime = [NSDate date];
            }
            
            if ([firstTime timeIntervalSinceNow] < -2) {
                // 第二次激活时，直接显示
                
                [[SnoozeView getInstance] showInView:baseScrollView];
            } else {
                static  NSInteger showTime = 0;
                if (showTime == 0) {
                    showTime++;
                    [[SnoozeView getInstance] performSelector:@selector(showInView:) withObject:baseScrollView afterDelay:1.5];
                }
                
            }
            
            
        } else {
            [[SnoozeView getInstance] cancel];
        }
    } else {
        
        if ([ReminderManager canSnooze]) {
            [[SnoozeView getInstance] hide];
        } else {
            [[SnoozeView getInstance] cancel];
        }
        
        packTitleLabel.text = LocalizedString(@"pack_in_future");
        
        packSubTitleLabel.hidden = YES;
        packRightButton.hidden = NO;
    }
    
}

- (void)reloadPackData {
    if (packScrollView == nil) {
        return;
    }
    
    NSInteger pagenum = currentPage + 4;
    
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

#pragma mark - layout

- (void)createPackLayout {
    
    
    
    packViewArray = [[NSMutableArray alloc] init];
    
    packTitleLabel = [[UILabel alloc] init];
    packTitleLabel.textColor = [UIColor whiteColor];
    packTitleLabel.font = FontLightMax;
    [baseScrollView addSubview:packTitleLabel];
    
    packSubTitleLabel = [[UILabel alloc] init];
    packSubTitleLabel.textColor = [UIColor whiteColor];
    packSubTitleLabel.font = FontLightMiddle;
    packSubTitleLabel.adjustsFontSizeToFitWidth = YES;
    packSubTitleLabel.minimumScaleFactor = 0.5;
    
    
    
    [baseScrollView addSubview:packSubTitleLabel];
    
    
    
    packRightButton = [[UIButton alloc] init];
    
    [packRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [packRightButton setTitle:LocalizedString(@"pack_button_current_pack") forState:UIControlStateNormal];
    
    [packRightButton addTarget:self action:@selector(packRightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [baseScrollView addSubview:packRightButton];
    
    packScrollView = [[UIScrollView alloc] init];
    if (ISPad) {
        
        packTitleLabel.frame = CGRectMake(90, 58, ScreenWidth - 40, FontLightMax.lineHeight);
        packSubTitleLabel.frame = CGRectMake(90, 95, ScreenWidth - 40, FontLightMiddle.lineHeight);
        
        packRightButton.frame = CGRectMake(ScreenWidth - 132, 56, 128, 32);
        
        packScrollView.frame = CGRectMake(90, 128, ScreenWidth - 180, ScreenHeight - 338);
        
    } else if (ScreenHeight == ScreenHeight480) {
        packTitleLabel.font = FontBig;
        packTitleLabel.frame = CGRectMake(26, 20, ScreenWidth - 40, FontLightMax.lineHeight);
        
        packSubTitleLabel.font = FontNormal;
        packSubTitleLabel.frame = CGRectMake(26, 48, ScreenWidth - 40, FontLightMiddle.lineHeight);
        
        packRightButton.frame = CGRectMake(ScreenWidth - 132, 24, 128, 32);
        
        packScrollView.frame = CGRectMake(37, 72, ScreenWidth - 74, ScreenHeight - 210);
        
    } else if (ScreenHeight == ScreenHeight568) {
        
        packTitleLabel.frame = CGRectMake(26, 27, ScreenWidth - 40, FontLightMax.lineHeight);
        packSubTitleLabel.frame = CGRectMake(26, 64, ScreenWidth - 40, FontLightMiddle.lineHeight);
        
        packRightButton.frame = CGRectMake(ScreenWidth - 132, 32, 128, 32);
        
        packScrollView.frame = CGRectMake(15, 97, ScreenWidth - 30, ScreenHeight - 210);
        
    } else {
        
        packTitleLabel.frame = CGRectMake(26, 58, ScreenWidth - 40, FontLightMax.lineHeight);
        packSubTitleLabel.frame = CGRectMake(26, 95, ScreenWidth - 40, FontLightMiddle.lineHeight);
        
        packRightButton.frame = CGRectMake(ScreenWidth - 132, 56, 128, 32);
        
        packScrollView.frame = CGRectMake(20, 128, ScreenWidth - 40, ScreenHeight - 210);
    }
    
    
    
    packScrollView.clipsToBounds = NO;
    packScrollView.pagingEnabled = YES;
    packScrollView.showsHorizontalScrollIndicator = NO;
    packScrollView.backgroundColor = [UIColor clearColor];
    packScrollView.delegate = self;
    packScrollView.tag = ScrollViewTagPack;
    [baseScrollView addSubview:packScrollView];
    
    
}

- (void)createCalendarLayout {
    if (calendarView) {
        return;
    }
    
    
    
    calendarView = [[UIView alloc] init];
    calendarView.frame = CGRectMake(0, baseScrollView.height, ScreenWidth, baseScrollView.height);
    
    [baseScrollView addSubview:calendarView];
    
    UIButton *legendButton = [[UIButton alloc] init];
    [legendButton setTitle:LocalizedString(@"button_title_legend") forState:UIControlStateNormal];
    [legendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    legendButton.frame = CGRectMake(0, 20, 80, 44);
    legendButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    legendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [legendButton addTarget:self action:@selector(legendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    legendButton.titleLabel.font = FontMiddle;
    [calendarView addSubview:legendButton];
    
    // 除去说明，标题，今日三个项目剩下的空间留给两个按钮
    CGFloat buttonWidth = (ScreenWidth - 64 * 3) / 2;
    
    UIButton *lastButton = [[UIButton alloc] init];
    lastButton.frame = CGRectMake(64, 20, buttonWidth, 44);
    [lastButton setImage:[UIImage imageNamed:@"Arrow_White_Left.png"] forState:UIControlStateNormal];
    lastButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    lastButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [lastButton addTarget:self action:@selector(lastButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [calendarView addSubview:lastButton];
    
    
    UIButton *nextButton = [[UIButton alloc] init];
    nextButton.frame = CGRectMake(ScreenWidth - buttonWidth - 64, 20, buttonWidth, 44);
    [nextButton setImage:[UIImage imageNamed:@"Arrow_White_Right.png"] forState:UIControlStateNormal];
    nextButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    nextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
    [todayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [todayButton setTitle:LocalizedString(@"button_title_today") forState:UIControlStateNormal];
    todayButton.titleLabel.font = FontMiddle;
    [calendarView addSubview:todayButton];
    
    
    
    CGFloat currentY = 64;
    
    if (ScreenHeight != ScreenHeight480) {
        bannerView = [[AdBannerView alloc] init];
        bannerView.adUnitID = AdMobUnitIdCalendar;
        bannerView.rootViewController = self;
        [bannerView loadRequest:[AdManager request]];
        bannerView.frame = CGRectMake(0, 64, ScreenWidth, 50);
        [calendarView addSubview:bannerView];
        
        currentY += 50;
    }
    
    
    CGFloat size = ScreenWidth / 7;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = ColorGrayDark;
    lineView.frame = CGRectMake(0, currentY, ScreenWidth, 0.5);
    [calendarView addSubview:lineView];
    
    NSArray *weekdayArray = @[@1, @2, @3, @4, @5, @6, @7];
    
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
    messageTableView.rowHeight = [MessageCell cellHeight];
    messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [calendarView addSubview:messageTableView];
    [MessageManager getInstance].messageTableView = messageTableView;
    
    
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
     
    float buttonWidth = (ScreenWidth - 70) / 2;
    
    helpButton = [[UIButton alloc] init];
    helpButton.frame = CGRectMake(0, ScreenHeight - 80, buttonWidth, 70);
    [helpButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setTitle:LocalizedString(@"button_title_help") forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    helpButton.titleLabel.font = FontMiddle;
    [self.view addSubview:helpButton];
    
    mainButton = [[UIButton alloc] init];
    mainButton.frame = CGRectMake((ScreenWidth - 70) / 2, ScreenHeight - 80, 70, 70);
    [mainButton addTarget:self action:@selector(mainButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [mainButton setBackgroundImage:[UIImage imageNamed:@"Btn_Calendar.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:mainButton];

    
    settingButton = [[UIButton alloc] init];
    settingButton.frame = CGRectMake((ScreenWidth + 70) / 2, ScreenHeight - 80, buttonWidth, 70);
    [settingButton addTarget:self action:@selector(settingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setTitle:LocalizedString(@"button_title_setting") forState:UIControlStateNormal];
    settingButton.titleLabel.font = FontMiddle;
    [settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:settingButton];
    
    helpView = [[HelpView alloc] init];
    helpView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:helpView];

}

- (void)createSettingAlertLayout {
    if (settingAlertImageView == nil) {
        settingAlertImageView = [[UIImageView alloc] init];
        
        settingAlertImageView.image = [UIImage imageNamed:@"Icon_alert.png"];
        [self.view addSubview:settingAlertImageView];
        
        [self.view bringSubviewToFront:helpView];
    }
}

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    shouldCheckTodayPack = YES;
    moveToTodayAnimate = NO;
    
    [[CalendarViewDelegate getInstance] resetView];
    
    [self createLayout];
    
    // 预加载设置页广告
    [AdManager settingView];
    
    if (![AppManager hasFirstOpened]) {
        
        startView = [[StartView alloc] init];
        startView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [startView addTarget:self action:@selector(settingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [startView addTarget:[AppManager class] action:@selector(setFirstOpened) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:startView];
        
        
        baseScrollView.hidden = YES;
        helpButton.hidden = YES;
        mainButton.hidden = YES;
        settingButton.hidden = YES;
    } else if (![AppManager hasFirstSetDone]) {
        SettingViewController *settingViewController = [[SettingViewController alloc] init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
        [self presentViewController:navigationController animated:NO completion:NULL];
    } else {
        
        [self performSelector:@selector(checkSetting) withObject:nil afterDelay:1];
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (baseScrollView.contentOffset.y != 0) {
        //显示日历中
        [AnalyticsUtil beginEventDistinguishInitial:Event_view_calendar];
    }
    
    if (![AppManager hasFirstPackShowed]) {
        [AppManager setFirstPackShowed];
    }
    
    if ([AppManager hasFirstSetDone] && ![HelpView PackHelpHasShowed]) {
        [helpView showPackHelp];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self reloadView];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (baseScrollView.contentOffset.y != 0) {
        //显示日历中
        [AnalyticsUtil endEventDistinguishInitial:Event_view_calendar];
    }
    
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


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == ScrollViewTagPack) {
        
    }
    
    
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
        
        [self resetPackInfo];
        
        if (scrollView.contentOffset.x != todayPackX) {
            //非当前药板
            [AnalyticsUtil eventDistinguishInitialAndOnceActive:Event_view_future_pack];
            
            [[FeedBackView getInstance] hide];
        } else if (scrollView.contentOffset.x == todayPackX) {
            //返回当前药板
            [AnalyticsUtil event:Event_back_to_current_pack_swipe];
        }
    }
    
}



@end
