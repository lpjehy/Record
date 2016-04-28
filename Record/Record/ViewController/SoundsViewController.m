//
//  SoundsViewController.m
//  Record
//
//  Created by Jehy Fan on 16/3/28.
//  Copyright © 2016年 Jehy Fan. All rights reserved.
//

#import "SoundsViewController.h"

#import "ReminderManager.h"

#import "AudioManager.h"

@interface SoundsViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *mainTableView;
    
}

@property(nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation SoundsViewController

@synthesize selectedIndexPath;

- (void)createLayout {
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.frame = CGRectMake(15, 20, 64, 44);
    [leftButton setTitle:NSLocalizedString(@"button_title_back", nil) forState:UIControlStateNormal];
    leftButton.titleLabel.font = FontNormal;
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:leftButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"Sounds", nil);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.frame = CGRectMake(64, 20, ScreenWidth - 128, 44);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    self.view.backgroundColor = [UIColor colorWithWhite:68 / 255.0 alpha:1];
    
    mainTableView = [[UITableView alloc] init];
    mainTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundColor = [UIColor clearColor];
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
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    NSString *text = [[ReminderManager getInstance].soundArray validObjectAtIndex:indexPath.row];;
    cell.textLabel.text = text;
    
    if ([text isEqualToString:[ReminderManager notificationSound]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedIndexPath = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:NO animated:YES];
    
    if (selectedIndexPath.row != indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        cell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    self.selectedIndexPath = indexPath;
    
    NSArray *soundArray = [ReminderManager getInstance].soundArray;
    NSString *filename = [soundArray validObjectAtIndex:indexPath.row];
    
    [[AudioManager getInstance] playWithFilename:filename];
      
    
    [ReminderManager setNotificationSound:filename];
    
}


@end
