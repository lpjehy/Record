//
//  SoundsViewController.m
//  Record
//
//  Created by Jehy Fan on 16/3/28.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "SoundsViewController.h"

#import "ReminderManager.h"

@interface SoundsViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *mainTableView;
}

@end

@implementation SoundsViewController

- (void)createLayout {
    [self setNavigationBarTitle:@"Sounds"];
    [self showBack];
    
    mainTableView = [[UITableView alloc] init];
    mainTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [ReminderManager getInstance].soundArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        
    }
    
    cell.textLabel.text = [[ReminderManager getInstance].soundArray validObjectAtIndex:indexPath.row];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *soundArray = [ReminderManager getInstance].soundArray;
    NSString *filename = [soundArray validObjectAtIndex:indexPath.row];
    [ReminderManager setNotificationSound:filename];
    
    [[ReminderManager getInstance] playAudio:filename];
}


@end
