//
//  CalendarHomeViewController.m
//  Calendar
//
//  Created by 张凡 on 14-6-23.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarHomeViewController.h"
#import "Color.h"

#import "SettingViewController.h"

#import "HelpView.h"

#import "MessageManager.h"

@interface CalendarHomeViewController () <UITableViewDelegate>
{

    UITableView *messageTableView;
    
    UIButton *helpButton;
    UIButton *packButton;
    UIButton *settingButton;
    
    int daynumber;//天数
    int optiondaynumber;//选择日期数量
//    NSMutableArray *optiondayarray;//存放选择好的日期对象数组
    
}

@end

@implementation CalendarHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)helpButtonPressed {
    
    
    
    [HelpView getInstance].show = YES;
    
}

- (void)calendarButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)settingButtonPressed {
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    
    
    
    [self presentViewController:settingViewController animated:YES completion:NULL];
}

- (void)createLayout {
    messageTableView = [[UITableView alloc] init];
    messageTableView.frame = CGRectMake(0, 300, ScreenWidth, 260);
    messageTableView.dataSource = [MessageManager getInstance];
    [self.view addSubview:messageTableView];
    messageTableView.delegate = self;
    //messageTableView.editing = YES;
    
    
    float buttonWidth = (ScreenWidth - 120) / 3;
    
    helpButton = [[UIButton alloc] init];
    helpButton.frame = CGRectMake(40, ScreenHeight - 128, buttonWidth, 48);
    [helpButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setTitle:@"Help" forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    helpButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:helpButton];
    
    packButton = [[UIButton alloc] init];
    packButton.frame = CGRectMake(40 + 20 + buttonWidth, ScreenHeight - 128, buttonWidth, 48);
    [packButton addTarget:self action:@selector(calendarButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [packButton setTitle:@"Pack" forState:UIControlStateNormal];
    [packButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    packButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:packButton];
    
    
    settingButton = [[UIButton alloc] init];
    settingButton.frame = CGRectMake(40 + (20 + buttonWidth) * 2, ScreenHeight - 128, buttonWidth, 48);
    [settingButton addTarget:self action:@selector(settingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setTitle:@"Setting" forState:UIControlStateNormal];
    [settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    settingButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:settingButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self createLayout];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除的操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [MessageManager deleteMessage:[NSString stringWithInteger:cell.tag]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    }
}
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [MessageManager deleteMessage:[NSString stringWithInteger:cell.tag]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //[tableView reloadData];
        
    }];
    
    return @[deleteAction];
}


#pragma mark - 设置方法

//飞机初始化方法
- (void)setAirPlaneToDay:(int)day ToDateforString:(NSString *)todate
{
    daynumber = day;
    optiondaynumber = 1;//选择一个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collectionView reloadData];//刷新
}

//酒店初始化方法
- (void)setHotelToDay:(int)day ToDateforString:(NSString *)todate
{

    daynumber = day;
    optiondaynumber = 2;//选择两个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collectionView reloadData];//刷新
}


//火车初始化方法
- (void)setTrainToDay:(int)day ToDateforString:(NSString *)todate
{
    daynumber = day;
    optiondaynumber = 1;//选择一个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collectionView reloadData];//刷新
    
}



#pragma mark - 逻辑代码初始化

//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfDayNumber:(int)day ToDateforString:(NSString *)todate
{
    
    NSDate *date = [NSDate date];
    
    NSDate *selectdate  = [NSDate date];
    
    if (todate) {
        
        selectdate = [selectdate dateFromString:todate];
        
    }
    
    super.Logic = [[CalendarLogic alloc]init];
    
    return [super.Logic reloadCalendarView:date selectDate:selectdate  needDays:day];
}



#pragma mark - 设置标题

- (void)setCalendartitle:(NSString *)calendartitle
{

    [self.navigationItem setTitle:calendartitle];

}


@end
